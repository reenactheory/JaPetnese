package com.japetnese.app.ui.screens

import androidx.compose.animation.core.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.japetnese.app.model.*
import com.japetnese.app.ui.components.PixelPetView
import com.japetnese.app.ui.theme.*
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GachaScreen(petManager: PetManager) {
    var rolledPet by remember { mutableStateOf<Pet?>(null) }
    var isRolling by remember { mutableStateOf(false) }
    var showResult by remember { mutableStateOf(false) }
    var storeVersion by remember { mutableIntStateOf(0) }
    var drawnItem by remember { mutableStateOf<com.japetnese.app.model.PetItem?>(null) }
    var showItemResult by remember { mutableStateOf(false) }

    Scaffold(topBar = {
        TopAppBar(title = { Text("뽑기") }, colors = TopAppBarDefaults.topAppBarColors(containerColor = BgMain))
    }) { padding ->
        @Suppress("UNUSED_EXPRESSION")
        storeVersion // trigger recomposition
        Column(
            modifier = Modifier.fillMaxSize().padding(padding).padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            // Display area
            Card(
                modifier = Modifier.fillMaxWidth().height(260.dp),
                shape = RoundedCornerShape(28.dp),
                colors = CardDefaults.cardColors(containerColor = Color.White)
            ) {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    when {
                        showResult && rolledPet != null -> {
                            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                PixelPetView(pet = rolledPet!!, pixelSize = 10f, animated = true)
                                Spacer(modifier = Modifier.height(16.dp))
                                Text("알을 획득했어요!", fontSize = 18.sp, fontWeight = FontWeight.Bold)
                                Spacer(modifier = Modifier.height(4.dp))
                                Text("어떤 동물이 태어날까요?", fontSize = 13.sp, color = TextSecondary)
                                rolledPet?.nextStageIn?.let {
                                    Spacer(modifier = Modifier.height(8.dp))
                                    Text("부화까지 $it", fontSize = 12.sp, color = TextTertiary)
                                }
                                Spacer(modifier = Modifier.height(12.dp))
                                Button(onClick = { showResult = false; rolledPet = null }) {
                                    Text("확인")
                                }
                            }
                        }
                        isRolling -> {
                            val rotation by rememberInfiniteTransition(label = "shake").animateFloat(
                                initialValue = -5f, targetValue = 5f,
                                animationSpec = infiniteRepeatable(tween(100), RepeatMode.Reverse), label = "shake"
                            )
                            val eggPet = remember { Pet(species = PetSpecies.CAT, rarity = PetRarity.NORMAL, colorVariant = 0, accessory = null) }
                            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                Box(modifier = Modifier.rotate(rotation)) {
                                    PixelPetView(pet = eggPet, pixelSize = 10f)
                                }
                                Spacer(modifier = Modifier.height(16.dp))
                                Text("두근두근...", fontSize = 14.sp, color = TextSecondary)
                            }
                        }
                        else -> {
                            val eggPet = remember { Pet(species = PetSpecies.CAT, rarity = PetRarity.NORMAL, colorVariant = 0, accessory = null) }
                            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                PixelPetView(pet = eggPet, pixelSize = 8f)
                                Spacer(modifier = Modifier.height(16.dp))
                                Text("알을 뽑아보세요!", fontSize = 15.sp, fontWeight = FontWeight.Medium, color = TextSecondary)
                                Text("어떤 동물이 나올지 모릅니다", fontSize = 12.sp, color = TextTertiary)
                            }
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Buttons
            if (petManager.canFreeGacha) {
                GachaButton("무료 뽑기", "첫 1회 무료!", Icons.Default.CardGiftcard) {
                    isRolling = true
                    kotlinx.coroutines.GlobalScope.launch(kotlinx.coroutines.Dispatchers.Main) {
                        delay(1500)
                        rolledPet = petManager.useFreeGacha()
                        isRolling = false
                        showResult = true
                    }
                }
            }

            if (petManager.canAdGacha) {
                GachaButton("광고 보고 뽑기", "오늘 ${petManager.adGachaRemaining}회 남음", Icons.Default.PlayCircle) {
                    isRolling = true
                    kotlinx.coroutines.GlobalScope.launch(kotlinx.coroutines.Dispatchers.Main) {
                        delay(1500)
                        rolledPet = petManager.useAdGacha()
                        isRolling = false
                        showResult = true
                    }
                }
            }

            GachaButton("뽑기권 구매", "스토어로 이동", Icons.Default.ShoppingCart) {}

            if (petManager.canAdItemDraw) {
                GachaButton(
                    title = "광고 보고 아이템 받기",
                    subtitle = "12시간 ${petManager.adItemRemaining}회 남음 • 먹이/성장물약/슬롯티켓",
                    icon = Icons.Default.Redeem
                ) {
                    val item = petManager.useAdItemDraw()
                    drawnItem = item
                    showItemResult = true
                    storeVersion++
                }
            } else {
                Card(
                    modifier = Modifier.fillMaxWidth().padding(vertical = 6.dp),
                    shape = RoundedCornerShape(16.dp),
                    colors = CardDefaults.cardColors(containerColor = Color.White.copy(alpha = 0.5f))
                ) {
                    Row(
                        modifier = Modifier.padding(horizontal = 20.dp, vertical = 16.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(Icons.Default.Redeem, "아이템", tint = TextTertiary)
                        Spacer(modifier = Modifier.width(14.dp))
                        Column(modifier = Modifier.weight(1f)) {
                            Text("광고 보고 아이템 받기", fontSize = 15.sp, fontWeight = FontWeight.SemiBold, color = TextSecondary)
                            Text("12시간 후 다시 받을 수 있어요", fontSize = 11.sp, color = TextTertiary)
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(16.dp))
            Text("수집한 펫: ${petManager.store.collection.size}마리", fontSize = 12.sp, color = TextTertiary)
        }
    }

    // 광고 아이템 획득 결과 다이얼로그
    if (showItemResult && drawnItem != null) {
        AdItemResultDialog(
            item = drawnItem!!,
            onDismiss = {
                showItemResult = false
                drawnItem = null
            }
        )
    }
}

@Composable
fun AdItemResultDialog(item: com.japetnese.app.model.PetItem, onDismiss: () -> Unit) {
    val emoji = when (item) {
        com.japetnese.app.model.PetItem.FOOD -> "🍖"
        com.japetnese.app.model.PetItem.GROWTH_POTION -> "✨"
        com.japetnese.app.model.PetItem.DUAL_SLOT_TICKET -> "🎫"
    }
    val particle = when (item) {
        com.japetnese.app.model.PetItem.FOOD -> "🍖❤️✨"
        com.japetnese.app.model.PetItem.GROWTH_POTION -> "✨⭐💫"
        com.japetnese.app.model.PetItem.DUAL_SLOT_TICKET -> "🎉🎊⭐"
    }

    androidx.compose.ui.window.Dialog(onDismissRequest = onDismiss) {
        Card(
            shape = RoundedCornerShape(24.dp),
            colors = CardDefaults.cardColors(containerColor = Color.White)
        ) {
            Column(
                modifier = Modifier.padding(28.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(particle, fontSize = 28.sp)
                Spacer(modifier = Modifier.height(12.dp))
                Text(emoji, fontSize = 48.sp)
                Spacer(modifier = Modifier.height(12.dp))
                Text("아이템을 획득했어요!", fontSize = 16.sp, fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(4.dp))
                Text(item.displayName, fontSize = 18.sp, fontWeight = FontWeight.Bold, color = TextSecondary)
                Spacer(modifier = Modifier.height(4.dp))
                Text(item.description, fontSize = 12.sp, color = TextTertiary)
                Spacer(modifier = Modifier.height(20.dp))
                Button(
                    onClick = onDismiss,
                    modifier = Modifier.fillMaxWidth(),
                    colors = ButtonDefaults.buttonColors(containerColor = Color.Black)
                ) {
                    Text("확인")
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GachaButton(title: String, subtitle: String, icon: ImageVector, onClick: () -> Unit) {
    Card(
        onClick = onClick,
        modifier = Modifier.fillMaxWidth().padding(vertical = 6.dp),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White)
    ) {
        Row(
            modifier = Modifier.padding(horizontal = 20.dp, vertical = 16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(icon, title, tint = Color.Black.copy(alpha = 0.6f))
            Spacer(modifier = Modifier.width(14.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(title, fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
                Text(subtitle, fontSize = 11.sp, color = TextSecondary)
            }
            Icon(Icons.Default.ChevronRight, "go", tint = TextTertiary)
        }
    }
}
