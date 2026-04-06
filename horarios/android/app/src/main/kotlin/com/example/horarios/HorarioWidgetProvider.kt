package com.example.horarios

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Color
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONObject
import java.util.Calendar

class HorarioWidgetProvider : HomeWidgetProvider() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "com.example.horarios.WIDGET_PREV" || intent.action == "com.example.horarios.WIDGET_NEXT") {
            val widgetPrefs = context.getSharedPreferences("WidgetStorage", Context.MODE_PRIVATE)
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

            // Para mi anterior app queria hacer un widget pero era muy molesto con lo mal que andaba
            // Mi computadora y el emulador de android para probarlo comodamente, ahora con esta app
            // Son solo datos planos que no tienen ninguna retroalimentacion del widget a la app
            // Entonces es mas facil poder hacerlo aunque ande lento en el debug
            val homeWidgetData = es.antonborri.home_widget.HomeWidgetPlugin.getData(context)
            val scheduleJson = homeWidgetData.getString("widget_schedule", "{}")
            widgetPrefs.edit().putString("widget_schedule", scheduleJson).apply()

            onUpdate(context, appWidgetManager, appWidgetIds, homeWidgetData)
        } else {
            super.onReceive(context, intent)
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        val scheduleJsonStr = widgetData.getString("widget_schedule", null)

        val widgetStorage = context.getSharedPreferences("WidgetStorage", Context.MODE_PRIVATE)
        if (scheduleJsonStr != null) {
            widgetStorage.edit().putString("widget_schedule", scheduleJsonStr).apply()
        }

        val currentDayOfYear = Calendar.getInstance().get(Calendar.DAY_OF_YEAR)
        val lastDay = widgetStorage.getInt("widget_last_update_day", -1)
        if (lastDay != currentDayOfYear) {
            widgetStorage.edit()
                .putInt("widget_day_offset", 0)
                .putInt("widget_last_update_day", currentDayOfYear)
                .apply()
        }

        val offset = widgetStorage.getInt("widget_day_offset", 0)
        val schedule = widgetStorage.getString("widget_schedule", "{}") ?: "{}"
        val titleText = getDayShort(offset)
        val targetDay = getDayFull(offset)
        val classes = parseScheduleForDay(schedule, targetDay)

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout)
            views.setTextViewText(R.id.widget_title, titleText)
            views.setOnClickPendingIntent(R.id.btn_prev, getPendingIntent(context, "com.example.horarios.WIDGET_PREV", widgetId))
            views.setOnClickPendingIntent(R.id.btn_next, getPendingIntent(context, "com.example.horarios.WIDGET_NEXT", widgetId))

            views.removeAllViews(R.id.widget_class_list)

            if (classes.isEmpty()) {
                val emptyView = RemoteViews(context.packageName, R.layout.widget_class_item)
                emptyView.setTextViewText(R.id.item_time, "")
                emptyView.setTextViewText(R.id.item_subject, "Sin Clases")
                emptyView.setTextViewText(R.id.item_room, "")
                emptyView.setInt(R.id.item_color_bar, "setBackgroundColor", Color.parseColor("#555555"))
                views.addView(R.id.widget_class_list, emptyView)
            } else {
                for (item in classes) {
                    val row = RemoteViews(context.packageName, R.layout.widget_class_item)
                    row.setTextViewText(R.id.item_time, item["time"] as String)
                    row.setTextViewText(R.id.item_subject, item["subject"] as String)
                    val room = item["room"] as String
                    row.setTextViewText(R.id.item_room, if (room.isEmpty()) "" else "Aula $room")
                    val color = (item["color"] as Long).toInt()
                    row.setInt(R.id.item_color_bar, "setBackgroundColor", color)
                    views.addView(R.id.widget_class_list, row)
                }
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun getPendingIntent(context: Context, action: String, widgetId: Int): PendingIntent {
        val intent = Intent(context, HorarioWidgetProvider::class.java).apply {
            this.action = action
        }
        return PendingIntent.getBroadcast(
            context,
            widgetId,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun getDayShort(offset: Int): String {
        val cal = Calendar.getInstance()
        cal.add(Calendar.DAY_OF_YEAR, offset)
        return when (cal.get(Calendar.DAY_OF_WEEK)) {
            Calendar.MONDAY -> "Lun"
            Calendar.TUESDAY -> "Mar"
            Calendar.WEDNESDAY -> "Mié"
            Calendar.THURSDAY -> "Jue"
            Calendar.FRIDAY -> "Vie"
            Calendar.SATURDAY -> "Sáb"
            Calendar.SUNDAY -> "Dom"
            else -> ""
        }
    }

    private fun getDayFull(offset: Int): String {
        val cal = Calendar.getInstance()
        cal.add(Calendar.DAY_OF_YEAR, offset)
        return when (cal.get(Calendar.DAY_OF_WEEK)) {
            Calendar.MONDAY -> "Lunes"
            Calendar.TUESDAY -> "Martes"
            Calendar.WEDNESDAY -> "Miércoles"
            Calendar.THURSDAY -> "Jueves"
            Calendar.FRIDAY -> "Viernes"
            Calendar.SATURDAY -> "Sábado"
            Calendar.SUNDAY -> "Domingo"
            else -> ""
        }
    }

    private fun parseScheduleForDay(jsonStr: String, day: String): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        try {
            val json = JSONObject(jsonStr)
            if (json.has(day)) {
                val array = json.getJSONArray(day)
                for (i in 0 until array.length()) {
                    val obj = array.getJSONObject(i)
                    list.add(
                        mapOf(
                            "time" to obj.optString("time", ""),
                            "subject" to obj.optString("subject", ""),
                            "room" to obj.optString("room", ""),
                            "color" to obj.optLong("color", 0xFF1565C0)
                        )
                    )
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return list
    }
}
