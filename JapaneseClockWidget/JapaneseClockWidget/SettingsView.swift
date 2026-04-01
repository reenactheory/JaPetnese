import SwiftUI

struct SettingsView: View {
    @AppStorage("displayMode") private var displayMode: String = DisplayMode.kanjiOnly.rawValue
    @State private var widgetColorMode: WidgetColorMode = PetManager.loadWidgetColorMode()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.96, green: 0.96, blue: 0.96).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("표시 방식")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.4))
                                .padding(.horizontal, 4)

                            VStack(spacing: 8) {
                                SettingsModeRow(
                                    isSelected: displayMode == DisplayMode.kanjiOnly.rawValue,
                                    title: "한자",
                                    example: "3時45分",
                                    description: "한자로만 표시"
                                ) {
                                    withAnimation { displayMode = DisplayMode.kanjiOnly.rawValue }
                                }

                                SettingsModeRow(
                                    isSelected: displayMode == DisplayMode.furigana.rawValue,
                                    title: "후리가나",
                                    example: "3時45分 (じ/ふん)",
                                    description: "한자 위에 읽는 법 표시"
                                ) {
                                    withAnimation { displayMode = DisplayMode.furigana.rawValue }
                                }

                                SettingsModeRow(
                                    isSelected: displayMode == DisplayMode.hiraganaOnly.rawValue,
                                    title: "히라가나",
                                    example: "さんじ よんじゅうごふん",
                                    description: "히라가나로만 표시"
                                ) {
                                    withAnimation { displayMode = DisplayMode.hiraganaOnly.rawValue }
                                }
                            }
                        }

                        // Widget color section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("위젯 색상")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.4))
                                .padding(.horizontal, 4)
                                .padding(.top, 8)

                            VStack(spacing: 8) {
                                ForEach(WidgetColorMode.allCases, id: \.rawValue) { mode in
                                    SettingsModeRow(
                                        isSelected: widgetColorMode == mode,
                                        title: mode.displayName,
                                        example: "",
                                        description: mode.description
                                    ) {
                                        withAnimation {
                                            widgetColorMode = mode
                                            PetManager.shared.saveWidgetColorMode(mode)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("완료") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                }
            }
        }
    }
}

struct SettingsModeRow: View {
    let isSelected: Bool
    let title: String
    let example: String
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

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(isSelected ? .black : .black.opacity(0.5))

                        Text(description)
                            .font(.system(size: 10, weight: .regular))
                            .foregroundStyle(.black.opacity(0.25))
                    }

                    Text(example)
                        .font(.custom("HiraginoSans-W4", size: 16))
                        .foregroundStyle(isSelected ? .black.opacity(0.7) : .black.opacity(0.25))
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(isSelected ? Color.black.opacity(0.15) : Color.black.opacity(0.04), lineWidth: isSelected ? 1.5 : 0.5)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsView()
}
