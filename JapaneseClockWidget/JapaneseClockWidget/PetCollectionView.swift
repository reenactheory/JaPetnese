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
        VStack(spacing: 12) {
            Image(systemName: "pawprint")
                .font(.system(size: 32))
                .foregroundStyle(.black.opacity(0.15))

            Text("아직 펫이 없어요")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.black.opacity(0.3))

            Text("뽑기에서 첫 번째 펫을 뽑아보세요!")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.black.opacity(0.2))
        }
    }

    private func petCard(pet: Pet) -> some View {
        let isSelected = petManager.store.currentPetId == pet.id

        return Button {
            petManager.equipPet(pet.id)
        } label: {
            VStack(spacing: 10) {
                // Pet sprite
                PetView(pet: pet, pixelSize: 4, animated: isSelected)
                    .frame(height: 50)

                // Name
                Text(pet.displaySpeciesName)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.black)

                // Japanese name
                Text(pet.displayJapaneseName)
                    .font(.custom("HiraginoSans-W3", size: 10))
                    .foregroundStyle(.black.opacity(0.35))

                // Stage badge
                stageBadge(pet: pet)

                // Growth progress bar
                if pet.stage != .adult {
                    VStack(spacing: 4) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.black.opacity(0.06))
                                    .frame(height: 4)
                                Capsule()
                                    .fill(Color.black.opacity(0.3))
                                    .frame(width: geo.size.width * pet.stageProgress, height: 4)
                            }
                        }
                        .frame(height: 4)

                        if let remaining = pet.nextStageIn {
                            Text(remaining)
                                .font(.system(size: 8, weight: .medium))
                                .foregroundStyle(.black.opacity(0.25))
                        }
                    }
                    .padding(.horizontal, 4)
                }

                // Rarity (only show when adult)
                if pet.stage == .adult {
                    Text(pet.rarity.displayName)
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(rarityColor(pet.rarity))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(rarityColor(pet.rarity).opacity(0.1), in: Capsule())
                }

                // Equipped badge
                if pet.isEquipped {
                    Text("장착 중")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.black, in: Capsule())
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
            .background(bgCard, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(isSelected ? Color.black.opacity(0.25) : Color.black.opacity(0.04), lineWidth: isSelected ? 1.5 : 0.5)
            )
            .shadow(color: .black.opacity(0.03), radius: 8, y: 2)
        }
        .buttonStyle(.plain)
    }

    private func stageBadge(pet: Pet) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 2) {
                ForEach(Array([PetStage.egg, .baby, .juvenile, .adult].enumerated()), id: \.offset) { _, s in
                    let isComplete = stageOrder(pet.stage) >= stageOrder(s)
                    let isCurrent = pet.stage == s

                    Circle()
                        .fill(isComplete ? Color.black : Color.black.opacity(0.1))
                        .frame(width: isCurrent ? 7 : 5, height: isCurrent ? 7 : 5)
                        .overlay(
                            isCurrent ?
                            Circle().strokeBorder(Color.black.opacity(0.3), lineWidth: 1)
                                .frame(width: 11, height: 11)
                            : nil
                        )

                    if s != .adult {
                        Rectangle()
                            .fill(stageOrder(pet.stage) > stageOrder(s) ? Color.black.opacity(0.3) : Color.black.opacity(0.08))
                            .frame(width: 8, height: 1)
                    }
                }
            }

            Text(pet.stage.displayName)
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(.black.opacity(0.4))
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
