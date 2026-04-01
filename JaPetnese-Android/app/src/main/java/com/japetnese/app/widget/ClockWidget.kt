package com.japetnese.app.widget

import android.content.Context
import androidx.glance.*
import androidx.glance.appwidget.*
import androidx.glance.layout.*
import androidx.glance.text.*
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.japetnese.app.formatter.JapaneseTimeFormatter
import java.util.Date

class ClockOnlyWidget : GlanceAppWidget() {
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            val date = Date()
            Column(
                modifier = GlanceModifier.fillMaxSize().padding(16.dp),
            ) {
                Text(
                    text = JapaneseTimeFormatter.formatAmPm(date),
                    style = TextStyle(fontSize = 14.sp)
                )
                Spacer(modifier = GlanceModifier.defaultWeight())
                Text(
                    text = JapaneseTimeFormatter.formatHour(date),
                    style = TextStyle(fontSize = 48.sp, fontWeight = FontWeight.Bold)
                )
                val min = JapaneseTimeFormatter.formatMinute(date)
                if (min.isNotEmpty()) {
                    Text(text = min, style = TextStyle(fontSize = 48.sp, fontWeight = FontWeight.Bold))
                }
                Spacer(modifier = GlanceModifier.height(8.dp))
                Text(
                    text = JapaneseTimeFormatter.formatDate(date),
                    style = TextStyle(fontSize = 12.sp)
                )
            }
        }
    }
}

class ClockWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget = ClockOnlyWidget()
}
