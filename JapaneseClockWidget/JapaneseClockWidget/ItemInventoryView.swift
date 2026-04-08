import SwiftUI

struct ItemInventoryView: View {
    @ObservedObject var petManager = PetManager.shared
    @State private var selectedItem: PetItem?       // non-nil이면 sheet 표시
    @State private var lastSelectedItem: PetItem?   // onDismiss에서 참조용
    @State private var dualSlotPending = false
    @State private var pendingPetId: UUID?
    // 먹이 수량 선택
    @State private var showFoodQuantity = false
    @State private var foodQuantity = 1
    @State private var foodTargetPetId: UUID?
    // 결과 피드백
    @State private var resultMessage: String?
    @State private var resultItem: PetItem?
    @State private var showResult = false
    @State private var resultPet: Pet?
    @State private var foodParticles: [FoodParticle] = []

    private var ownedItems: [PetItem] {
        PetItem.allCases.filter { petManager.itemCount(for: $0) > 0 }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.96, green: 0.96, blue: 0.96).ignoresSafeArea()

                if ownedItems.isEmpty && !showResult {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            Spacer().frame(height: 8)
                            ForEach(PetItem.allCases, id: \.self) { item in
                                let count = petManager.itemCount(for: item)
                                if count > 0 {
                                    itemCard(item: item, count: count)
                                }
                            }
                            Spacer().frame(height: 16)
                        }
                        .padding(.horizontal, 16)
                    }
                }

                // 사용 결과 오버레이
                if showResult {
                    resultOverlay
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                }
            }
            .navigationTitle("아이템")
            .navigationBarTitleDisplayMode(.inline)
            // .sheet(item:) 사용 — selectedItem이 non-nil일 때만 sheet 열림
            // if let 없이 item을 직접 받으므로 race condition 없음
            .sheet(item: $selectedItem, onDismiss: {
                guard let item = lastSelectedItem, let petId = pendingPetId else {
                    lastSelectedItem = nil; pendingPetId = nil; return
                }
                lastSelectedItem = nil; pendingPetId = nil

                if item == .food && petManager.itemCount(for: .food) > 1 {
                    foodTargetPetId = petId
                    foodQuantity = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        showFoodQuantity = true
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        applyItemToPet(item: item, petId: petId, quantity: 1)
                    }
                }
            }) { item in
                PetPickerSheet(item: item, isDualSlot: false) { petId in
                    lastSelectedItem = item  // onDismiss에서 쓸 item 저장
                    pendingPetId = petId
                    selectedItem = nil       // sheet 닫기
                }
            }
            .sheet(isPresented: $showFoodQuantity) {
                if let petId = foodTargetPetId {
                    FoodQuantitySheet(
                        maxCount: petManager.itemCount(for: .food),
                        quantity: $foodQuantity
                    ) {
                        applyItemToPet(item: .food, petId: petId, quantity: foodQuantity)
                        showFoodQuantity = false
                        foodTargetPetId = nil
                    }
                }
            }
            .sheet(isPresented: $dualSlotPending, onDismiss: {
                guard let petId = pendingPetId else { pendingPetId = nil; return }
                pendingPetId = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    petManager.equipSecondaryPet(petId)
                    showResultFeedback(
                        item: .dualSlotTicket,
                        message: "두 번째 슬롯에 펫을 장착했어요!",
                        pet: petManager.store.collection.first { $0.id == petId }
                    )
                }
            }) {
                PetPickerSheet(item: .dualSlotTicket, isDualSlot: true) { petId in
                    pendingPetId = petId
                    dualSlotPending = false
                }
            }
        }
    }

    // MARK: - Apply Item

    private func applyItemToPet(item: PetItem, petId: UUID, quantity: Int = 1) {
        let petBefore = petManager.store.collection.first { $0.id == petId }
        let stageBefore = petBefore?.stage

        var successCount = 0
        if item == .growthPotion {
            if petManager.useGrowthPotion(on: petId) { successCount = 1 }
        } else if item == .food {
            for _ in 0..<quantity {
                if petManager.useFood(on: petId) {
                    successCount += 1
                } else {
                    break  // 성체 도달 시 중단
                }
            }
        }

        let petAfter = petManager.store.collection.first { $0.id == petId }
        let stageAfter = petAfter?.stage

        if successCount > 0 {
            var msg: String
            if item == .growthPotion {
                if stageBefore != stageAfter, let newStage = stageAfter {
                    msg = "\(newStage.icon) \(newStage.displayName)(으)로 성장했어요!"
                } else {
                    msg = "성장이 촉진되었어요!"
                }
            } else {
                let totalMin = successCount * 30
                msg = "\(totalMin)분 성장 단축!"
                if stageBefore != stageAfter, let newStage = stageAfter {
                    msg += " \(newStage.icon) \(newStage.displayName)(으)로 진화!"
                }
            }
            showResultFeedback(item: item, message: msg, pet: petAfter)
        }
    }

    private func showResultFeedback(item: PetItem, message: String, pet: Pet?) {
        resultItem = item
        resultMessage = message
        resultPet = pet
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            showResult = true
        }
        if item == .food {
            launchFoodParticles()
        }
    }

    private func launchFoodParticles() {
        let emojis = ["🍖", "❤️", "✨", "💛", "🍖", "❤️", "✨"]
        foodParticles = (0..<7).map { i in
            FoodParticle(
                id: i,
                emoji: emojis[i % emojis.count],
                xOffset: CGFloat.random(in: -80...80),
                delay: Double(i) * 0.08
            )
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            foodParticles = []
        }
    }

    // MARK: - Result Overlay

    private var resultOverlay: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
                .onTapGesture { dismissResult() }

            VStack(spacing: 20) {
                if let item = resultItem {
                    ItemPixelView(item: item, pixelSize: 8)
                        .padding(.top, 8)
                }

                // 펫 + 먹이 파티클
                ZStack {
                    if let pet = resultPet {
                        PetView(pet: pet, pixelSize: 7, animated: true)
                            .scaleEffect(resultItem == .food ? 1.0 : 1.0)
                            .modifier(FoodBounceModifier(active: resultItem == .food))
                    }
                    // 파티클 레이어
                    ForEach(foodParticles) { particle in
                        FoodParticleView(particle: particle)
                    }
                }
                .frame(height: 80)

                if let msg = resultMessage {
                    Text(msg)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                }

                Button {
                    dismissResult()
                } label: {
                    Text("확인")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 10)
                        .background(.black, in: Capsule())
                }
            }
            .padding(28)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: .black.opacity(0.1), radius: 30, y: 10)
            .padding(.horizontal, 40)
        }
    }

    private func dismissResult() {
        withAnimation(.easeOut(duration: 0.2)) {
            showResult = false
            resultMessage = nil
            resultItem = nil
            resultPet = nil
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bag")
                .font(.system(size: 48))
                .foregroundStyle(.black.opacity(0.35))
            Text("아이템이 없어요")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.black.opacity(0.55))
            Text("뽑기 탭에서 광고를 보고\n아이템을 받아보세요!")
                .font(.system(size: 13))
                .foregroundStyle(.black.opacity(0.4))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Item Card

    private func itemCard(item: PetItem, count: Int) -> some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.black.opacity(0.04))
                    .frame(width: 52, height: 52)
                ItemPixelView(item: item, pixelSize: 5)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(item.displayName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black)
                    Text("\u{00d7}\(count)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(.black.opacity(0.75), in: Capsule())
                }
                Text(item.description)
                    .font(.system(size: 12))
                    .foregroundStyle(.black.opacity(0.4))
            }

            Spacer()

            Button {
                useItem(item)
            } label: {
                Text("사용")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(.black, in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.03), radius: 8, y: 2)
    }

    // MARK: - Use Item

    private func useItem(_ item: PetItem) {
        switch item {
        case .growthPotion, .food:
            selectedItem = item   // sheet(item:)이 자동으로 sheet 표시
        case .dualSlotTicket:
            if petManager.useDualSlotTicket() {
                dualSlotPending = true
            }
        }
    }
}

// MARK: - Pet Picker Sheet

struct PetPickerSheet: View {
    let item: PetItem
    let isDualSlot: Bool
    let onSelect: (UUID) -> Void

    @ObservedObject var petManager = PetManager.shared
    @Environment(\.dismiss) private var dismiss

    private var eligiblePets: [Pet] {
        if isDualSlot {
            return petManager.store.collection.filter {
                $0.id != petManager.store.currentPetId
            }
        } else {
            return petManager.store.collection.filter { $0.stage != .adult }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.96, green: 0.96, blue: 0.96).ignoresSafeArea()

                if eligiblePets.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "pawprint")
                            .font(.system(size: 40))
                            .foregroundStyle(.black.opacity(0.15))
                        Text(isDualSlot ? "장착할 펫이 없어요" : "성장 중인 펫이 없어요")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.black.opacity(0.3))
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            // 사용할 아이템 표시
                            HStack(spacing: 10) {
                                ItemPixelView(item: item, pixelSize: 4)
                                Text(isDualSlot ? "함께 장착할 펫을 선택하세요" : "\(item.displayName)을 사용할 펫을 선택하세요")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(.black.opacity(0.5))
                            }
                            .padding(.vertical, 12)

                            ForEach(eligiblePets) { pet in
                                petRow(pet: pet)
                            }
                            Spacer().frame(height: 16)
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .navigationTitle(isDualSlot ? "두 번째 펫 선택" : "펫 선택")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                        .foregroundStyle(.black)
                }
            }
        }
    }

    private func petRow(pet: Pet) -> some View {
        Button {
            onSelect(pet.id)
        } label: {
            HStack(spacing: 14) {
                PetView(pet: pet, pixelSize: 5)
                    .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 3) {
                    Text(pet.displaySpeciesName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.black)
                    HStack(spacing: 4) {
                        Text(pet.stage.icon)
                            .font(.system(size: 11))
                        Text(pet.stage.displayName)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(.black.opacity(0.5))
                        if let remaining = pet.nextStageIn {
                            Text("·")
                                .foregroundStyle(.black.opacity(0.2))
                            Text(remaining)
                                .font(.system(size: 11))
                                .foregroundStyle(.black.opacity(0.4))
                        }
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(.black.opacity(0.2))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: .black.opacity(0.03), radius: 6, y: 2)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Food Quantity Sheet

struct FoodQuantitySheet: View {
    let maxCount: Int
    @Binding var quantity: Int
    let onConfirm: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                Spacer()

                ItemPixelView(item: .food, pixelSize: 10)

                Text("먹이를 몇 개 사용할까요?")
                    .font(.system(size: 17, weight: .semibold))

                Text("1개당 30분 단축")
                    .font(.system(size: 13))
                    .foregroundStyle(.black.opacity(0.4))

                // 수량 선택
                HStack(spacing: 20) {
                    Button {
                        if quantity > 1 { quantity -= 1 }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(quantity > 1 ? .black : .black.opacity(0.15))
                    }
                    .disabled(quantity <= 1)

                    VStack(spacing: 2) {
                        Text("\(quantity)")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(.black)
                        Text("\(quantity * 30)분 단축")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.black.opacity(0.4))
                    }
                    .frame(width: 100)

                    Button {
                        if quantity < maxCount { quantity += 1 }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(quantity < maxCount ? .black : .black.opacity(0.15))
                    }
                    .disabled(quantity >= maxCount)
                }

                // 전체 사용 버튼
                if maxCount > 2 {
                    Button {
                        quantity = maxCount
                    } label: {
                        Text("전부 사용 (\(maxCount)개)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.black.opacity(0.5))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(.black.opacity(0.06), in: Capsule())
                    }
                }

                Spacer()

                Button {
                    onConfirm()
                } label: {
                    Text("\(quantity)개 사용하기")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.black, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
            .navigationTitle("먹이 사용")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

// MARK: - Food Particle Models & Views

struct FoodParticle: Identifiable {
    let id: Int
    let emoji: String
    let xOffset: CGFloat
    let delay: Double
}

struct FoodParticleView: View {
    let particle: FoodParticle
    @State private var appeared = false

    var body: some View {
        Text(particle.emoji)
            .font(.system(size: 18))
            .offset(x: particle.xOffset, y: appeared ? -90 : 0)
            .opacity(appeared ? 0 : 1)
            .scaleEffect(appeared ? 0.5 : 1.0)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + particle.delay) {
                    withAnimation(.easeOut(duration: 1.0)) {
                        appeared = true
                    }
                }
            }
    }
}

// 먹이 사용 시 펫 통통 바운스
struct FoodBounceModifier: ViewModifier {
    let active: Bool
    @State private var bouncing = false

    func body(content: Content) -> some View {
        content
            .offset(y: bouncing ? -10 : 0)
            .onAppear {
                guard active else { return }
                withAnimation(.interpolatingSpring(stiffness: 300, damping: 8).repeatCount(3, autoreverses: true)) {
                    bouncing = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    bouncing = false
                }
            }
    }
}

#Preview {
    ItemInventoryView()
}
