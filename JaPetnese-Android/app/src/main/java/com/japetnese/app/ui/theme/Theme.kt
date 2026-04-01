package com.japetnese.app.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

val BgMain = Color(0xFFF5F5F5)
val BgCard = Color.White
val TextPrimary = Color.Black
val TextSecondary = Color(0x66000000)
val TextTertiary = Color(0x33000000)

private val LightColorScheme = lightColorScheme(
    primary = Color.Black,
    onPrimary = Color.White,
    background = BgMain,
    surface = BgCard,
    onBackground = TextPrimary,
    onSurface = TextPrimary
)

@Composable
fun JaPetneseTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = LightColorScheme,
        content = content
    )
}
