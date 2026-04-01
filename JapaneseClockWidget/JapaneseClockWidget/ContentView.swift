import SwiftUI

private let jpFontBold = "HiraginoSans-W7"
private let jpFont = "HiraginoSans-W6"
private let jpFontMid = "HiraginoSans-W4"
private let jpFontLight = "HiraginoSans-W3"

private let bgMain = Color(red: 0.96, green: 0.96, blue: 0.96)
private let bgCard = Color.white
private let textPrimary = Color.black
private let textSecondary = Color.black.opacity(0.4)
private let textTertiary = Color.black.opacity(0.2)

// MARK: - Furigana Row Helper

struct FuriganaRow: View {
    let pairs: [FuriganaPair]
    let size: CGFloat
    var weight: String = "HiraginoSans-W7"

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Array(pairs.enumerated()), id: \.offset) { _, pair in
                FuriganaText(kanji: pair.text, reading: pair.reading, size: size, weight: weight)
            }
        }
    }
}

// MARK: - Mode-aware text views

struct TimeDisplayView: View {
    let date: Date
    let mode: DisplayMode
    let size: CGFloat
    var alignment: HorizontalAlignment = .leading
    var equalHiraganaSize: Bool = false

    var body: some View {
        let hasMinute = Calendar.current.component(.minute, from: date) != 0
        let hiraganaHourSize = equalHiraganaSize ? size * 0.6 : size * 0.7
        let hiraganaMinSize = size * 0.6

        switch mode {
        case .kanjiOnly:
            VStack(alignment: alignment, spacing: 12) {
                Text(JapaneseTimeFormatter.formatHour(from: date))
                    .font(.custom(jpFontBold, size: size))
                    .lineSpacing(12)
                if hasMinute {
                    Text(JapaneseTimeFormatter.formatMinute(from: date))
                        .font(.custom(jpFontBold, size: size))
                        .lineSpacing(12)
                }
            }
            .foregroundStyle(textPrimary)

        case .furigana:
            VStack(alignment: alignment, spacing: 12) {
                FuriganaRow(pairs: JapaneseTimeFormatter.hourPairs(from: date), size: size)
                if hasMinute {
                    FuriganaRow(pairs: JapaneseTimeFormatter.minutePairs(from: date), size: size)
                }
            }

        case .hiraganaOnly:
            VStack(alignment: alignment, spacing: 12) {
                Text(JapaneseTimeFormatter.formatHourHiragana(from: date))
                    .font(.custom(jpFontBold, size: hiraganaHourSize))
                    .lineSpacing(12)
                if hasMinute {
                    Text(JapaneseTimeFormatter.formatMinuteHiragana(from: date))
                        .font(.custom(jpFontBold, size: hiraganaMinSize))
                        .lineSpacing(12)
                }
            }
            .foregroundStyle(textPrimary)
        }
    }
}

struct AmPmDisplayView: View {
    let date: Date
    let mode: DisplayMode
    let size: CGFloat

    var body: some View {
        switch mode {
        case .kanjiOnly:
            Text(JapaneseTimeFormatter.formatAmPm(from: date))
                .font(.custom(jpFont, size: size))
                .foregroundStyle(textPrimary)
        case .furigana:
            FuriganaRow(pairs: JapaneseTimeFormatter.amPmPairs(from: date), size: size, weight: jpFont)
        case .hiraganaOnly:
            Text(JapaneseTimeFormatter.formatAmPmHiragana(from: date))
                .font(.custom(jpFont, size: size))
                .foregroundStyle(textPrimary)
        }
    }
}

struct DateDisplayView: View {
    let date: Date
    let mode: DisplayMode
    let size: CGFloat

    var body: some View {
        switch mode {
        case .kanjiOnly:
            Text(JapaneseTimeFormatter.formatDate(from: date))
                .font(.custom(jpFontMid, size: size))
                .foregroundStyle(textSecondary)
        case .furigana:
            FuriganaRow(pairs: JapaneseTimeFormatter.datePairs(from: date), size: size, weight: jpFontMid)
        case .hiraganaOnly:
            Text(JapaneseTimeFormatter.formatDateHiragana(from: date))
                .font(.custom(jpFontMid, size: size * 0.9))
                .foregroundStyle(textSecondary)
        }
    }
}

// MARK: - ContentView

struct ContentView: View {
    @AppStorage("displayMode") private var displayModeRaw: String = DisplayMode.kanjiOnly.rawValue
    @ObservedObject var petManager = PetManager.shared
    @State private var currentDate = Date()
    @State private var showSettings = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var mode: DisplayMode {
        DisplayMode(rawValue: displayModeRaw) ?? .kanjiOnly
    }

    var body: some View {
        VStack(spacing: 0) {
            // Settings button
            HStack {
                Spacer()
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 15))
                        .foregroundStyle(textTertiary)
                        .padding(12)
                }
            }
            .padding(.horizontal, 8)

            Spacer()

            // Time section
            VStack(spacing: 6) {
                AmPmDisplayView(date: currentDate, mode: mode, size: 16)
                    .foregroundStyle(textSecondary)

                TimeDisplayView(date: currentDate, mode: mode, size: 64, alignment: .center, equalHiraganaSize: true)
            }

            Spacer().frame(height: 20)

            DateDisplayView(date: currentDate, mode: mode, size: 14)
                .foregroundStyle(textSecondary)

            Spacer().frame(height: 40)

            // Pet section
            VStack(spacing: 12) {
                if let pet = petManager.store.currentPet {
                    PetView(pet: pet, pixelSize: 8, animated: true)
                        .frame(height: 80)

                    // Pet info
                    if pet.isNameRevealed {
                        Text(pet.species.displayName)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(textSecondary)
                    }

                    if let remaining = pet.nextStageIn {
                        Text(remaining)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(textTertiary)
                    }
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "pawprint")
                            .font(.system(size: 32))
                            .foregroundStyle(textTertiary)
                        Text("뽑기에서 펫을 뽑아보세요!")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(textTertiary)
                    }
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(bgMain.ignoresSafeArea())
        .onReceive(timer) { input in
            currentDate = input
        }
        .onChange(of: displayModeRaw) { _, newValue in
            if let mode = DisplayMode(rawValue: newValue) {
                PetManager.shared.saveDisplayMode(mode)
            }
        }
        .onAppear {
            PetManager.shared.saveDisplayMode(mode)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

// MARK: - Pet Helper

@ViewBuilder
func currentPetView(pixelSize: CGFloat, animated: Bool) -> some View {
    if let pet = PetManager.shared.store.currentPet {
        PetView(pet: pet, pixelSize: pixelSize, animated: animated)
    } else {
        // Default cat when no pet
        PixelCatView(pixelSize: pixelSize, animated: animated)
    }
}

// MARK: - Widget Previews

struct WidgetPreviewSmall: View {
    let date: Date
    let mode: DisplayMode

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                currentPetView(pixelSize: 2.5, animated: true)
                Spacer()
                AmPmDisplayView(date: date, mode: mode, size: 14)
            }

            Spacer()

            TimeDisplayView(date: date, mode: mode, size: 36, alignment: .leading, equalHiraganaSize: true)
        }
        .padding(16)
        .frame(width: 155, height: 155)
        .background(bgCard, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 12, y: 4)
    }
}

struct WidgetPreviewMedium: View {
    let date: Date
    let mode: DisplayMode

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Spacer()
                TimeDisplayView(date: date, mode: mode, size: 38, alignment: .leading)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                AmPmDisplayView(date: date, mode: mode, size: 14)
                Spacer()
                currentPetView(pixelSize: 3, animated: true)
                DateDisplayView(date: date, mode: mode, size: 12)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .frame(height: 155)
        .background(bgCard, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 12, y: 4)
    }
}

struct WidgetPreviewLarge: View {
    let date: Date
    let mode: DisplayMode

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                AmPmDisplayView(date: date, mode: mode, size: 18)
            }

            Spacer()

            TimeDisplayView(date: date, mode: mode, size: 64, alignment: .leading)

            Spacer().frame(height: 16)

            HStack(alignment: .bottom) {
                DateDisplayView(date: date, mode: mode, size: 14)
                Spacer()
                currentPetView(pixelSize: 4.5, animated: true)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .frame(height: 345)
        .background(bgCard, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 12, y: 4)
    }
}

#Preview {
    ContentView()
}
