import SwiftUI

private let bgMain = Color(red: 0.96, green: 0.96, blue: 0.96)
private let bgCard = Color.white

struct PetCollectionView: View {
    @ObservedObject var petManager = PetManager.shared

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
                // Pet sprite area
                ZStack {
                    Color.black.opacity(0.02)

                    PetView(pet: pet, pixelSize: 4.5, animated: isEquipped)
                }
                .frame(height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                VStack(spacing: 6) {
                    // Name + stage
                    Text(pet.displaySpeciesName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.black)

                    // Stage indicator
                    stageIndicator(pet: pet)

                    // Progress or rarity
                    if pet.stage == .adult {
                        // Rarity badge
                        Text(pet.rarity.displayName)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(rarityColor(pet.rarity))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .background(rarityColor(pet.rarity).opacity(0.08), in: Capsule())
                    } else {
                        // Growth progress
                        VStack(spacing: 3) {
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(Color.black.opacity(0.05))
                                    Capsule().fill(Color.black.opacity(0.2))
                                        .frame(width: geo.size.width * pet.stageProgress)
                                }
                            }
                            .frame(height: 3)

                            if let remaining = pet.nextStageIn {
                                Text(remaining)
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundStyle(.black.opacity(0.25))
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
                .padding(.bottom, isEquipped ? 6 : 12)

                // Equipped badge
                if isEquipped {
                    Text("장착 중")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.black, in: Capsule())
                        .padding(.bottom, 10)
                }
            }
            .frame(maxWidth: .infinity)
            .background(bgCard, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(isEquipped ? Color.black.opacity(0.2) : Color.black.opacity(0.04), lineWidth: isEquipped ? 1.5 : 0.5)
            )
            .shadow(color: .black.opacity(0.03), radius: 8, y: 2)
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
