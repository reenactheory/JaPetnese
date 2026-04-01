package com.japetnese.app.ui.screens

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.japetnese.app.model.*
import com.japetnese.app.ui.components.PixelPetView
import com.japetnese.app.ui.theme.*
import kotlinx.coroutines.launch

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun OnboardingScreen(petManager: PetManager, onComplete: () -> Unit) {
    val pagerState = rememberPagerState(pageCount = { 3 })
    val scope = rememberCoroutineScope()
    var selectedMode by remember { mutableStateOf(DisplayMode.KANJI_ONLY) }

    Box(modifier = Modifier.fillMaxSize()) {
        HorizontalPager(state = pagerState, modifier = Modifier.fillMaxSize()) { page ->
            when (page) {
                0 -> WelcomePage()
                1 -> DisplayModePage(selectedMode) { selectedMode = it }
                2 -> CompletePage()
            }
        }

        // Page indicator + button
        Column(
            modifier = Modifier.align(Alignment.BottomCenter).padding(bottom = 50.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            // Dots
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                repeat(3) { i ->
                    Surface(
                        modifier = Modifier.size(if (pagerState.currentPage == i) 20.dp else 6.dp, 6.dp),
                        shape = RoundedCornerShape(3.dp),
                        color = if (pagerState.currentPage == i) Color.Black else Color.Black.copy(0.15f)
                    ) {}
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            Button(
                onClick = {
                    if (pagerState.currentPage < 2) {
                        scope.launch { pagerState.animateScrollToPage(pagerState.currentPage + 1) }
                    } else {
                        petManager.displayMode = selectedMode
                        onComplete()
                    }
                },
                modifier = Modifier.fillMaxWidth().padding(horizontal = 40.dp).height(52.dp),
                shape = RoundedCornerShape(16.dp),
                colors = ButtonDefaults.buttonColors(containerColor = Color.Black)
            ) {
                Text(if (pagerState.currentPage < 2) "다음" else "시작하기", fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
            }
        }
    }
}

@Composable
fun WelcomePage() {
    Column(
        modifier = Modifier.fillMaxSize().padding(32.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text("환영합니다", fontSize = 14.sp, color = TextSecondary)
        Spacer(modifier = Modifier.height(24.dp))

        Card(
            shape = RoundedCornerShape(28.dp),
            colors = CardDefaults.cardColors(containerColor = Color.White),
            modifier = Modifier.size(260.dp, 220.dp)
        ) {
            Box(modifier = Modifier.fillMaxSize().padding(24.dp)) {
                Column(modifier = Modifier.align(Alignment.BottomStart)) {
                    Text("さんじ", fontSize = 44.sp, fontWeight = FontWeight.Bold)
                    Text("はん", fontSize = 44.sp, fontWeight = FontWeight.Bold)
                }
                Text("ごご", fontSize = 16.sp, fontWeight = FontWeight.SemiBold, modifier = Modifier.align(Alignment.TopEnd))
            }
        }

        Spacer(modifier = Modifier.height(16.dp))
        Text("일본어로 시간을 읽고", fontSize = 13.sp, color = TextSecondary)
        Text("귀여운 도트 펫도 키워보세요!", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = Color.Black.copy(0.5f))
    }
}

@Composable
fun DisplayModePage(selectedMode: DisplayMode, onSelect: (DisplayMode) -> Unit) {
    Column(
        modifier = Modifier.fillMaxSize().padding(32.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text("표시 방식을 선택하세요", fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
        Spacer(modifier = Modifier.height(8.dp))
        Text("나중에 설정에서 변경할 수 있어요", fontSize = 12.sp, color = TextSecondary)
        Spacer(modifier = Modifier.height(24.dp))

        listOf(
            Triple(DisplayMode.KANJI_ONLY, "한자", "3時45分"),
            Triple(DisplayMode.FURIGANA, "후리가나", "3時45分 (じ/ふん)"),
            Triple(DisplayMode.HIRAGANA_ONLY, "히라가나", "さんじ よんじゅうごふん")
        ).forEach { (mode, title, example) ->
            Card(
                onClick = { onSelect(mode) },
                modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = Color.White),
                border = if (selectedMode == mode) CardDefaults.outlinedCardBorder().copy(width = 1.5.dp) else null
            ) {
                Row(modifier = Modifier.padding(16.dp), verticalAlignment = Alignment.CenterVertically) {
                    Surface(
                        modifier = Modifier.size(22.dp), shape = CircleShape,
                        color = if (selectedMode == mode) Color.Black else Color.Transparent,
                        border = if (selectedMode == mode) null else ButtonDefaults.outlinedButtonBorder
                    ) {}
                    Spacer(modifier = Modifier.width(14.dp))
                    Column {
                        Text(title, fontSize = 14.sp, fontWeight = FontWeight.SemiBold)
                        Text(example, fontSize = 18.sp, fontWeight = FontWeight.Bold, color = if (selectedMode == mode) Color.Black else TextTertiary)
                    }
                }
            }
        }
    }
}

@Composable
fun CompletePage() {
    Column(
        modifier = Modifier.fillMaxSize().padding(32.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text("준비 완료!", fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
        Spacer(modifier = Modifier.height(24.dp))
        Text("홈 화면에 위젯을 추가하면", fontSize = 12.sp, color = TextSecondary)
        Text("언제든 일본어 시간을 확인할 수 있어요", fontSize = 12.sp, color = TextSecondary)
    }
}
