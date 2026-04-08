import Foundation

enum DisplayMode: String {
    case kanjiOnly = "kanjiOnly"
    case furigana = "furigana"
    case hiraganaOnly = "hiraganaOnly"
}

struct FuriganaPair {
    let text: String
    let reading: String
}

struct JapaneseTimeFormatter {
    private static let dayOfWeekNames = ["日", "月", "火", "水", "木", "金", "土"]
    private static let dayOfWeekReadings = ["にち", "げつ", "か", "すい", "もく", "きん", "ど"]
    private static let amPmNames = ["午前", "午後"]
    private static let amPmReadings = ["ごぜん", "ごご"]

    // Full hiragana readings for hours (1-12)
    private static let hourFullReadings: [Int: String] = [
        1: "いちじ", 2: "にじ", 3: "さんじ", 4: "よじ",
        5: "ごじ", 6: "ろくじ", 7: "しちじ", 8: "はちじ",
        9: "くじ", 10: "じゅうじ", 11: "じゅういちじ", 12: "じゅうにじ"
    ]

    // Full hiragana readings for minutes (1-59)
    private static func minuteFullReading(_ m: Int) -> String {
        let base: [Int: String] = [
            1: "いっ", 2: "に", 3: "さん", 4: "よん",
            5: "ご", 6: "ろっ", 7: "なな", 8: "はっ",
            9: "きゅう", 10: "じゅっ",
            11: "じゅういっ", 12: "じゅうに", 13: "じゅうさん", 14: "じゅうよん",
            15: "じゅうご", 16: "じゅうろっ", 17: "じゅうなな", 18: "じゅうはっ",
            19: "じゅうきゅう", 20: "にじゅっ",
            21: "にじゅういっ", 22: "にじゅうに", 23: "にじゅうさん", 24: "にじゅうよん",
            25: "にじゅうご", 26: "にじゅうろっ", 27: "にじゅうなな", 28: "にじゅうはっ",
            29: "にじゅうきゅう", 30: "さんじゅっ",
            31: "さんじゅういっ", 32: "さんじゅうに", 33: "さんじゅうさん", 34: "さんじゅうよん",
            35: "さんじゅうご", 36: "さんじゅうろっ", 37: "さんじゅうなな", 38: "さんじゅうはっ",
            39: "さんじゅうきゅう", 40: "よんじゅっ",
            41: "よんじゅういっ", 42: "よんじゅうに", 43: "よんじゅうさん", 44: "よんじゅうよん",
            45: "よんじゅうご", 46: "よんじゅうろっ", 47: "よんじゅうなな", 48: "よんじゅうはっ",
            49: "よんじゅうきゅう", 50: "ごじゅっ",
            51: "ごじゅういっ", 52: "ごじゅうに", 53: "ごじゅうさん", 54: "ごじゅうよん",
            55: "ごじゅうご", 56: "ごじゅうろっ", 57: "ごじゅうなな", 58: "ごじゅうはっ",
            59: "ごじゅうきゅう"
        ]
        let suffix: String = {
            switch m {
            case 1, 3, 4, 6, 8, 10,
                 11, 13, 14, 16, 18, 20,
                 21, 23, 24, 26, 28, 30,
                 31, 33, 34, 36, 38, 40,
                 41, 43, 44, 46, 48, 50,
                 51, 53, 54, 56, 58:
                return "ぷん"
            default:
                return "ふん"
            }
        }()
        return (base[m] ?? "\(m)") + suffix
    }

    // Full hiragana readings for months
    private static let monthReadings: [Int: String] = [
        1: "いちがつ", 2: "にがつ", 3: "さんがつ", 4: "しがつ",
        5: "ごがつ", 6: "ろくがつ", 7: "しちがつ", 8: "はちがつ",
        9: "くがつ", 10: "じゅうがつ", 11: "じゅういちがつ", 12: "じゅうにがつ"
    ]

    // Full hiragana readings for days
    private static func dayReading(_ d: Int) -> String {
        let special: [Int: String] = [
            1: "ついたち", 2: "ふつか", 3: "みっか", 4: "よっか",
            5: "いつか", 6: "むいか", 7: "なのか", 8: "ようか",
            9: "ここのか", 10: "とおか", 14: "じゅうよっか",
            20: "はつか", 24: "にじゅうよっか"
        ]
        if let s = special[d] { return s }
        // Regular: じゅういちにち, etc.
        let tens = d / 10
        let ones = d % 10
        var result = ""
        if tens == 1 { result += "じゅう" }
        else if tens == 2 { result += "にじゅう" }
        else if tens == 3 { result += "さんじゅう" }
        let onesReadings = ["", "いち", "に", "さん", "よん", "ご", "ろく", "しち", "はち", "きゅう"]
        result += onesReadings[ones]
        result += "にち"
        return result
    }

    // MARK: - Plain text formatters

    static func formatTime(from date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let amPm = hour < 12 ? amPmNames[0] : amPmNames[1]
        let displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        if minute == 0 {
            return "\(amPm)\(displayHour)時"
        }
        return "\(amPm)\(displayHour)時\(minute)分"
    }

    static func formatTimeShort(from date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        if minute == 0 {
            return "\(displayHour)時"
        }
        return "\(displayHour)時\(minute)分"
    }

    static func formatHour(from date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        return "\(displayHour)時"
    }

    static func formatMinute(from date: Date) -> String {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: date)
        if minute == 0 { return "" }
        return "\(minute)分"
    }

    static func formatAmPm(from date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        return hour < 12 ? amPmNames[0] : amPmNames[1]
    }

    static func formatDate(from date: Date) -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let weekday = calendar.component(.weekday, from: date) - 1
        let dayName = dayOfWeekNames[weekday]
        return "\(month)月\(day)日 \(dayName)曜日"
    }

    static func formatDateShort(from date: Date) -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return "\(month)月\(day)日"
    }

    static func formatYear(from date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return "\(year)年"
    }

    // MARK: - Hiragana-only formatters (fully hiragana, no numerals)

    static func formatAmPmHiragana(from date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        return hour < 12 ? amPmReadings[0] : amPmReadings[1]
    }

    static func formatHourHiragana(from date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        return hourFullReadings[displayHour] ?? "\(displayHour)じ"
    }

    static func formatMinuteHiragana(from date: Date) -> String {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: date)
        if minute == 0 { return "" }
        return minuteFullReading(minute)
    }

    static func formatTimeShortHiragana(from date: Date) -> String {
        let hourStr = formatHourHiragana(from: date)
        let minStr = formatMinuteHiragana(from: date)
        return hourStr + minStr
    }

    static func formatDateHiragana(from date: Date) -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let weekday = calendar.component(.weekday, from: date) - 1
        let monthStr = monthReadings[month] ?? "\(month)がつ"
        let dayStr = dayReading(day)
        let weekdayStr = dayOfWeekReadings[weekday] + "ようび"
        return "\(monthStr) \(dayStr) \(weekdayStr)"
    }

    static func formatDateShortHiragana(from date: Date) -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let monthStr = monthReadings[month] ?? "\(month)がつ"
        let dayStr = dayReading(day)
        return "\(monthStr) \(dayStr)"
    }

    static func formatYearHiragana(from date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return numberToHiragana(year) + "ねん"
    }

    // MARK: - Furigana pair formatters

    static func hourPairs(from date: Date) -> [FuriganaPair] {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        return [
            FuriganaPair(text: "\(displayHour)", reading: ""),
            FuriganaPair(text: "時", reading: "じ")
        ]
    }

    static func minutePairs(from date: Date) -> [FuriganaPair] {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: date)
        if minute == 0 { return [] }
        return [
            FuriganaPair(text: "\(minute)", reading: ""),
            FuriganaPair(text: "分", reading: minuteSuffix(minute))
        ]
    }

    static func amPmPairs(from date: Date) -> [FuriganaPair] {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let index = hour < 12 ? 0 : 1
        return [
            FuriganaPair(text: amPmNames[index], reading: amPmReadings[index])
        ]
    }

    static func timeShortPairs(from date: Date) -> [FuriganaPair] {
        return hourPairs(from: date) + minutePairs(from: date)
    }

    static func datePairs(from date: Date) -> [FuriganaPair] {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let weekday = calendar.component(.weekday, from: date) - 1
        return [
            FuriganaPair(text: "\(month)", reading: ""),
            FuriganaPair(text: "月", reading: "がつ"),
            FuriganaPair(text: "\(day)", reading: ""),
            FuriganaPair(text: "日", reading: "にち"),
            FuriganaPair(text: " ", reading: ""),
            FuriganaPair(text: dayOfWeekNames[weekday], reading: dayOfWeekReadings[weekday]),
            FuriganaPair(text: "曜日", reading: "ようび")
        ]
    }

    static func dateShortPairs(from date: Date) -> [FuriganaPair] {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return [
            FuriganaPair(text: "\(month)", reading: ""),
            FuriganaPair(text: "月", reading: "がつ"),
            FuriganaPair(text: "\(day)", reading: ""),
            FuriganaPair(text: "日", reading: "にち")
        ]
    }

    static func yearPairs(from date: Date) -> [FuriganaPair] {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return [
            FuriganaPair(text: "\(year)", reading: ""),
            FuriganaPair(text: "年", reading: "ねん")
        ]
    }

    static func weekdayPairs(from date: Date) -> [FuriganaPair] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date) - 1
        return [
            FuriganaPair(text: dayOfWeekNames[weekday], reading: dayOfWeekReadings[weekday]),
            FuriganaPair(text: "曜日", reading: "ようび")
        ]
    }

    // MARK: - Helpers

    private static func minuteSuffix(_ minute: Int) -> String {
        // ぷん: 1, 3, 4, 6, 8, 10 — and their multiples (e.g. 13, 14, 23, 24 ...)
        switch minute {
        case 1, 3, 4, 6, 8, 10,
             11, 13, 14, 16, 18, 20,
             21, 23, 24, 26, 28, 30,
             31, 33, 34, 36, 38, 40,
             41, 43, 44, 46, 48, 50,
             51, 53, 54, 56, 58: return "ぷん"
        default: return "ふん"
        }
    }

    private static func numberToHiragana(_ n: Int) -> String {
        let digits = ["れい", "いち", "に", "さん", "よん", "ご", "ろく", "なな", "はち", "きゅう"]
        if n < 10 { return digits[n] }
        // For years like 2026
        let str = String(n)
        var result = ""
        for ch in str {
            if let d = Int(String(ch)) {
                result += digits[d]
            }
        }
        return result
    }
}
