package com.japetnese.app.widget

import android.content.Context
import androidx.glance.*
import androidx.glance.appwidget.*
import androidx.glance.layout.*
import androidx.glance.text.*
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

class PetOnlyWidget : GlanceAppWidget() {
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            Column(
                modifier = GlanceModifier.fillMaxSize().padding(14.dp),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Glance doesn't support Canvas, so show text placeholder
                Text(
                    text = "🐾",
                    style = TextStyle(fontSize = 48.sp)
                )
                Spacer(modifier = GlanceModifier.height(8.dp))
                Text(
                    text = "JaPetnese",
                    style = TextStyle(fontSize = 12.sp)
                )
            }
        }
    }
}

class PetWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget = PetOnlyWidget()
}
