package com.example.horarios

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONObject

class HorarioWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return HorarioWidgetFactory(this.applicationContext, intent)
    }
}

class HorarioWidgetFactory(private val context: Context, private val intent: Intent) : RemoteViewsService.RemoteViewsFactory {
    private var classItems: List<Map<String, Any>> = emptyList()

    override fun onCreate() {}

    override fun onDataSetChanged() {
        val sharedPrefs = context.getSharedPreferences("WidgetStorage", Context.MODE_PRIVATE)
        val scheduleJsonStr = sharedPrefs.getString("widget_schedule", "{}") ?: "{}"
        val dayOffset = sharedPrefs.getInt("widget_day_offset", 0)
        
        val targetDay = getTargetDay(dayOffset)
        classItems = parseScheduleForDay(scheduleJsonStr, targetDay)
    }

    override fun onDestroy() {}

    override fun getCount(): Int = classItems.size

    override fun getViewAt(position: Int): RemoteViews {
        val item = classItems[position]
        val rv = RemoteViews(context.packageName, R.layout.widget_class_item)
        rv.setTextViewText(R.id.item_time, item["time"] as String)
        rv.setTextViewText(R.id.item_subject, item["subject"] as String)
        
        val room = item["room"] as String
        if (room.isEmpty()) {
            rv.setTextViewText(R.id.item_room, "")
        } else {
            rv.setTextViewText(R.id.item_room, "Aula $room")
        }
        
        val color = item["color"] as Long
        rv.setInt(R.id.item_color, "setBackgroundColor", color.toInt())

        return rv
    }

    override fun getLoadingView(): RemoteViews? = null
    override fun getViewTypeCount(): Int = 1
    override fun getItemId(position: Int): Long = position.toLong()
    override fun hasStableIds(): Boolean = true

    private fun getTargetDay(offset: Int): String {
        val calendar = java.util.Calendar.getInstance()
        calendar.add(java.util.Calendar.DAY_OF_YEAR, offset)
        return when (calendar.get(java.util.Calendar.DAY_OF_WEEK)) {
            java.util.Calendar.MONDAY -> "Lunes"
            java.util.Calendar.TUESDAY -> "Martes"
            java.util.Calendar.WEDNESDAY -> "Miércoles"
            java.util.Calendar.THURSDAY -> "Jueves"
            java.util.Calendar.FRIDAY -> "Viernes"
            java.util.Calendar.SATURDAY -> "Sábado"
            java.util.Calendar.SUNDAY -> "Domingo"
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
                    list.add(mapOf(
                        "time" to obj.optString("time", ""),
                        "subject" to obj.optString("subject", ""),
                        "room" to obj.optString("room", ""),
                        "color" to obj.optLong("color", 0xFF1565C0)
                    ))
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return list
    }
}
