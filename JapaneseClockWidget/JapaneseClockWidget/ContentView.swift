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
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
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

                // Main clock card
                mainClockCard
                    .padding(.horizontal, 16)

                // Section label
                Text("위젯 미리보기")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(textTertiary)
                    .tracking(2)
                    .padding(.top, 8)

                // Widget previews
                VStack(spacing: 16) {
                    WidgetPreviewSmall(date: currentDate, mode: mode)
                    WidgetPreviewMedium(date: currentDate, mode: mode)
                    WidgetPreviewLarge(date: currentDate, mode: mode)
                }
                .padding(.horizontal, 16)

                // Footer
                Text("홈 화면을 길게 눌러 위젯을 추가하세요")
                    .font(.system(size: 11, weight: .light))
                    .foregroundStyle(textTertiary)
                    .padding(.vertical, 24)
            }
        }
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
            // Sync display mode to App Group on launch
            PetManager.shared.saveDisplayMode(mode)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }

    private var mainClockCard: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                TimeDisplayView(date: currentDate, mode: mode, size: 72, alignment: .leading)

                Spacer().frame(height: 16)

                DateDisplayView(date: currentDate, mode: mode, size: 14)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 28)
            .padding(.bottom, 28)

            AmPmDisplayView(date: currentDate, mode: mode, size: 22)
                .padding(.top, 28)
                .padding(.trailing, 28)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .background(bgCard, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 20, y: 8)
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
