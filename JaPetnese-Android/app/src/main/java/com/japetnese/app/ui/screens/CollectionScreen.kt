package com.japetnese.app.ui.screens

import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Pets
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.japetnese.app.model.*
import com.japetnese.app.ui.components.PixelPetView
import com.japetnese.app.ui.theme.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CollectionScreen(petManager: PetManager) {
    Scaffold(topBar = {
        TopAppBar(title = { Text("도감") }, colors = TopAppBarDefaults.topAppBarColors(containerColor = BgMain))
    }) { padding ->
        if (petManager.store.collection.isEmpty()) {
            Box(modifier = Modifier.fillMaxSize().padding(padding), contentAlignment = Alignment.Center) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Icon(Icons.Default.Pets, "펫", tint = TextTertiary, modifier = Modifier.size(36.dp))
                    Spacer(modifier = Modifier.height(16.dp))
                    Text("아직 펫이 없어요", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = TextSecondary)
                    Spacer(modifier = Modifier.height(8.dp))
                    Text("뽑기에서 첫 번째 펫을 뽑아보세요!", fontSize = 13.sp, color = TextTertiary)
                }
            }
        } else {
            LazyVerticalGrid(
                columns = GridCells.Fixed(2),
                contentPadding = PaddingValues(16.dp),
                horizontalArrangement = Arrangement.spacedBy(12.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp),
                modifier = Modifier.padding(padding)
            ) {
                items(petManager.store.collection) { pet ->
                    PetCard(pet, petManager.store.currentPetId == pet.id) {
                        petManager.equipPet(pet.id)
                    }
                }
            }
        }
    }
}

@Composable
fun PetCard(pet: Pet, isEquipped: Boolean, onTap: () -> Unit) {
    val borderMod = if (isEquipped) Modifier.border(2.dp, Color.Black, RoundedCornerShape(18.dp)) else Modifier

    Card(
        onClick = onTap,
        modifier = Modifier.fillMaxWidth().height(250.dp).then(borderMod)
            .shadow(if (isEquipped) 8.dp else 4.dp, RoundedCornerShape(18.dp)),
        shape = RoundedCornerShape(18.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White)
    ) {
        Column(
            modifier = Modifier.fillMaxSize().padding(12.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            // Pet sprite
            PixelPetView(pet = pet, pixelSize = 4.5f, animated = isEquipped)
            Spacer(modifier = Modifier.height(14.dp))

            // Name
            Text(pet.displaySpeciesName, fontSize = 15.sp, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.height(4.dp))
            Text(pet.displayJapaneseName, fontSize = 10.sp, color = TextSecondary)

            Spacer(modifier = Modifier.height(10.dp))

            // Stage dots
            Row(horizontalArrangement = Arrangement.spacedBy(2.dp), verticalAlignment = Alignment.CenterVertically) {
                val stages = listOf(PetStage.EGG, PetStage.BABY, PetStage.JUVENILE, PetStage.ADULT)
                stages.forEachIndexed { i, s ->
                    val done = stageOrder(pet.stage) >= stageOrder(s)
                    val current = pet.stage == s
                    Box(
                        modifier = Modifier
                            .size(if (current) 7.dp else 5.dp)
                            .clip(CircleShape)
                            .then(if (done) Modifier else Modifier)
                    ) {
                        Surface(
                            modifier = Modifier.fillMaxSize(),
                            shape = CircleShape,
                            color = if (done) Color.Black else Color.Black.copy(alpha = 0.1f)
                        ) {}
                    }
                    if (i < stages.lastIndex) {
                        Surface(modifier = Modifier.width(10.dp).height(1.dp),
                            color = if (stageOrder(pet.stage) > stageOrder(s)) Color.Black.copy(0.2f) else Color.Black.copy(0.06f)) {}
                    }
                }
            }

            Spacer(modifier = Modifier.weight(1f))

            // Progress or badges
            if (pet.stage != PetStage.ADULT) {
                LinearProgressIndicator(
                    progress = { pet.stageProgress.toFloat() },
                    modifier = Modifier.fillMaxWidth().height(3.dp).clip(RoundedCornerShape(2.dp)),
                    color = Color.Black.copy(0.2f),
                    trackColor = Color.Black.copy(0.05f)
                )
                pet.nextStageIn?.let {
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(it, fontSize = 9.sp, color = TextTertiary)
                }
            }

            Spacer(modifier = Modifier.height(8.dp))

            // Badges
            Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                if (pet.stage == PetStage.ADULT) {
                    Surface(shape = RoundedCornerShape(12.dp), color = rarityColor(pet.rarity).copy(alpha = 0.1f)) {
                        Text(pet.rarity.displayName, modifier = Modifier.padding(horizontal = 10.dp, vertical = 4.dp),
                            fontSize = 10.sp, fontWeight = FontWeight.Bold, color = rarityColor(pet.rarity))
                    }
                }
                if (isEquipped) {
                    Surface(shape = RoundedCornerShape(12.dp), color = Color.Black) {
                        Text("장착 중", modifier = Modifier.padding(horizontal = 10.dp, vertical = 4.dp),
                            fontSize = 9.sp, fontWeight = FontWeight.Bold, color = Color.White)
                    }
                }
            }
        }
    }
}

private fun stageOrder(stage: PetStage) = when (stage) {
    PetStage.EGG -> 0; PetStage.BABY -> 1; PetStage.JUVENILE -> 2; PetStage.ADULT -> 3
}

private fun rarityColor(rarity: PetRarity) = when (rarity) {
    PetRarity.NORMAL -> Color.Gray
    PetRarity.RARE -> Color.Blue
    PetRarity.LEGENDARY -> Color(0xFFFF9800)
}
