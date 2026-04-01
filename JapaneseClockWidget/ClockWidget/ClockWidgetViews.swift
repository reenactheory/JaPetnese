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
    let colorMode = PetManager.loadWidgetColorMode()
    if colorMode == .petColor {
        let accent = widgetPetAccentColor()
        if accent == .clear { return Color(UIColor.label) }
        // 펫 색상을 더 진하게 (어두운 색상으로 조정)
        return darkenColor(accent, by: 0.3)
    }
    return Color(UIColor.label)
}

func widgetSecondaryTextColor() -> Color {
    let colorMode = PetManager.loadWidgetColorMode()
    if colorMode == .petColor {
        let accent = widgetPetAccentColor()
        if accent == .clear { return Color(UIColor.secondaryLabel) }
        return darkenColor(accent, by: 0.15)
    }
    return Color(UIColor.secondaryLabel)
}

// 색상을 더 진하게 만드는 헬퍼
func darkenColor(_ color: Color, by amount: Double) -> Color {
    // 채도를 올리고 밝기를 낮춰서 가독성 확보
    let uiColor = UIColor(color)
    var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    let newBrightness = max(b - CGFloat(amount), 0.15)
    let newSaturation = min(s + 0.2, 1.0)
    return Color(UIColor(hue: h, saturation: newSaturation, brightness: newBrightness, alpha: a))
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
        if mode == .hiraganaOnly {
            // 히라가나: AM/PM 우상단, 시간 3줄로
            let minute = Calendar.current.component(.minute, from: date)
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    widgetPetView(pixelSize: 2)
                    Spacer()
                    Text(JapaneseTimeFormatter.formatAmPmHiragana(from: date))
                        .font(.system(size: 12, weight: .semibold))
                }

                Spacer()

                Text(JapaneseTimeFormatter.formatHourHiragana(from: date))
                    .font(.system(size: 22, weight: .bold))
                if minute != 0 {
                    Text(JapaneseTimeFormatter.formatMinuteHiragana(from: date))
                        .font(.system(size: 22, weight: .bold))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .foregroundStyle(widgetTextColor())
            .padding(12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            // 한자/후리가나: 기존 레이아웃
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    widgetPetView(pixelSize: 2.5)
                    Spacer()
                    WidgetAmPmView(date: date, mode: mode, size: 14)
                }

                Spacer()

                WidgetTimeView(date: date, mode: mode, size: 36)
            }
            .foregroundStyle(widgetTextColor())
            .padding(14)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Medium Widget

struct MediumClockView: View {
    let date: Date
    let mode: DisplayMode

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Spacer()
                WidgetTimeView(date: date, mode: mode, size: 38)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                WidgetAmPmView(date: date, mode: mode, size: 14)
                Spacer()
                widgetPetView(pixelSize: 3)
                WidgetDateView(date: date, mode: mode, size: 13)
                    .foregroundStyle(widgetSecondaryTextColor())
            }
        }
        .foregroundStyle(widgetTextColor())
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Large Widget

struct LargeClockView: View {
    let date: Date
    let mode: DisplayMode

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                WidgetAmPmView(date: date, mode: mode, size: 18)
            }

            Spacer()

            WidgetTimeView(date: date, mode: mode, size: 64)

            Spacer().frame(height: 16)

            HStack(alignment: .bottom) {
                Group {
                    switch mode {
                    case .hiraganaOnly:
                        Text(JapaneseTimeFormatter.formatDateHiragana(from: date))
                    default:
                        Text(JapaneseTimeFormatter.formatDate(from: date))
                    }
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(widgetSecondaryTextColor())

                Spacer()
                widgetPetView(pixelSize: 4.5)
            }
        }
        .foregroundStyle(widgetTextColor())
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
