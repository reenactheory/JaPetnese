package com.japetnese.app.widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import com.japetnese.app.R
import com.japetnese.app.formatter.JapaneseTimeFormatter
import java.util.Date

class ClockWidgetReceiver : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_clock)
            val date = Date()
            views.setTextViewText(R.id.widget_ampm, JapaneseTimeFormatter.formatAmPm(date))
            views.setTextViewText(R.id.widget_hour, JapaneseTimeFormatter.formatHour(date))
            val min = JapaneseTimeFormatter.formatMinute(date)
            views.setTextViewText(R.id.widget_minute, min)
            views.setTextViewText(R.id.widget_date, JapaneseTimeFormatter.formatDate(date))
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
