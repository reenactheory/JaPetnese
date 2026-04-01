package com.japetnese.app.formatter

import java.util.Calendar
import java.util.Date

object JapaneseTimeFormatter {
    private val dayOfWeekNames = arrayOf("日", "月", "火", "水", "木", "金", "土")
    private val amPmNames = arrayOf("午前", "午後")
    private val amPmReadings = arrayOf("ごぜん", "ごご")

    private val hourReadings = mapOf(
        1 to "いちじ", 2 to "にじ", 3 to "さんじ", 4 to "よじ",
        5 to "ごじ", 6 to "ろくじ", 7 to "しちじ", 8 to "はちじ",
        9 to "くじ", 10 to "じゅうじ", 11 to "じゅういちじ", 12 to "じゅうにじ"
    )

    private val monthReadings = mapOf(
        1 to "いちがつ", 2 to "にがつ", 3 to "さんがつ", 4 to "しがつ",
        5 to "ごがつ", 6 to "ろくがつ", 7 to "しちがつ", 8 to "はちがつ",
        9 to "くがつ", 10 to "じゅうがつ", 11 to "じゅういちがつ", 12 to "じゅうにがつ"
    )

    private fun cal(date: Date = Date()): Calendar = Calendar.getInstance().apply { time = date }

    fun formatHour(date: Date = Date()): String {
        val h = cal(date).get(Calendar.HOUR_OF_DAY)
        val dh = if (h == 0) 12 else if (h > 12) h - 12 else h
        return "${dh}時"
    }

    fun formatMinute(date: Date = Date()): String {
        val m = cal(date).get(Calendar.MINUTE)
        return if (m == 0) "" else "${m}分"
    }

    fun formatAmPm(date: Date = Date()): String {
        val h = cal(date).get(Calendar.HOUR_OF_DAY)
        return if (h < 12) amPmNames[0] else amPmNames[1]
    }

    fun formatTime(date: Date = Date()): String {
        val amPm = formatAmPm(date)
        val hour = formatHour(date)
        val min = formatMinute(date)
        return "$amPm$hour$min"
    }

    fun formatDate(date: Date = Date()): String {
        val c = cal(date)
        val month = c.get(Calendar.MONTH) + 1
        val day = c.get(Calendar.DAY_OF_MONTH)
        val weekday = c.get(Calendar.DAY_OF_WEEK) - 1 // Sunday=0
        return "${month}月${day}日 ${dayOfWeekNames[weekday]}曜日"
    }

    fun formatDateShort(date: Date = Date()): String {
        val c = cal(date)
        return "${c.get(Calendar.MONTH) + 1}月${c.get(Calendar.DAY_OF_MONTH)}日"
    }

    // Hiragana
    fun formatAmPmHiragana(date: Date = Date()): String {
        return if (cal(date).get(Calendar.HOUR_OF_DAY) < 12) amPmReadings[0] else amPmReadings[1]
    }

    fun formatHourHiragana(date: Date = Date()): String {
        val h = cal(date).get(Calendar.HOUR_OF_DAY)
        val dh = if (h == 0) 12 else if (h > 12) h - 12 else h
        return hourReadings[dh] ?: "${dh}じ"
    }

    fun formatMinuteHiragana(date: Date = Date()): String {
        val m = cal(date).get(Calendar.MINUTE)
        if (m == 0) return ""
        return minuteFullReading(m)
    }

    fun formatTimeShortHiragana(date: Date = Date()): String {
        return formatHourHiragana(date) + formatMinuteHiragana(date)
    }

    fun formatDateHiragana(date: Date = Date()): String {
        val c = cal(date)
        val month = c.get(Calendar.MONTH) + 1
        val day = c.get(Calendar.DAY_OF_MONTH)
        val weekday = c.get(Calendar.DAY_OF_WEEK) - 1
        val dayReadings = arrayOf("にち", "げつ", "か", "すい", "もく", "きん", "ど")
        return "${monthReadings[month]} ${dayReading(day)} ${dayReadings[weekday]}ようび"
    }

    private fun minuteFullReading(m: Int): String {
        val base = mapOf(
            1 to "いっ", 2 to "に", 3 to "さん", 4 to "よん", 5 to "ご",
            6 to "ろっ", 7 to "なな", 8 to "はっ", 9 to "きゅう", 10 to "じゅっ",
            11 to "じゅういっ", 12 to "じゅうに", 13 to "じゅうさん", 14 to "じゅうよん",
            15 to "じゅうご", 16 to "じゅうろっ", 17 to "じゅうなな", 18 to "じゅうはっ",
            19 to "じゅうきゅう", 20 to "にじゅっ",
            21 to "にじゅういっ", 22 to "にじゅうに", 23 to "にじゅうさん", 24 to "にじゅうよん",
            25 to "にじゅうご", 26 to "にじゅうろっ", 27 to "にじゅうなな", 28 to "にじゅうはっ",
            29 to "にじゅうきゅう", 30 to "さんじゅっ",
            31 to "さんじゅういっ", 32 to "さんじゅうに", 33 to "さんじゅうさん", 34 to "さんじゅうよん",
            35 to "さんじゅうご", 36 to "さんじゅうろっ", 37 to "さんじゅうなな", 38 to "さんじゅうはっ",
            39 to "さんじゅうきゅう", 40 to "よんじゅっ",
            41 to "よんじゅういっ", 42 to "よんじゅうに", 43 to "よんじゅうさん", 44 to "よんじゅうよん",
            45 to "よんじゅうご", 46 to "よんじゅうろっ", 47 to "よんじゅうなな", 48 to "よんじゅうはっ",
            49 to "よんじゅうきゅう", 50 to "ごじゅっ",
            51 to "ごじゅういっ", 52 to "ごじゅうに", 53 to "ごじゅうさん", 54 to "ごじゅうよん",
            55 to "ごじゅうご", 56 to "ごじゅうろっ", 57 to "ごじゅうなな", 58 to "ごじゅうはっ",
            59 to "ごじゅうきゅう"
        )
        val pun = setOf(1,6,8,10,16,18,20,26,28,30,36,38,40,46,48,50,56,58)
        val suffix = if (m in pun) "ぷん" else "ふん"
        return (base[m] ?: "$m") + suffix
    }

    private fun dayReading(d: Int): String {
        val special = mapOf(
            1 to "ついたち", 2 to "ふつか", 3 to "みっか", 4 to "よっか",
            5 to "いつか", 6 to "むいか", 7 to "なのか", 8 to "ようか",
            9 to "ここのか", 10 to "とおか", 14 to "じゅうよっか",
            20 to "はつか", 24 to "にじゅうよっか"
        )
        special[d]?.let { return it }
        val tens = d / 10
        val ones = d % 10
        val onesR = arrayOf("", "いち", "に", "さん", "よん", "ご", "ろく", "しち", "はち", "きゅう")
        var result = when (tens) { 1 -> "じゅう"; 2 -> "にじゅう"; 3 -> "さんじゅう"; else -> "" }
        result += onesR[ones] + "にち"
        return result
    }
}
