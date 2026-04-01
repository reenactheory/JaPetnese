import SwiftUI
import WidgetKit

struct ClockWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: ClockEntry

    var body: some View {
        let mode = PetManager.loadDisplayMode()
        switch family {
        case .systemSmall:
            SmallClockView(date: entry.date, mode: mode)
        case .systemMedium:
            MediumClockView(date: entry.date, mode: mode)
        case .systemLarge:
            LargeClockView(date: entry.date, mode: mode)
        default:
            SmallClockView(date: entry.date, mode: mode)
        }
    }
}

// MARK: - Widget Helpers

@ViewBuilder
func widgetPetView(pixelSize: CGFloat) -> some View {
    if let pet = PetManager.loadCurrentPet() {
        StaticPetView(pet: pet, pixelSize: pixelSize)
    } else {
        EmptyView()
    }
}

func widgetPetAccentColor() -> Color {
    if let pet = PetManager.loadCurrentPet() {
        let palette = paletteFor(species: pet.species, rarity: pet.rarity, variant: pet.colorVariant)
        return palette.primary
    }
    return .clear
}

func widgetTextColor() -> Color {
    // 메인 시간 텍스트는 항상 가독성 우선
    return Color(UIColor.label)
}

func widgetSecondaryTextColor() -> Color {
    // AM/PM, 날짜 등 보조 텍스트에 펫 색상 포인트
    let colorMode = PetManager.loadWidgetColorMode()
    if colorMode == .petColor {
        let accent = widgetPetAccentColor()
        if accent == .clear { return Color(UIColor.secondaryLabel) }
        return accent
    }
    return Color(UIColor.secondaryLabel)
}

// MARK: - Widget Time Text Helpers

struct WidgetTimeView: View {
    let date: Date
    let mode: DisplayMode
    let size: CGFloat

    var body: some View {
        let minute = Calendar.current.component(.minute, from: date)

        switch mode {
        case .kanjiOnly:
            VStack(alignment: .leading, spacing: -2) {
                Text(JapaneseTimeFormatter.formatHour(from: date))
                    .font(.system(size: size, weight: .bold))
                if minute != 0 {
                    Text(JapaneseTimeFormatter.formatMinute(from: date))
                        .font(.system(size: size, weight: .bold))
                }
            }
        case .furigana:
            // Widget에서는 후리가나 대신 한자 + 작은 읽기 표시
            VStack(alignment: .leading, spacing: -2) {
                Text(JapaneseTimeFormatter.formatHour(from: date))
                    .font(.system(size: size, weight: .bold))
                if minute != 0 {
                    Text(JapaneseTimeFormatter.formatMinute(from: date))
                        .font(.system(size: size, weight: .bold))
                }
            }
        case .hiraganaOnly:
            VStack(alignment: .leading, spacing: 1) {
                Text(JapaneseTimeFormatter.formatHourHiragana(from: date))
                    .font(.system(size: size * 0.55, weight: .bold))
                if minute != 0 {
                    Text(JapaneseTimeFormatter.formatMinuteHiragana(from: date))
                        .font(.system(size: size * 0.55, weight: .bold))
                        .lineSpacing(2)
                }
            }
        }
    }
}

struct WidgetAmPmView: View {
    let date: Date
    let mode: DisplayMode
    let size: CGFloat

    var body: some View {
        switch mode {
        case .hiraganaOnly:
            Text(JapaneseTimeFormatter.formatAmPmHiragana(from: date))
                .font(.system(size: size, weight: .semibold))
        default:
            Text(JapaneseTimeFormatter.formatAmPm(from: date))
                .font(.system(size: size, weight: .semibold))
        }
    }
}

struct WidgetDateView: View {
    let date: Date
    let mode: DisplayMode
    let size: CGFloat

    var body: some View {
        switch mode {
        case .hiraganaOnly:
            Text(JapaneseTimeFormatter.formatDateShortHiragana(from: date))
                .font(.system(size: size, weight: .medium))
        default:
            Text(JapaneseTimeFormatter.formatDateShort(from: date))
                .font(.system(size: size, weight: .medium))
        }
    }
}

// MARK: - Small Widget

struct SmallClockView: View {
    let date: Date
    let mode: DisplayMode

    var body: some View {
        // Small 위젯: 도트 동물 중심
        VStack(spacing: 8) {
            Spacer()

            // 펫 크게 표시
            if let pet = PetManager.loadCurrentPet() {
                StaticPetView(pet: pet, pixelSize: 5)
            } else {
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(widgetSecondaryTextColor())
            }

            Spacer()

            // 시간 작게 하단
            switch mode {
            case .hiraganaOnly:
                Text(JapaneseTimeFormatter.formatAmPmHiragana(from: date) + " " + JapaneseTimeFormatter.formatTimeShortHiragana(from: date))
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(widgetSecondaryTextColor())
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
            default:
                Text(JapaneseTimeFormatter.formatTime(from: date))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(widgetSecondaryTextColor())
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Medium Widget

struct MediumClockView: View {
    let date: Date
    let mode: DisplayMode

    var body: some View {
        HStack(spacing: 16) {
            // 왼쪽: 시간
            VStack(alignment: .leading) {
                WidgetAmPmView(date: date, mode: mode, size: 12)
                    .foregroundStyle(widgetSecondaryTextColor())
                Spacer()
                WidgetTimeView(date: date, mode: mode, size: 34)
                    .foregroundStyle(widgetTextColor())
                Spacer().frame(height: 4)
                WidgetDateView(date: date, mode: mode, size: 11)
                    .foregroundStyle(widgetSecondaryTextColor())
            }

            Spacer()

            // 오른쪽: 도트 동물 크게
            VStack {
                Spacer()
                widgetPetView(pixelSize: 5)
                Spacer()
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Large Widget

struct LargeClockView: View {
    let date: Date
    let mode: DisplayMode

    var body: some View {
        VStack(spacing: 0) {
            // 상단: AM/PM + 날짜
            HStack {
                WidgetAmPmView(date: date, mode: mode, size: 14)
                    .foregroundStyle(widgetSecondaryTextColor())
                Spacer()
                WidgetDateView(date: date, mode: mode, size: 13)
                    .foregroundStyle(widgetSecondaryTextColor())
            }

            Spacer()

            // 중앙: 도트 동물 크게
            widgetPetView(pixelSize: 7)

            Spacer()

            // 하단: 시간
            WidgetTimeView(date: date, mode: mode, size: 56)
                .foregroundStyle(widgetTextColor())
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Previews

#Preview("Small", as: .systemSmall) {
    ClockWidget()
} timeline: {
    ClockEntry(date: Date())
}

#Preview("Medium", as: .systemMedium) {
    ClockWidget()
} timeline: {
    ClockEntry(date: Date())
}

#Preview("Large", as: .systemLarge) {
    ClockWidget()
} timeline: {
    ClockEntry(date: Date())
}
