package com.japetnese.app.model

import android.content.Context
import android.content.SharedPreferences
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.util.Calendar

class PetManager private constructor(context: Context) {
    private val prefs: SharedPreferences = context.getSharedPreferences("japetnese", Context.MODE_PRIVATE)
    private val gson = Gson()

    var store: PetStore
        private set

    init {
        store = loadStore()
    }

    private fun loadStore(): PetStore {
        val json = prefs.getString("petStore", null) ?: return PetStore()
        return try {
            gson.fromJson(json, PetStore::class.java) ?: PetStore()
        } catch (e: Exception) {
            PetStore()
        }
    }

    fun save() {
        prefs.edit().putString("petStore", gson.toJson(store)).apply()
    }

    val currentPet: Pet?
        get() = store.currentPetId?.let { id -> store.collection.find { it.id == id } }

    // Display Mode
    var displayMode: DisplayMode
        get() {
            val raw = prefs.getString("displayMode", "KANJI_ONLY") ?: "KANJI_ONLY"
            return try { DisplayMode.valueOf(raw) } catch (e: Exception) { DisplayMode.KANJI_ONLY }
        }
        set(value) { prefs.edit().putString("displayMode", value.name).apply() }

    var widgetColorMode: WidgetColorMode
        get() {
            val raw = prefs.getString("widgetColorMode", "SYSTEM") ?: "SYSTEM"
            return try { WidgetColorMode.valueOf(raw) } catch (e: Exception) { WidgetColorMode.SYSTEM }
        }
        set(value) { prefs.edit().putString("widgetColorMode", value.name).apply() }

    var hasCompletedOnboarding: Boolean
        get() = prefs.getBoolean("hasCompletedOnboarding", false)
        set(value) { prefs.edit().putBoolean("hasCompletedOnboarding", value).apply() }

    // Gacha
    fun rollGacha(): Pet {
        val species = PetSpecies.entries.random()
        val rarity = rollRarity()
        val maxVariants = if (rarity == PetRarity.LEGENDARY) 1 else (variantCounts[species] ?: 2)
        val variant = if (rarity == PetRarity.LEGENDARY) 0 else (0 until maxVariants).random()
        val accessory = PetAccessory.entries.random()

        val pet = Pet(
            species = species, rarity = rarity, colorVariant = variant,
            accessory = accessory
        )

        store.collection.add(pet)
        if (store.currentPetId == null) {
            store.currentPetId = pet.id
            store.collection.last().equippedSince = System.currentTimeMillis()
        }
        save()
        return pet
    }

    fun useFreeGacha(): Pet {
        val pet = rollGacha()
        store.freeGachaUsed = true
        save()
        return pet
    }

    fun useAdGacha(): Pet {
        val pet = rollGacha()
        val today = Calendar.getInstance().get(Calendar.DAY_OF_YEAR)
        val lastDay = store.lastAdGachaDate?.let {
            Calendar.getInstance().apply { timeInMillis = it }.get(Calendar.DAY_OF_YEAR)
        }
        if (lastDay == today) {
            store.adGachaCountToday++
        } else {
            store.adGachaCountToday = 1
            store.lastAdGachaDate = System.currentTimeMillis()
        }
        save()
        return pet
    }

    val canFreeGacha: Boolean get() = !store.freeGachaUsed

    val canAdGacha: Boolean get() {
        val today = Calendar.getInstance().get(Calendar.DAY_OF_YEAR)
        val lastDay = store.lastAdGachaDate?.let {
            Calendar.getInstance().apply { timeInMillis = it }.get(Calendar.DAY_OF_YEAR)
        }
        return if (lastDay == today) store.adGachaCountToday < 3 else true
    }

    val adGachaRemaining: Int get() {
        val today = Calendar.getInstance().get(Calendar.DAY_OF_YEAR)
        val lastDay = store.lastAdGachaDate?.let {
            Calendar.getInstance().apply { timeInMillis = it }.get(Calendar.DAY_OF_YEAR)
        }
        return if (lastDay == today) 3 - store.adGachaCountToday else 3
    }

    fun equipPet(id: String) {
        // Unequip current
        store.currentPetId?.let { currentId ->
            store.collection.find { it.id == currentId }?.let { old ->
                old.equippedSince?.let { since ->
                    old.accumulatedGrowth += System.currentTimeMillis() - since
                }
                old.equippedSince = null
            }
        }
        // Equip new
        store.collection.find { it.id == id }?.let { pet ->
            pet.equippedSince = System.currentTimeMillis()
        }
        store.currentPetId = id
        save()
    }

    private fun rollRarity(): PetRarity {
        val roll = Math.random()
        return when {
            roll < PetRarity.LEGENDARY.probability -> PetRarity.LEGENDARY
            roll < PetRarity.LEGENDARY.probability + PetRarity.RARE.probability -> PetRarity.RARE
            else -> PetRarity.NORMAL
        }
    }

    companion object {
        @Volatile private var instance: PetManager? = null

        fun getInstance(context: Context): PetManager {
            return instance ?: synchronized(this) {
                instance ?: PetManager(context.applicationContext).also { instance = it }
            }
        }

        val variantCounts = mapOf(
            PetSpecies.CAT to 5, PetSpecies.SHIBA to 4, PetSpecies.RABBIT to 4,
            PetSpecies.FOX to 3, PetSpecies.RACCOON to 3, PetSpecies.PENGUIN to 3,
            PetSpecies.HAMSTER to 3, PetSpecies.JELLYFISH to 3, PetSpecies.GOLDFISH to 3,
            PetSpecies.CLOWNFISH to 2, PetSpecies.OTTER to 2, PetSpecies.SQUIRREL to 3,
            PetSpecies.POLAR_BEAR to 2, PetSpecies.FROG to 3, PetSpecies.PANDA to 2,
            PetSpecies.TURTLE to 3, PetSpecies.MONKEY to 3, PetSpecies.DUCK to 3,
            PetSpecies.PARROT to 3, PetSpecies.HEDGEHOG to 3, PetSpecies.WHALE to 3,
            PetSpecies.DOLPHIN to 2, PetSpecies.LIZARD to 3
        )
    }
}
