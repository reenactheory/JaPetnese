package com.japetnese.app.model

import java.util.UUID

enum class PetSpecies(val displayName: String, val japaneseName: String) {
    CAT("고양이", "ねこ"), SHIBA("시바견", "しば"), RABBIT("토끼", "うさぎ"),
    FOX("여우", "きつね"), RACCOON("너구리", "たぬき"), PENGUIN("펭귄", "ペンギン"),
    HAMSTER("햄스터", "ハムスター"), JELLYFISH("해파리", "くらげ"),
    GOLDFISH("금붕어", "きんぎょ"), CLOWNFISH("흰동가리", "クマノミ"),
    OTTER("해달", "ラッコ"), SQUIRREL("다람쥐", "リス"),
    POLAR_BEAR("북극곰", "しろくま"), FROG("개구리", "かえる"),
    PANDA("판다", "パンダ"), TURTLE("거북이", "かめ"),
    MONKEY("원숭이", "さる"), DUCK("오리", "あひる"),
    PARROT("앵무새", "インコ"), HEDGEHOG("고슴도치", "はりねずみ"),
    WHALE("고래", "くじら"), DOLPHIN("돌고래", "イルカ"),
    LIZARD("도마뱀", "トカゲ")
}

enum class PetRarity(val displayName: String, val probability: Double) {
    NORMAL("노멀", 0.70),
    RARE("레어", 0.25),
    LEGENDARY("레전더리", 0.05)
}

enum class PetStage(val displayName: String) {
    EGG("알"), BABY("유아기"), JUVENILE("청소년기"), ADULT("성체")
}

enum class PetAccessory(val displayName: String) {
    CROWN("왕관"), RIBBON("리본"), HALO("천사 고리"), FLOWER_CROWN("꽃관")
}

enum class DisplayMode { KANJI_ONLY, FURIGANA, HIRAGANA_ONLY }

enum class WidgetColorMode(val displayName: String, val description: String) {
    SYSTEM("시스템 모드", "라이트/다크 모드를 따릅니다"),
    PET_COLOR("캐릭터 색상", "장착한 펫의 색상이 반영됩니다")
}

data class Pet(
    val id: String = UUID.randomUUID().toString(),
    val species: PetSpecies,
    val rarity: PetRarity,
    val colorVariant: Int,
    val accessory: PetAccessory?,
    val createdAt: Long = System.currentTimeMillis(),
    var accumulatedGrowth: Long = 0L, // milliseconds
    var equippedSince: Long? = null   // timestamp or null
) {
    val totalGrowthHours: Double
        get() {
            var total = accumulatedGrowth.toDouble()
            equippedSince?.let { since ->
                total += (System.currentTimeMillis() - since).toDouble()
            }
            return total / 3_600_000.0
        }

    val stage: PetStage
        get() {
            val hours = totalGrowthHours
            return when {
                hours < 12 -> PetStage.EGG
                hours < 36 -> PetStage.BABY
                hours < 72 -> PetStage.JUVENILE
                else -> PetStage.ADULT
            }
        }

    val isEquipped: Boolean get() = equippedSince != null
    val isRevealed: Boolean get() = stage != PetStage.EGG
    val isNameRevealed: Boolean get() = stage == PetStage.ADULT

    val displaySpeciesName: String
        get() = if (stage == PetStage.EGG || stage == PetStage.BABY) "???" else species.displayName

    val displayJapaneseName: String
        get() = if (stage == PetStage.ADULT) species.japaneseName else "???"

    val displayRarityName: String
        get() = if (stage == PetStage.ADULT) rarity.displayName else "???"

    val stageProgress: Double
        get() {
            val hours = totalGrowthHours
            return when (stage) {
                PetStage.EGG -> (hours / 12.0).coerceAtMost(1.0)
                PetStage.BABY -> ((hours - 12) / 24.0).coerceAtMost(1.0)
                PetStage.JUVENILE -> ((hours - 36) / 36.0).coerceAtMost(1.0)
                PetStage.ADULT -> 1.0
            }
        }

    val nextStageIn: String?
        get() {
            val hours = totalGrowthHours
            data class Threshold(val h: Double, val label: String)
            val thresholds = listOf(Threshold(12.0, "부화"), Threshold(36.0, "성장"), Threshold(72.0, "진화"))
            for (t in thresholds) {
                if (hours < t.h) {
                    if (!isEquipped) return "장착하면 성장해요"
                    val remaining = t.h - hours
                    return if (remaining < 1) "${(remaining * 60).toInt()}분" else "${remaining.toInt()}시간"
                }
            }
            return null
        }
}

data class PetStore(
    var currentPetId: String? = null,
    var collection: MutableList<Pet> = mutableListOf(),
    var freeGachaUsed: Boolean = false,
    var gachaTickets: Int = 0,
    var adGachaCountToday: Int = 0,
    var lastAdGachaDate: Long? = null
)
