import SwiftUI

private let bgMain = Color(red: 0.96, green: 0.96, blue: 0.96)
private let bgCard = Color.white

struct GachaView: View {
    @ObservedObject var petManager = PetManager.shared
    @ObservedObject var adManager = AdManager.shared
    @State private var rolledPet: Pet?
    @State private var isRolling = false
    @State private var showResult = false
    @State private var eggShake = false
    @State private var itemResult: PetItem?
    @State private var showItemResult = false
    @State private var isLoadingAd = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            ZStack {
                bgMain.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 28) {
                        Spacer().frame(height: 8)

                        // Gacha display area
                        ZStack {
                            if showItemResult, let item = itemResult {
                                itemResultView(item: item)
                                    .transition(.scale.combined(with: .opacity))
                            } else if showResult, let pet = rolledPet {
                                resultView(pet: pet)
                                    .transition(.scale.combined(with: .opacity))
                            } else if isRolling {
                                rollingView
                                    .transition(.opacity)
                            } else {
                                idleView
                            }
                        }
                        .frame(height: 260)
                        .frame(maxWidth: .infinity)
                        .background(bgCard, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                        .shadow(color: .black.opacity(0.04), radius: 20, y: 8)
                        .padding(.horizontal, 16)

                        // Gacha buttons
                        VStack(spacing: 12) {
                            // 무료 뽑기
                            if petManager.canDailyFreeGacha {
                                gachaButton(title: "무료 뽑기", subtitle: "하루 1회", buttonIcon: .gift) {
                                    performGacha { petManager.useDailyFreeGacha() }
                                }
                            } else {
                                gachaButton(title: "무료 뽑기", subtitle: "내일 다시 뽑을 수 있어요", buttonIcon: .cooldown) {}
                                    .opacity(0.5)
                                    .allowsHitTesting(false)
                            }

                            // 광고 보고 알 뽑기
                            if petManager.store.canAdGacha {
                                gachaButton(
                                    title: "광고 보고 알 뽑기",
                                    subtitle: "하루 3회 (\(3 - petManager.store.adGachaCountToday)회 남음)",
                                    buttonIcon: .egg,
                                    isLoading: isLoadingAd
                                ) {
                                    watchAdForGacha()
                                }
                            } else {
                                gachaButton(title: "광고 보고 알 뽑기", subtitle: "오늘 다 사용했어요", buttonIcon: .cooldown) {}
                                    .opacity(0.5)
                                    .allowsHitTesting(false)
                            }

                            // 광고 보고 아이템 받기
                            if petManager.canAdItemDraw {
                                gachaButton(
                                    title: "광고 보고 아이템 받기",
                                    subtitle: "12시간 5회 (\(5 - petManager.store.adItemCountToday)회 남음)",
                                    buttonIcon: .itemBag,
                                    isLoading: isLoadingAd
                                ) {
                                    watchAdForItem()
                                }
                            } else {
                                gachaButton(title: "광고 보고 아이템 받기", subtitle: "잠시 후 다시 이용해주세요", buttonIcon: .cooldown) {}
                                    .opacity(0.5)
                                    .allowsHitTesting(false)
                            }
                        }
                        .padding(.horizontal, 16)

                        // Collection count
                        HStack {
                            Image(systemName: "pawprint.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(.black.opacity(0.2))
                            Text("수집한 펫: \(petManager.store.collection.count)마리")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.black.opacity(0.3))
                        }
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("뽑기")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                petManager.checkAndResetTimers()
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    petManager.checkAndResetTimers()
                }
            }
        }
    }

    // MARK: - Views

    private var idleView: some View {
        VStack(spacing: 16) {
            let eggPet = Pet(id: UUID(), species: .cat, rarity: .normal, colorVariant: 0, accessory: nil, createdAt: Date(), accumulatedGrowth: 0, equippedSince: nil)
            PetView(pet: eggPet, pixelSize: 8)

            Text("알을 뽑아보세요!")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.black.opacity(0.5))

            Text("어떤 동물이 나올지 모릅니다")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.black.opacity(0.25))
        }
    }

    private var rollingView: some View {
        VStack(spacing: 16) {
            let eggPet = Pet(id: UUID(), species: .cat, rarity: .normal, colorVariant: 0, accessory: nil, createdAt: Date(), accumulatedGrowth: 0, equippedSince: nil)
            PetView(pet: eggPet, pixelSize: 10, animated: true)
                .rotationEffect(.degrees(eggShake ? 5 : -5))
                .animation(.easeInOut(duration: 0.1).repeatForever(autoreverses: true), value: eggShake)

            Text("두근두근...")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.black.opacity(0.4))
        }
        .onAppear { eggShake = true }
    }

    private func resultView(pet: Pet) -> some View {
        VStack(spacing: 16) {
            PetView(pet: pet, pixelSize: 10, animated: true)

            Text("알을 획득했어요!")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.black)

            Text("어떤 동물이 태어날까요?")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.black.opacity(0.35))

            if let remaining = pet.nextStageIn {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 11))
                    Text("부화까지 \(remaining)")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundStyle(.black.opacity(0.3))
            }

            Button {
                withAnimation {
                    showResult = false
                    rolledPet = nil
                }
            } label: {
                Text("확인")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 10)
                    .background(.black, in: Capsule())
            }
        }
    }

    private func itemResultView(item: PetItem) -> some View {
        VStack(spacing: 16) {
            ItemPixelView(item: item, pixelSize: 8)

            Text(item.displayName)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.black)

            Text(item.description)
                .font(.system(size: 13))
                .foregroundStyle(.black.opacity(0.45))
                .multilineTextAlignment(.center)

            Text("아이템 탭에서 사용할 수 있어요")
                .font(.system(size: 11))
                .foregroundStyle(.black.opacity(0.25))

            Button {
                withAnimation {
                    showItemResult = false
                    itemResult = nil
                }
            } label: {
                Text("확인")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 10)
                    .background(.black, in: Capsule())
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Gacha Button

    private func gachaButton(title: String, subtitle: String, buttonIcon: ButtonIcon, isLoading: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                if isLoading {
                    ProgressView()
                        .frame(width: 36, height: 28)
                } else {
                    ButtonIconView(icon: buttonIcon, pixelSize: 4)
                        .frame(width: 36, height: 28)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black)
                    Text(subtitle)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(.black.opacity(0.35))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.black.opacity(0.2))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(bgCard, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.03), radius: 8, y: 2)
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
    }

    // MARK: - Ad Actions

    private func watchAdForGacha() {
        isLoadingAd = true
        adManager.showAd { success in
            isLoadingAd = false
            if success {
                performGacha { petManager.useAdGacha() }
            }
        }
    }

    private func watchAdForItem() {
        isLoadingAd = true
        adManager.showAd { success in
            isLoadingAd = false
            if success {
                let item = petManager.useAdItemDraw()
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    itemResult = item
                    showItemResult = true
                    showResult = false
                    rolledPet = nil
                }
            }
        }
    }

    // MARK: - Helpers

    private func performGacha(_ gachaAction: @escaping () -> Pet) {
        withAnimation { isRolling = true }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let pet = gachaAction()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isRolling = false
                rolledPet = pet
                showResult = true
                showItemResult = false
                eggShake = false
            }
        }
    }

    private func rarityColor(_ rarity: PetRarity) -> Color {
        switch rarity {
        case .normal: return .gray
        case .rare: return .blue
        case .legendary: return .orange
        }
    }
}

#Preview {
    GachaView()
}
