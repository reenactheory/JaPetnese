package com.japetnese.app.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.japetnese.app.model.*
import com.japetnese.app.ui.theme.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SettingsScreen(petManager: PetManager, onDismiss: () -> Unit) {
    var displayMode by remember { mutableStateOf(petManager.displayMode) }
    var widgetColorMode by remember { mutableStateOf(petManager.widgetColorMode) }

    ModalBottomSheet(onDismissRequest = onDismiss) {
        Column(modifier = Modifier.padding(horizontal = 20.dp).padding(bottom = 32.dp)) {
            Text("설정", fontSize = 20.sp, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.height(20.dp))

            Text("표시 방식", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = TextSecondary)
            Spacer(modifier = Modifier.height(8.dp))

            DisplayMode.entries.forEach { mode ->
                val title = when (mode) { DisplayMode.KANJI_ONLY -> "한자"; DisplayMode.FURIGANA -> "후리가나"; DisplayMode.HIRAGANA_ONLY -> "히라가나" }
                val desc = when (mode) { DisplayMode.KANJI_ONLY -> "한자로만 표시"; DisplayMode.FURIGANA -> "한자 위에 읽는 법 표시"; DisplayMode.HIRAGANA_ONLY -> "히라가나로만 표시" }
                SettingsRow(title, desc, displayMode == mode) {
                    displayMode = mode
                    petManager.displayMode = mode
                }
            }

            Spacer(modifier = Modifier.height(20.dp))
            Text("위젯 색상", fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = TextSecondary)
            Spacer(modifier = Modifier.height(8.dp))

            WidgetColorMode.entries.forEach { mode ->
                SettingsRow(mode.displayName, mode.description, widgetColorMode == mode) {
                    widgetColorMode = mode
                    petManager.widgetColorMode = mode
                }
            }
        }
    }
}

@Composable
fun SettingsRow(title: String, description: String, isSelected: Boolean, onClick: () -> Unit) {
    Card(
        onClick = onClick,
        modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White)
    ) {
        Row(
            modifier = Modifier.padding(horizontal = 16.dp, vertical = 14.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Surface(
                modifier = Modifier.size(22.dp),
                shape = CircleShape,
                color = if (isSelected) Color.Black else Color.Transparent,
                border = if (isSelected) null else ButtonDefaults.outlinedButtonBorder
            ) {
                if (isSelected) {
                    Icon(Icons.Default.Check, "selected", tint = Color.White, modifier = Modifier.size(14.dp).padding(4.dp))
                }
            }
            Spacer(modifier = Modifier.width(14.dp))
            Column {
                Text(title, fontSize = 14.sp, fontWeight = FontWeight.SemiBold, color = if (isSelected) Color.Black else TextSecondary)
                Text(description, fontSize = 10.sp, color = TextTertiary)
            }
        }
    }
}
