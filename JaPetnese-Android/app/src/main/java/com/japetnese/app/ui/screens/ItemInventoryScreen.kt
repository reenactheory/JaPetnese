package com.japetnese.app.ui.screens

import androidx.compose.animation.core.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import com.japetnese.app.model.Pet
import com.japetnese.app.model.PetItem
import com.japetnese.app.model.PetManager
import com.japetnese.app.model.PetStage
import com.japetnese.app.ui.components.PixelPetView
import com.japetnese.app.ui.theme.*
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ItemInventoryScreen(petManager: PetManager) {
    var storeVersion by remember { mutableIntStateOf(0) }
    var selectedItem by remember { mutableStateOf<PetItem?>(null) }
    var showPetSelector by remember { mutableStateOf(false) }
    var showQuantityDialog by remember { mutableStateOf(false) }
    var quantityToUse by remember { mutableIntStateOf(1) }
    var showResultDialog by remember { mutableStateOf(false) }
    var resultItem by remember { mutableStateOf<PetItem?>(null) }
    var resultSuccess by remember { mutableStateOf(false) }
    var selectedPetForUse by remember { mutableStateOf<Pet?>(null) }

    val items = PetItem.entries

    fun refreshStore() { storeVersion++ }

    Scaffold(topBar = {
        TopAppBar(
            title = { Text("아이템") },
            colors = TopAppBarDefaults.topAppBarColors(containerColor = BgMain)
        )
    }) { padding ->
        @Suppress("UNUSED_EXPRESSION")
        storeVersion // trigger recomposition

        val hasAnyItem = items.any { petManager.itemCount(it) > 0 }

        if (!hasAnyItem) {
            Box(
                modifier = Modifier.fillMaxSize().padding(padding),
                contentAlignment = Alignment.Center
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Icon(Icons.Default.Inventory2, "아이템", tint = TextTertiary, modifier = Modifier.size(40.dp))
                    Spacer(modifier = Modifier.height(16.dp))
                    Text("아이템이 없어요", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = TextSecondary)
                    Spacer(modifier = Modifier.height(8.dp))
                    Text("뽑기에서 광고를 보고 아이템을 받아보세요!", fontSize = 13.sp, color = TextTertiary)
                }
            }
        } else {
            LazyColumn(
                modifier = Modifier.fillMaxSize().padding(padding).padding(horizontal = 16.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp),
                contentPadding = PaddingValues(vertical = 16.dp)
            ) {
                items(items) { item ->
                    val count = petManager.itemCount(item)
                    if (count > 0) {
                        ItemCard(
                            item = item,
                            count = count,
                            onUse = {
                                selectedItem = item
                                when (item) {
                                    PetItem.DUAL_SLOT_TICKET -> {
                                        val success = petManager.useDualSlotTicket()
                                        resultItem = item
                                        resultSuccess = success
                                        showResultDialog = true
                                        refreshStore()
                                    }
                                    else -> {
                                        if (count > 1 && item == PetItem.FOOD) {
                                            showQuantityDialog = true
                                        } else {
                                            showPetSelector = true
                                        }
                                    }
                                }
                            }
                        )
                    }
                }
            }
        }
    }

    // 펫 선택 BottomSheet
    if (showPetSelector && selectedItem != null) {
        val usablePets = petManager.store.collection.filter { it.stage != PetStage.ADULT }
        PetSelectorBottomSheet(
            pets = usablePets,
            itemName = selectedItem!!.displayName,
            onDismiss = { showPetSelector = false },
            onSelectPet = { pet ->
                showPetSelector = false
                val item = selectedItem!!
                val success = when (item) {
                    PetItem.FOOD -> {
                        val times = if (showQuantityDialog) quantityToUse else 1
                        var anySuccess = false
                        repeat(times) {
                            if (petManager.useFood(pet.id)) anySuccess = true
                        }
                        anySuccess
                    }
                    PetItem.GROWTH_POTION -> petManager.useGrowthPotion(pet.id)
                    PetItem.DUAL_SLOT_TICKET -> false
                }
                selectedPetForUse = pet
                resultItem = item
                resultSuccess = success
                showResultDialog = true
                showQuantityDialog = false
                quantityToUse = 1
                refreshStore()
            }
        )
    }

    // 수량 선택 다이얼로그 (먹이 여러 개)
    if (showQuantityDialog && selectedItem == PetItem.FOOD) {
        val maxCount = petManager.itemCount(PetItem.FOOD)
        QuantityDialog(
            maxCount = maxCount,
            quantity = quantityToUse,
            onQuantityChange = { quantityToUse = it },
            onConfirm = {
                showQuantityDialog = false
                showPetSelector = true
            },
            onDismiss = {
                showQuantityDialog = false
                quantityToUse = 1
            }
        )
    }

    // 결과 다이얼로그
    if (showResultDialog && resultItem != null) {
        ItemResultDialog(
            item = resultItem!!,
            success = resultSuccess,
            pet = selectedPetForUse,
            onDismiss = {
                showResultDialog = false
                resultItem = null
                selectedPetForUse = null
            }
        )
    }
}

@Composable
fun ItemCard(item: PetItem, count: Int, onUse: () -> Unit) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(18.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White)
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Item icon
            Surface(
                shape = RoundedCornerShape(12.dp),
                color = BgMain,
                modifier = Modifier.size(52.dp)
            ) {
                Box(contentAlignment = Alignment.Center) {
                    Text(itemEmoji(item), fontSize = 24.sp)
                }
            }

            Spacer(modifier = Modifier.width(14.dp))

            Column(modifier = Modifier.weight(1f)) {
                Text(item.displayName, fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
                Spacer(modifier = Modifier.height(2.dp))
                Text(item.description, fontSize = 11.sp, color = TextSecondary, lineHeight = 15.sp)
                Spacer(modifier = Modifier.height(6.dp))
                Surface(
                    shape = RoundedCornerShape(8.dp),
                    color = Color.Black.copy(alpha = 0.06f)
                ) {
                    Text(
                        "보유 ${count}개",
                        modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp),
                        fontSize = 11.sp,
                        fontWeight = FontWeight.Medium,
                        color = TextSecondary
                    )
                }
            }

            Spacer(modifier = Modifier.width(12.dp))

            Button(
                onClick = onUse,
                shape = RoundedCornerShape(12.dp),
                colors = ButtonDefaults.buttonColors(containerColor = Color.Black)
            ) {
                Text("사용", fontSize = 13.sp)
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PetSelectorBottomSheet(
    pets: List<Pet>,
    itemName: String,
    onDismiss: () -> Unit,
    onSelectPet: (Pet) -> Unit
) {
    ModalBottomSheet(onDismissRequest = onDismiss) {
        Column(modifier = Modifier.padding(horizontal = 16.dp).padding(bottom = 32.dp)) {
            Text("어느 펫에게 $itemName 을/를 줄까요?", fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
            Spacer(modifier = Modifier.height(16.dp))

            if (pets.isEmpty()) {
                Box(modifier = Modifier.fillMaxWidth().padding(32.dp), contentAlignment = Alignment.Center) {
                    Text("성장 가능한 펫이 없어요", color = TextSecondary, fontSize = 14.sp)
                }
            } else {
                pets.forEach { pet ->
                    Card(
                        onClick = { onSelectPet(pet) },
                        modifier = Modifier.fillMaxWidth().padding(vertical = 6.dp),
                        shape = RoundedCornerShape(14.dp),
                        colors = CardDefaults.cardColors(containerColor = BgMain)
                    ) {
                        Row(
                            modifier = Modifier.padding(12.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            PixelPetView(pet = pet, pixelSize = 3f)
                            Spacer(modifier = Modifier.width(12.dp))
                            Column {
                                Text(pet.displaySpeciesName, fontSize = 14.sp, fontWeight = FontWeight.Medium)
                                Text(pet.stage.displayName, fontSize = 11.sp, color = TextSecondary)
                                pet.nextStageIn?.let {
                                    Text(it, fontSize = 10.sp, color = TextTertiary)
                                }
                            }
                            Spacer(modifier = Modifier.weight(1f))
                            Icon(Icons.Default.ChevronRight, "선택", tint = TextTertiary)
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun QuantityDialog(
    maxCount: Int,
    quantity: Int,
    onQuantityChange: (Int) -> Unit,
    onConfirm: () -> Unit,
    onDismiss: () -> Unit
) {
    Dialog(onDismissRequest = onDismiss) {
        Card(shape = RoundedCornerShape(20.dp), colors = CardDefaults.cardColors(containerColor = Color.White)) {
            Column(modifier = Modifier.padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                Text("먹이 수량 선택", fontSize = 16.sp, fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(16.dp))

                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                    IconButton(
                        onClick = { if (quantity > 1) onQuantityChange(quantity - 1) },
                        enabled = quantity > 1
                    ) {
                        Icon(Icons.Default.Remove, "감소")
                    }
                    Text("$quantity", fontSize = 22.sp, fontWeight = FontWeight.Bold)
                    IconButton(
                        onClick = { if (quantity < maxCount) onQuantityChange(quantity + 1) },
                        enabled = quantity < maxCount
                    ) {
                        Icon(Icons.Default.Add, "증가")
                    }
                }

                Spacer(modifier = Modifier.height(4.dp))
                Text("최대 ${maxCount}개", fontSize = 11.sp, color = TextTertiary)

                Spacer(modifier = Modifier.height(20.dp))

                Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                    OutlinedButton(onClick = onDismiss, modifier = Modifier.weight(1f)) {
                        Text("취소")
                    }
                    Button(
                        onClick = onConfirm,
                        modifier = Modifier.weight(1f),
                        colors = ButtonDefaults.buttonColors(containerColor = Color.Black)
                    ) {
                        Text("확인")
                    }
                }
            }
        }
    }
}

@Composable
fun ItemResultDialog(item: PetItem, success: Boolean, pet: Pet?, onDismiss: () -> Unit) {
    val scope = rememberCoroutineScope()

    // Animation state
    val scale = remember { Animatable(1f) }
    val rotation = remember { Animatable(0f) }

    LaunchedEffect(item) {
        when (item) {
            PetItem.FOOD -> {
                // 바운스 애니메이션
                repeat(3) {
                    scale.animateTo(1.2f, tween(150))
                    scale.animateTo(1f, tween(150))
                }
            }
            PetItem.GROWTH_POTION -> {
                // 스케일업 애니메이션 (1.0 → 1.4 → 1.0)
                scale.animateTo(1.4f, tween(300))
                scale.animateTo(1f, tween(300))
            }
            PetItem.DUAL_SLOT_TICKET -> {
                // 회전 애니메이션
                rotation.animateTo(360f, tween(600))
            }
        }
    }

    Dialog(onDismissRequest = onDismiss) {
        Card(shape = RoundedCornerShape(24.dp), colors = CardDefaults.cardColors(containerColor = Color.White)) {
            Column(
                modifier = Modifier.padding(28.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                if (success) {
                    // 파티클 이모지
                    Text(particleEmojis(item), fontSize = 28.sp)
                    Spacer(modifier = Modifier.height(12.dp))

                    // 펫 뷰 (있을 때)
                    pet?.let {
                        Box(
                            modifier = Modifier
                                .scale(scale.value)
                                .rotate(rotation.value)
                        ) {
                            PixelPetView(pet = it, pixelSize = 6f, animated = true)
                        }
                        Spacer(modifier = Modifier.height(12.dp))
                    }

                    Text(successMessage(item), fontSize = 16.sp, fontWeight = FontWeight.Bold)
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(successDetail(item, pet), fontSize = 13.sp, color = TextSecondary)
                } else {
                    Text("😢", fontSize = 32.sp)
                    Spacer(modifier = Modifier.height(8.dp))
                    Text("사용할 수 없어요", fontSize = 16.sp, fontWeight = FontWeight.Bold)
                    Spacer(modifier = Modifier.height(4.dp))
                    Text("이미 성체이거나 아이템이 부족해요", fontSize = 13.sp, color = TextSecondary)
                }

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

private fun itemEmoji(item: PetItem) = when (item) {
    PetItem.FOOD -> "🍖"
    PetItem.GROWTH_POTION -> "✨"
    PetItem.DUAL_SLOT_TICKET -> "🎫"
}

private fun particleEmojis(item: PetItem) = when (item) {
    PetItem.FOOD -> "🍖❤️✨"
    PetItem.GROWTH_POTION -> "✨⭐💫"
    PetItem.DUAL_SLOT_TICKET -> "🎉🎊⭐"
}

private fun successMessage(item: PetItem) = when (item) {
    PetItem.FOOD -> "냠냠! 성장이 빨라졌어요"
    PetItem.GROWTH_POTION -> "쑥쑥! 한 단계 성장했어요!"
    PetItem.DUAL_SLOT_TICKET -> "두 번째 슬롯이 열렸어요!"
}

private fun successDetail(item: PetItem, pet: Pet?) = when (item) {
    PetItem.FOOD -> "${pet?.displaySpeciesName ?: "펫"}의 성장 시간이 30분 단축됐어요"
    PetItem.GROWTH_POTION -> "${pet?.displaySpeciesName ?: "펫"}이 ${pet?.stage?.displayName ?: "다음 단계"}로 성장했어요"
    PetItem.DUAL_SLOT_TICKET -> "이제 펫 2마리를 동시에 키울 수 있어요!"
}
