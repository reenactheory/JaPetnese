import WidgetKit
import SwiftUI

struct ClockEntry: TimelineEntry {
    let date: Date
}

struct ClockTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> ClockEntry {
        ClockEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (ClockEntry) -> Void) {
        completion(ClockEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ClockEntry>) -> Void) {
        let now = Date()
        let calendar = Calendar.current

        var entries: [ClockEntry] = []
        for minuteOffset in 0..<60 {
            if let entryDate = calendar.date(byAdding: .minute, value: minuteOffset, to: now) {
                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: entryDate)
                if let roundedDate = calendar.date(from: components) {
                    entries.append(ClockEntry(date: roundedDate))
                }
            }
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// MARK: - Home Screen Widget

struct ClockWidget: Widget {
    let kind: String = "ClockWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockTimelineProvider()) { entry in
            let colorMode = PetManager.loadWidgetColorMode()
            ClockWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    if colorMode == .petColor {
                        ZStack {
                            Color(.systemBackground)
                            LinearGradient(
                                colors: [
                                    widgetPetAccentColor().opacity(0.15),
                                    widgetPetAccentColor().opacity(0.03)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        }
                    } else {
                        Color(.systemBackground)
                    }
                }
        }
        .configurationDisplayName("日本語時計")
        .description("홈 화면에 일본어 시계를 표시합니다")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Lock Screen Widget

struct LockScreenClockWidget: Widget {
    let kind: String = "LockScreenClockWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockTimelineProvider()) { entry in
            LockScreenWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("日本語時計")
        .description("잠금화면에 일본어 시계를 표시합니다")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

// MARK: - Lock Screen Widget Views

struct LockScreenWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: ClockEntry

    var body: some View {
        let mode = PetManager.loadDisplayMode()
        switch family {
        case .accessoryCircular:
            CircularClockView(date: entry.date, mode: mode)
        case .accessoryRectangular:
            RectangularClockView(date: entry.date, mode: mode)
        case .accessoryInline:
            InlineClockView(date: entry.date, mode: mode)
        default:
            CircularClockView(date: entry.date, mode: mode)
        }
    }
}

// MARK: - Circular (원형)

struct CircularClockView: View {
    let date: Date
    let mode: DisplayMode

    var body: some View {
        let minute = Calendar.current.component(.minute, from: date)
        VStack(spacing: 0) {
            switch mode {
            case .hiraganaOnly:
                Text(JapaneseTimeFormatter.formatHourHiragana(from: date))
                    .font(.system(size: 12, weight: .bold))
                if minute != 0 {
                    Text(JapaneseTimeFormatter.formatMinuteHiragana(from: date))
                        .font(.system(size: 9, weight: .bold))
                        .minimumScaleFactor(0.5)
                }
            default:
                Text(JapaneseTimeFormatter.formatHour(from: date))
                    .font(.system(size: 16, weight: .bold))
                if minute != 0 {
                    Text(JapaneseTimeFormatter.formatMinute(from: date))
                        .font(.system(size: 16, weight: .bold))
                }
            }
        }
        .widgetAccentable()
    }
}

// MARK: - Rectangular (직사각형)

struct RectangularClockView: View {
    let date: Date
    let mode: DisplayMode

    var body: some View {
        let minute = Calendar.current.component(.minute, from: date)
        HStack {
            VStack(alignment: .leading, spacing: 1) {
                switch mode {
                case .hiraganaOnly:
                    Text(JapaneseTimeFormatter.formatAmPmHiragana(from: date))
                        .font(.system(size: 10, weight: .medium))
                        .opacity(0.6)
                    Text(JapaneseTimeFormatter.formatHourHiragana(from: date))
                        .font(.system(size: 16, weight: .bold))
                    if minute != 0 {
                        Text(JapaneseTimeFormatter.formatMinuteHiragana(from: date))
                            .font(.system(size: 14, weight: .bold))
                            .minimumScaleFactor(0.6)
                    }
                default:
                    Text(JapaneseTimeFormatter.formatAmPm(from: date))
                        .font(.system(size: 10, weight: .medium))
                        .opacity(0.6)
                    HStack(spacing: 0) {
                        Text(JapaneseTimeFormatter.formatHour(from: date))
                        if minute != 0 {
                            Text(JapaneseTimeFormatter.formatMinute(from: date))
                        }
                    }
                    .font(.system(size: 18, weight: .bold))

                    Text(JapaneseTimeFormatter.formatDateShort(from: date))
                        .font(.system(size: 10, weight: .medium))
                        .opacity(0.6)
                }
            }
            Spacer()
        }
        .widgetAccentable()
    }
}

// MARK: - Inline (한 줄)

struct InlineClockView: View {
    let date: Date
    let mode: DisplayMode

    var body: some View {
        switch mode {
        case .hiraganaOnly:
            Text(JapaneseTimeFormatter.formatDateHiragana(from: date))
        default:
            Text(JapaneseTimeFormatter.formatDate(from: date))
        }
    }
}

// MARK: - Bundle

@main
struct ClockWidgetBundle: WidgetBundle {
    var body: some Widget {
        ClockWidget()
        LockScreenClockWidget()
    }
}
