import SwiftUI

private let bgMain = Color(red: 0.96, green: 0.96, blue: 0.96)
private let bgCard = Color.white

struct PetCollectionView: View {
    @ObservedObject var petManager = PetManager.shared
    @State private var now = Date()
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ZStack {
                bgMain.ignoresSafeArea()

                if petManager.store.collection.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12),
                        ], spacing: 12) {
                            ForEach(petManager.store.collection) { pet in
                                petCard(pet: pet)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("도감")
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(timer) { now = $0 }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "pawprint")
                .font(.system(size: 36))
                .foregroundStyle(.black.opacity(0.12))

            Text("아직 펫이 없어요")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.black.opacity(0.4))

            Text("뽑기에서 첫 번째 펫을 뽑아보세요!")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.black.opacity(0.25))
        }
    }

    private func petCard(pet: Pet) -> some View {
        let isEquipped = petManager.store.currentPetId == pet.id

        return Button {
            petManager.equipPet(pet.id)
        } label: {
            VStack(spacing: 0) {
                // Pet sprite
                PetView(pet: pet, pixelSize: 4.5, animated: isEquipped)
                    .frame(height: 60)
                    .padding(.top, 20)

                Spacer().frame(height: 14)

                // Name
                Text(pet.displaySpeciesName)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.black)

                Spacer().frame(height: 6)

                // Japanese name
                Text(pet.displayJapaneseName)
                    .font(.custom("HiraginoSans-W3", size: 10))
                    .foregroundStyle(.black.opacity(0.3))

                Spacer().frame(height: 10)

                // Stage indicator
                stageIndicator(pet: pet)

                Spacer()

                // Progress bar (non-adult) or spacer for adult
                if pet.stage != .adult {
                    VStack(spacing: 5) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.black.opacity(0.05))
                                Capsule().fill(Color.black.opacity(0.2))
                                    .frame(width: geo.size.width * pet.stageProgress)
                            }
                        }
                        .frame(height: 3)
                        .padding(.horizontal, 12)

                        if let remaining = pet.nextStageIn {
                            Text(remaining)
                                .font(.system(size: 9, weight: .medium))
                                .foregroundStyle(.black.opacity(0.25))
                        }
                    }
                }

                // Bottom badges — always reserve space
                HStack(spacing: 6) {
                    if pet.stage == .adult {
                        Text(pet.rarity.displayName)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(rarityColor(pet.rarity))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(rarityColor(pet.rarity).opacity(0.08), in: Capsule())
                    }

                    if isEquipped {
                        Text("장착 중")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(.black, in: Capsule())
                    }
                }
                .frame(height: 24)

                Spacer().frame(height: 14)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 250)
            .background(bgCard, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                isEquipped ?
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color.black, lineWidth: 2)
                : nil
            )
            .shadow(color: .black.opacity(isEquipped ? 0.1 : 0.04), radius: isEquipped ? 12 : 8, y: isEquipped ? 4 : 2)
        }
        .buttonStyle(.plain)
    }

    private func stageIndicator(pet: Pet) -> some View {
        let stages: [PetStage] = [.egg, .baby, .juvenile, .adult]

        return HStack(spacing: 0) {
            ForEach(Array(stages.enumerated()), id: \.offset) { i, s in
                let isDone = stageOrder(pet.stage) >= stageOrder(s)
                let isCurrent = pet.stage == s

                Circle()
                    .fill(isDone ? Color.black : Color.black.opacity(0.08))
                    .frame(width: isCurrent ? 6 : 4, height: isCurrent ? 6 : 4)

                if i < stages.count - 1 {
                    Rectangle()
                        .fill(stageOrder(pet.stage) > stageOrder(s) ? Color.black.opacity(0.2) : Color.black.opacity(0.06))
                        .frame(width: 10, height: 1)
                }
            }
        }
    }

    private func stageOrder(_ stage: PetStage) -> Int {
        switch stage {
        case .egg: return 0
        case .baby: return 1
        case .juvenile: return 2
        case .adult: return 3
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
    PetCollectionView()
}
