import SwiftUI
import WidgetKit

private let jpFontBold = "HiraginoSans-W7"
private let jpFont = "HiraginoSans-W6"
private let jpFontMid = "HiraginoSans-W4"

struct ClockWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: ClockEntry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallClockView(date: entry.date)
        case .systemMedium:
            MediumClockView(date: entry.date)
        case .systemLarge:
            LargeClockView(date: entry.date)
        default:
            SmallClockView(date: entry.date)
        }
    }
}

// MARK: - Widget Pet Helper

@ViewBuilder
func widgetPetView(pixelSize: CGFloat) -> some View {
    if let pet = PetManager.loadCurrentPet() {
        StaticPetView(pet: pet, pixelSize: pixelSize)
    } else {
        EmptyView()
    }
}

// MARK: - Small Widget

struct SmallClockView: View {
    let date: Date

    var body: some View {
        let minute = Calendar.current.component(.minute, from: date)
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                widgetPetView(pixelSize: 2.5)
                Spacer()
                Text(JapaneseTimeFormatter.formatAmPm(from: date))
                    .font(.custom(jpFont, size: 14))
            }

            Spacer()

            VStack(alignment: .leading, spacing: -2) {
                Text(JapaneseTimeFormatter.formatHour(from: date))
                    .font(.custom(jpFontBold, size: 36))
                if minute != 0 {
                    Text(JapaneseTimeFormatter.formatMinute(from: date))
                        .font(.custom(jpFontBold, size: 36))
                }
            }
        }
        .foregroundStyle(.primary)
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Medium Widget

struct MediumClockView: View {
    let date: Date

    var body: some View {
        let minute = Calendar.current.component(.minute, from: date)
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: -2) {
                Spacer()
                Text(JapaneseTimeFormatter.formatHour(from: date))
                    .font(.custom(jpFontBold, size: 38))
                if minute != 0 {
                    Text(JapaneseTimeFormatter.formatMinute(from: date))
                        .font(.custom(jpFontBold, size: 38))
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Text(JapaneseTimeFormatter.formatAmPm(from: date))
                    .font(.custom(jpFont, size: 14))
                Spacer()
                widgetPetView(pixelSize: 3)
                Text(JapaneseTimeFormatter.formatDateShort(from: date))
                    .font(.custom(jpFontMid, size: 13))
                    .foregroundStyle(.secondary)
            }
        }
        .foregroundStyle(.primary)
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Large Widget

struct LargeClockView: View {
    let date: Date

    var body: some View {
        let minute = Calendar.current.component(.minute, from: date)
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Text(JapaneseTimeFormatter.formatAmPm(from: date))
                    .font(.custom(jpFont, size: 18))
            }

            Spacer()

            VStack(alignment: .leading, spacing: 4) {
                Text(JapaneseTimeFormatter.formatHour(from: date))
                    .font(.custom(jpFontBold, size: 64))
                if minute != 0 {
                    Text(JapaneseTimeFormatter.formatMinute(from: date))
                        .font(.custom(jpFontBold, size: 64))
                }
            }

            Spacer().frame(height: 16)

            HStack(alignment: .bottom) {
                Text(JapaneseTimeFormatter.formatDate(from: date))
                    .font(.custom(jpFontMid, size: 14))
                    .foregroundStyle(.secondary)
                Spacer()
                widgetPetView(pixelSize: 4.5)
            }
        }
        .foregroundStyle(.primary)
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
