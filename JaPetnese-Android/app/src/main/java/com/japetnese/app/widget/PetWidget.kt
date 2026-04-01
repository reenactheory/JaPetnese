package com.japetnese.app.widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import com.japetnese.app.R

class PetWidgetReceiver : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_pet)
            views.setTextViewText(R.id.widget_pet_name, "JaPetnese")
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
