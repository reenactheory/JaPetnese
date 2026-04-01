package com.japetnese.app.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.japetnese.app.formatter.JapaneseTimeFormatter
import com.japetnese.app.model.*
import com.japetnese.app.ui.components.PixelPetView
import com.japetnese.app.ui.theme.*
import kotlinx.coroutines.delay
import java.util.Date

@Composable
fun ClockScreen(petManager: PetManager) {
    var currentDate by remember { mutableStateOf(Date()) }
    var showSettings by remember { mutableStateOf(false) }
    val mode = petManager.displayMode

    LaunchedEffect(Unit) {
        while (true) {
            delay(1000)
            currentDate = Date()
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        // Settings button
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.End) {
            IconButton(onClick = { showSettings = true }) {
                Icon(Icons.Default.Settings, "설정", tint = TextTertiary)
            }
        }

        Spacer(modifier = Modifier.weight(1f))

        // AM/PM
        Text(
            text = if (mode == DisplayMode.HIRAGANA_ONLY) JapaneseTimeFormatter.formatAmPmHiragana(currentDate)
                   else JapaneseTimeFormatter.formatAmPm(currentDate),
            fontSize = 16.sp,
            color = TextSecondary
        )

        Spacer(modifier = Modifier.height(6.dp))

        // Time
        when (mode) {
            DisplayMode.HIRAGANA_ONLY -> {
                Text(JapaneseTimeFormatter.formatHourHiragana(currentDate), fontSize = 48.sp, fontWeight = FontWeight.Bold)
                val min = JapaneseTimeFormatter.formatMinuteHiragana(currentDate)
                if (min.isNotEmpty()) Text(min, fontSize = 48.sp, fontWeight = FontWeight.Bold)
            }
            else -> {
                Text(JapaneseTimeFormatter.formatHour(currentDate), fontSize = 64.sp, fontWeight = FontWeight.Bold)
                val min = JapaneseTimeFormatter.formatMinute(currentDate)
                if (min.isNotEmpty()) Text(min, fontSize = 64.sp, fontWeight = FontWeight.Bold)
            }
        }

        Spacer(modifier = Modifier.height(20.dp))

        // Date
        Text(
            text = if (mode == DisplayMode.HIRAGANA_ONLY) JapaneseTimeFormatter.formatDateHiragana(currentDate)
                   else JapaneseTimeFormatter.formatDate(currentDate),
            fontSize = 14.sp,
            color = TextSecondary
        )

        Spacer(modifier = Modifier.height(40.dp))

        // Pet
        val pet = petManager.currentPet
        if (pet != null) {
            PixelPetView(pet = pet, pixelSize = 8f, animated = true)
            Spacer(modifier = Modifier.height(12.dp))
            if (pet.isNameRevealed) {
                Text(pet.species.displayName, fontSize = 13.sp, fontWeight = FontWeight.SemiBold, color = TextSecondary)
            }
            pet.nextStageIn?.let {
                Text(it, fontSize = 11.sp, color = TextTertiary)
            }
        } else {
            Icon(Icons.Default.Pets, "펫", tint = TextTertiary, modifier = Modifier.size(32.dp))
            Spacer(modifier = Modifier.height(8.dp))
            Text("뽑기에서 펫을 뽑아보세요!", fontSize = 12.sp, color = TextTertiary)
        }

        Spacer(modifier = Modifier.weight(1f))
    }

    if (showSettings) {
        SettingsScreen(petManager) { showSettings = false }
    }
}
