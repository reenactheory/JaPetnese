import SwiftUI
import WidgetKit

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

func widgetPetAccentColor() -> Color {
    if let pet = PetManager.loadCurrentPet() {
        let palette = paletteFor(species: pet.species, rarity: pet.rarity, variant: pet.colorVariant)
        return palette.primary
    }
    return .clear
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
                    .font(.system(size: 14, weight: .semibold))
            }

            Spacer()

            VStack(alignment: .leading, spacing: -2) {
                Text(JapaneseTimeFormatter.formatHour(from: date))
                    .font(.system(size: 36, weight: .bold))
                if minute != 0 {
                    Text(JapaneseTimeFormatter.formatMinute(from: date))
                        .font(.system(size: 36, weight: .bold))
                }
            }
        }
        .foregroundStyle(Color(UIColor.label))
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
                    .font(.system(size: 38, weight: .bold))
                if minute != 0 {
                    Text(JapaneseTimeFormatter.formatMinute(from: date))
                        .font(.system(size: 38, weight: .bold))
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Text(JapaneseTimeFormatter.formatAmPm(from: date))
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                widgetPetView(pixelSize: 3)
                Text(JapaneseTimeFormatter.formatDateShort(from: date))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color(UIColor.secondaryLabel))
            }
        }
        .foregroundStyle(Color(UIColor.label))
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
                    .font(.system(size: 18, weight: .semibold))
            }

            Spacer()

            VStack(alignment: .leading, spacing: 4) {
                Text(JapaneseTimeFormatter.formatHour(from: date))
                    .font(.system(size: 64, weight: .bold))
                if minute != 0 {
                    Text(JapaneseTimeFormatter.formatMinute(from: date))
                        .font(.system(size: 64, weight: .bold))
                }
            }

            Spacer().frame(height: 16)

            HStack(alignment: .bottom) {
                Text(JapaneseTimeFormatter.formatDate(from: date))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(UIColor.secondaryLabel))
                Spacer()
                widgetPetView(pixelSize: 4.5)
            }
        }
        .foregroundStyle(Color(UIColor.label))
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
