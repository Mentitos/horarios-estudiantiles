package com.example.horarios

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class HorarioWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                val content = widgetData.getString("widget_content", "Abre la app para cargar tus clases de hoy.")
                setTextViewText(R.id.widget_content, content)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
