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

struct OnboardingView: View {
    @AppStorage("displayMode") private var displayMode: String = DisplayMode.kanjiOnly.rawValue
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    @State private var currentPage = 0
    @State private var appearAnimation = false

    var body: some View {
        ZStack {
            bgMain.ignoresSafeArea()

            TabView(selection: $currentPage) {
                welcomePage.tag(0)
                displayModePage.tag(1)
                completePage.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Page indicator
            VStack {
                Spacer()
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Capsule()
                            .frame(width: currentPage == index ? 20 : 6, height: 6)
                            .foregroundStyle(currentPage == index ? textPrimary : textTertiary)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                appearAnimation = true
            }
        }
    }

    // MARK: - Page 1: Welcome

    private var welcomePage: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                Text("환영합니다")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(textSecondary)
                    .tracking(4)
                    .opacity(appearAnimation ? 1 : 0)

                // Preview card
                ZStack(alignment: .topTrailing) {
                    VStack(alignment: .leading) {
                        Spacer()
                        Text("さんじ")
                            .font(.custom(jpFontBold, size: 48))
                        Text("はん")
                            .font(.custom(jpFontBold, size: 48))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 24)
                    .padding(.bottom, 24)

                    Text("ごご")
                        .font(.custom(jpFont, size: 18))
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                }
                .foregroundStyle(textPrimary)
                .frame(width: 240, height: 240)
                .background(bgCard, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                .shadow(color: .black.opacity(0.05), radius: 20, y: 8)
                .opacity(appearAnimation ? 1 : 0)

                Text("일본어로 시간을 읽어보세요")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(textSecondary)
                    .padding(.top, 8)
            }

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.4)) {
                    currentPage = 1
                }
            } label: {
                Text("다음")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(textPrimary, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 80)
        }
    }

    // MARK: - Page 2: Display Mode Selection

    private var displayModePage: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Text("표시 방식을 선택하세요")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(textPrimary)

                Text("나중에 설정에서 변경할 수 있어요")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(textSecondary)

                VStack(spacing: 10) {
                    DisplayModeCard(
                        isSelected: displayMode == DisplayMode.kanjiOnly.rawValue,
                        title: "한자",
                        subtitle: "3時45分",
                        description: "한자로만 표시"
                    ) {
                        withAnimation { displayMode = DisplayMode.kanjiOnly.rawValue }
                    }

                    DisplayModeCard(
                        isSelected: displayMode == DisplayMode.furigana.rawValue,
                        title: "후리가나",
                        subtitle: "3時45分",
                        furiganaSubtitle: "  じ    ふん",
                        description: "한자 위에 읽는 법"
                    ) {
                        withAnimation { displayMode = DisplayMode.furigana.rawValue }
                    }

                    DisplayModeCard(
                        isSelected: displayMode == DisplayMode.hiraganaOnly.rawValue,
                        title: "히라가나",
                        subtitle: "さんじ\nよんじゅうごふん",
                        description: "히라가나만"
                    ) {
                        withAnimation { displayMode = DisplayMode.hiraganaOnly.rawValue }
                    }
                }
                .padding(.horizontal, 28)
            }

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.4)) {
                    currentPage = 2
                }
            } label: {
                Text("다음")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(textPrimary, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 80)
        }
    }

    // MARK: - Page 3: Complete

    private var completePage: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Text("준비 완료!")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(textPrimary)

                // Preview of chosen style
                let mode = DisplayMode(rawValue: displayMode) ?? .kanjiOnly
                ZStack(alignment: .topTrailing) {
                    VStack(alignment: .leading) {
                        Spacer()
                        Group {
                            switch mode {
                            case .kanjiOnly:
                                VStack(alignment: .leading, spacing: -4) {
                                    Text("9時")
                                        .font(.custom(jpFontBold, size: 48))
                                    Text("30分")
                                        .font(.custom(jpFontBold, size: 48))
                                }
                            case .furigana:
                                VStack(alignment: .leading, spacing: -4) {
                                    HStack(alignment: .bottom, spacing: 0) {
                                        FuriganaText(kanji: "9", reading: "", size: 48)
                                        FuriganaText(kanji: "時", reading: "じ", size: 48)
                                    }
                                    HStack(alignment: .bottom, spacing: 0) {
                                        FuriganaText(kanji: "30", reading: "", size: 48)
                                        FuriganaText(kanji: "分", reading: "ぷん", size: 48)
                                    }
                                }
                            case .hiraganaOnly:
                                VStack(alignment: .leading, spacing: -4) {
                                    Text("くじ")
                                        .font(.custom(jpFontBold, size: 44))
                                    Text("さんじゅっぷん")
                                        .font(.custom(jpFontBold, size: 28))
                                }
                            }
                        }
                        .foregroundStyle(textPrimary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 24)
                    .padding(.bottom, 24)

                    Group {
                        switch mode {
                        case .kanjiOnly:
                            Text("午前")
                                .font(.custom(jpFont, size: 16))
                        case .furigana:
                            FuriganaText(kanji: "午前", reading: "ごぜん", size: 16)
                        case .hiraganaOnly:
                            Text("ごぜん")
                                .font(.custom(jpFont, size: 16))
                        }
                    }
                    .foregroundStyle(textPrimary)
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                }
                .frame(width: 240, height: 240)
                .background(bgCard, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                .shadow(color: .black.opacity(0.05), radius: 20, y: 8)

                Text("홈 화면에 위젯을 추가하면\n언제든 일본어 시간을 확인할 수 있어요")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    hasCompletedOnboarding = true
                }
            } label: {
                Text("시작하기")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(textPrimary, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 80)
        }
    }
}

// MARK: - Display Mode Card

struct DisplayModeCard: View {
    let isSelected: Bool
    let title: String
    let subtitle: String
    var furiganaSubtitle: String? = nil
    let description: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Circle()
                    .strokeBorder(isSelected ? Color.clear : Color.black.opacity(0.15), lineWidth: 1.5)
                    .background(Circle().fill(isSelected ? Color.black : Color.clear))
                    .frame(width: 22, height: 22)
                    .overlay(
                        isSelected ?
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                        : nil
                    )

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(isSelected ? .black : .black.opacity(0.6))

                        Text(description)
                            .font(.system(size: 10, weight: .regular))
                            .foregroundStyle(.black.opacity(0.3))
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        if let furigana = furiganaSubtitle {
                            Text(furigana)
                                .font(.custom("HiraginoSans-W3", size: 8))
                                .foregroundStyle(.black.opacity(0.35))
                        }
                        Text(subtitle)
                            .font(.custom("HiraginoSans-W7", size: 20))
                            .foregroundStyle(isSelected ? .black : .black.opacity(0.3))
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(isSelected ? Color.black.opacity(0.2) : Color.black.opacity(0.06), lineWidth: isSelected ? 1.5 : 0.5)
            )
            .shadow(color: .black.opacity(isSelected ? 0.06 : 0.02), radius: 8, y: 2)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Furigana Text Component

struct FuriganaText: View {
    let kanji: String
    let reading: String
    let size: CGFloat
    var weight: String = "HiraginoSans-W7"

    var body: some View {
        VStack(spacing: 0) {
            if !reading.isEmpty {
                Text(reading)
                    .font(.custom("HiraginoSans-W3", size: size * 0.25))
                    .foregroundStyle(Color.black.opacity(0.4))
            } else {
                Text(" ")
                    .font(.custom("HiraginoSans-W3", size: size * 0.25))
            }

            Text(kanji)
                .font(.custom(weight, size: size))
                .foregroundStyle(Color.black)
        }
    }
}

#Preview {
    OnboardingView()
}
