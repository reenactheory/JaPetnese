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

// MARK: - Clock Only Widget (시계만, 펫 없음)

struct ClockOnlyWidget: Widget {
    let kind: String = "ClockOnlyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockTimelineProvider()) { entry in
            ClockOnlyWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    Color(.systemBackground)
                }
        }
        .configurationDisplayName("시계만")
        .description("펫 없이 일본어 시계만 표시합니다")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct ClockOnlyWidgetView: View {
    var entry: ClockEntry

    var body: some View {
        let mode = PetManager.loadDisplayMode()
        let minute = Calendar.current.component(.minute, from: entry.date)

        VStack(alignment: .leading, spacing: 0) {
            switch mode {
            case .hiraganaOnly:
                Text(JapaneseTimeFormatter.formatAmPmHiragana(from: entry.date))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(UIColor.secondaryLabel))
                    .lineLimit(1)

                Spacer()

                Text(JapaneseTimeFormatter.formatHourHiragana(from: entry.date))
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(UIColor.label))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                if minute != 0 {
                    Text(JapaneseTimeFormatter.formatMinuteHiragana(from: entry.date))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color(UIColor.label))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer().frame(height: 8)

                Text(JapaneseTimeFormatter.formatDateHiragana(from: entry.date))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Color(UIColor.secondaryLabel))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)

            default:
                Text(JapaneseTimeFormatter.formatAmPm(from: entry.date))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(UIColor.secondaryLabel))

                Spacer()

                Text(JapaneseTimeFormatter.formatHour(from: entry.date))
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(Color(UIColor.label))
                if minute != 0 {
                    Text(JapaneseTimeFormatter.formatMinute(from: entry.date))
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(Color(UIColor.label))
                }

                Spacer().frame(height: 8)

                Text(JapaneseTimeFormatter.formatDate(from: entry.date))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(UIColor.secondaryLabel))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(16)
    }
}

// MARK: - Pet Only Widget (펫만, 시계 없음)

struct PetOnlyWidget: Widget {
    let kind: String = "PetOnlyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockTimelineProvider()) { entry in
            PetOnlyWidgetView()
                .containerBackground(for: .widget) {
                    let colorMode = PetManager.loadWidgetColorMode()
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
        .configurationDisplayName("펫만")
        .description("장착한 도트 펫만 크게 표시합니다")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct PetOnlyWidgetView: View {
    var body: some View {
        VStack {
            Spacer()

            if let pet = PetManager.loadCurrentPet() {
                StaticPetView(pet: pet, pixelSize: 8)

                if pet.isNameRevealed {
                    Text(pet.species.japaneseName)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(widgetSecondaryTextColor())
                        .padding(.top, 8)
                }
            } else {
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(Color(UIColor.tertiaryLabel))
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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

// MARK: - Lock Screen Views

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

// MARK: - Inline (날짜 옆 한 줄) → 일본어 날짜

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

// MARK: - Circular (원형) → 동물 아이콘만

struct CircularClockView: View {
    let date: Date
    let mode: DisplayMode

    var body: some View {
        if let pet = PetManager.loadCurrentPet() {
            // 펫의 성장 진행도를 게이지로 표시
            if pet.stage != .adult {
                Gauge(value: pet.stageProgress) {
                    StaticPetView(pet: pet, pixelSize: 2)
                }
                .gaugeStyle(.accessoryCircularCapacity)
                .widgetAccentable()
            } else {
                ZStack {
                    AccessoryWidgetBackground()
                    StaticPetView(pet: pet, pixelSize: 2.5)
                }
            }
        } else {
            ZStack {
                AccessoryWidgetBackground()
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 20))
            }
            .widgetAccentable()
        }
    }
}

// MARK: - Rectangular (직사각형) → 시간만

struct RectangularClockView: View {
    let date: Date
    let mode: DisplayMode

    var body: some View {
        let minute = Calendar.current.component(.minute, from: date)
        VStack(alignment: .leading, spacing: 2) {
            switch mode {
            case .hiraganaOnly:
                Text(JapaneseTimeFormatter.formatAmPmHiragana(from: date))
                    .font(.system(size: 10, weight: .medium))
                    .opacity(0.6)
                Text(JapaneseTimeFormatter.formatHourHiragana(from: date))
                    .font(.system(size: 16, weight: .bold))
                if minute != 0 {
                    Text(JapaneseTimeFormatter.formatMinuteHiragana(from: date))
                        .font(.system(size: 16, weight: .bold))
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
                .font(.system(size: 22, weight: .bold))

                Text(JapaneseTimeFormatter.formatDateShort(from: date))
                    .font(.system(size: 10, weight: .medium))
                    .opacity(0.6)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .widgetAccentable()
    }
}

// MARK: - Bundle

@main
struct ClockWidgetBundle: WidgetBundle {
    var body: some Widget {
        ClockWidget()
        ClockOnlyWidget()
        PetOnlyWidget()
        LockScreenClockWidget()
    }
}
