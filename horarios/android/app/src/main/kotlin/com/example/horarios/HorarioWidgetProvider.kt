package com.example.horarios

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import java.util.Calendar

class HorarioWidgetProvider : HomeWidgetProvider() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "com.example.horarios.WIDGET_PREV" || intent.action == "com.example.horarios.WIDGET_NEXT") {
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            // Para mi anterior app queria hacer un widget pero era muy molesto con lo mal que andaba
            // Mi computadora y el emulador de android para probarlo comodamente, ahora con esta app
            // Son solo datos planos que no tienen ninguna retroalimentacion del widget a la app
            // Entonces es mas facil poder hacerlo aunque ande lento en el debug
            val widgetPrefs = es.antonborri.home_widget.HomeWidgetPlugin.getData(context)
            var offset = widgetPrefs.getInt("widget_day_offset", 0)
            if (intent.action == "com.example.horarios.WIDGET_PREV") {
                offset -= 1
            } else {
                offset += 1
            }
            widgetPrefs.edit().putInt("widget_day_offset", offset).apply()
            
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val componentName = android.content.ComponentName(context, HorarioWidgetProvider::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
            
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetIds, R.id.widget_list)
            
            onUpdate(context, appWidgetManager, appWidgetIds, widgetPrefs)
        } else {
            super.onReceive(context, intent)
        }
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        val currentDayOfYear = Calendar.getInstance().get(Calendar.DAY_OF_YEAR)
        val lastDay = widgetData.getInt("widget_last_update_day", -1)
        if (lastDay != -1 && lastDay != currentDayOfYear) {
            widgetData.edit().putInt("widget_day_offset", 0).apply()
        }
        widgetData.edit().putInt("widget_last_update_day", currentDayOfYear).apply()

        val offset = widgetData.getInt("widget_day_offset", 0)
        val titleText = getTargetDayShort(offset)

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                setTextViewText(R.id.widget_title, titleText)
                
                val scheduleJsonStr = widgetData.getString("widget_schedule", "{}")
                val sharedPrefs = context.getSharedPreferences("WidgetStorage", Context.MODE_PRIVATE)
                sharedPrefs.edit()
                    .putString("widget_schedule", scheduleJsonStr)
                    .putInt("widget_day_offset", offset)
                    .apply()
                
                val serviceIntent = Intent(context, HorarioWidgetService::class.java).apply {
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
                    data = Uri.parse("horarios://widget/id/$widgetId/time/${System.currentTimeMillis()}")
                }
                setRemoteAdapter(R.id.widget_list, serviceIntent)
                setEmptyView(R.id.widget_list, R.id.widget_empty_view)

                setOnClickPendingIntent(R.id.btn_prev, getPendingIntent(context, "com.example.horarios.WIDGET_PREV"))
                setOnClickPendingIntent(R.id.btn_next, getPendingIntent(context, "com.example.horarios.WIDGET_NEXT"))
            }
            
            appWidgetManager.updateAppWidget(widgetId, views)
            appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, R.id.widget_list)
        }
    }
    
    private fun getPendingIntent(context: Context, action: String): PendingIntent {
        val intent = Intent(context, HorarioWidgetProvider::class.java).apply {
            this.action = action
        }
        return PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
    }
    
    private fun getTargetDayShort(offset: Int): String {
        val calendar = java.util.Calendar.getInstance()
        calendar.add(java.util.Calendar.DAY_OF_YEAR, offset)
        return when (calendar.get(java.util.Calendar.DAY_OF_WEEK)) {
            java.util.Calendar.MONDAY -> "Lun"
            java.util.Calendar.TUESDAY -> "Mar"
            java.util.Calendar.WEDNESDAY -> "Mié"
            java.util.Calendar.THURSDAY -> "Jue"
            java.util.Calendar.FRIDAY -> "Vie"
            java.util.Calendar.SATURDAY -> "Sáb"
            java.util.Calendar.SUNDAY -> "Dom"
            else -> ""
        }
    }
}
