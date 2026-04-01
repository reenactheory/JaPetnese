import Foundation

// MARK: - Enums

enum PetSpecies: String, Codable, CaseIterable {
    case cat
    case shiba
    case rabbit
    case fox
    case raccoon
    case penguin
    case hamster
    case jellyfish
    case goldfish
    case clownfish
    case otter
    case squirrel
    case polarBear
    case frog
    case panda
    case turtle
    case monkey
    case duck
    case parrot

    var displayName: String {
        switch self {
        case .cat: return "고양이"
        case .shiba: return "시바견"
        case .rabbit: return "토끼"
        case .fox: return "여우"
        case .raccoon: return "너구리"
        case .penguin: return "펭귄"
        case .hamster: return "햄스터"
        case .jellyfish: return "해파리"
        case .goldfish: return "금붕어"
        case .clownfish: return "흰동가리"
        case .otter: return "해달"
        case .squirrel: return "다람쥐"
        case .polarBear: return "북극곰"
        case .frog: return "개구리"
        case .panda: return "판다"
        case .turtle: return "거북이"
        case .monkey: return "원숭이"
        case .duck: return "오리"
        case .parrot: return "앵무새"
        }
    }

    var japaneseName: String {
        switch self {
        case .cat: return "ねこ"
        case .shiba: return "しば"
        case .rabbit: return "うさぎ"
        case .fox: return "きつね"
        case .raccoon: return "たぬき"
        case .penguin: return "ペンギン"
        case .hamster: return "ハムスター"
        case .jellyfish: return "くらげ"
        case .goldfish: return "きんぎょ"
        case .clownfish: return "クマノミ"
        case .otter: return "ラッコ"
        case .squirrel: return "リス"
        case .polarBear: return "しろくま"
        case .frog: return "かえる"
        case .panda: return "パンダ"
        case .turtle: return "かめ"
        case .monkey: return "さる"
        case .duck: return "あひる"
        case .parrot: return "インコ"
        }
    }
}

enum PetRarity: String, Codable {
    case normal
    case rare
    case legendary

    var displayName: String {
        switch self {
        case .normal: return "노멀"
        case .rare: return "레어"
        case .legendary: return "레전더리"
        }
    }

    var probability: Double {
        switch self {
        case .normal: return 0.70
        case .rare: return 0.25
        case .legendary: return 0.05
        }
    }
}

enum PetAccessory: String, Codable, CaseIterable {
    case crown
    case ribbon
    case halo
    case flowerCrown

    var displayName: String {
        switch self {
        case .crown: return "왕관"
        case .ribbon: return "리본"
        case .halo: return "천사 고리"
        case .flowerCrown: return "꽃관"
        }
    }
}

enum PetStage: String, Codable {
    case egg
    case baby       // 유아기
    case juvenile   // 청소년기
    case adult      // 성체

    var displayName: String {
        switch self {
        case .egg: return "알"
        case .baby: return "유아기"
        case .juvenile: return "청소년기"
        case .adult: return "성체"
        }
    }

    var icon: String {
        switch self {
        case .egg: return "🥚"
        case .baby: return "🐣"
        case .juvenile: return "🌱"
        case .adult: return "⭐"
        }
    }
}

// MARK: - Pet Model

struct Pet: Codable, Identifiable {
    let id: UUID
    let species: PetSpecies
    let rarity: PetRarity
    let colorVariant: Int // 0, 1, 2... per species
    let accessory: PetAccessory? // legendary only
    let createdAt: Date

    /// 장착 중 누적된 성장 시간 (초)
    var accumulatedGrowth: TimeInterval
    /// 현재 장착이 시작된 시점 (장착 중이면 non-nil)
    var equippedSince: Date?

    /// 장착 중인 시간 포함 총 성장 시간 (시간 단위)
    var totalGrowthHours: Double {
        var total = accumulatedGrowth
        if let since = equippedSince {
            total += Date().timeIntervalSince(since)
        }
        return total / 3600
    }

    // 알: 0~12h, 유아기: 12~36h, 청소년기: 36~72h, 성체: 72h+
    var stage: PetStage {
        let hours = totalGrowthHours
        if hours < 12 { return .egg }
        if hours < 36 { return .baby }
        if hours < 72 { return .juvenile }
        return .adult
    }

    var isEquipped: Bool { equippedSince != nil }

    /// 알 상태에서는 정체를 숨김, 유아기부터 실루엣 공개
    var isRevealed: Bool { stage != .egg }

    /// 이름은 성체가 되어야 공개
    var isNameRevealed: Bool { stage == .adult }

    var displaySpeciesName: String {
        if stage == .egg { return "???" }
        if stage == .baby { return "???" }
        return species.displayName
    }

    var displayJapaneseName: String {
        if stage == .adult { return species.japaneseName }
        return "???"
    }

    var displayRarityName: String {
        if stage == .adult { return rarity.displayName }
        return "???"
    }

    var stageProgress: Double {
        let hours = totalGrowthHours
        switch stage {
        case .egg: return min(hours / 12.0, 1.0)
        case .baby: return min((hours - 12) / 24.0, 1.0)
        case .juvenile: return min((hours - 36) / 36.0, 1.0)
        case .adult: return 1.0
        }
    }

    var nextStageIn: String? {
        let hours = totalGrowthHours
        let thresholds: [(Double, String)] = [
            (12, "부화"), (36, "성장"), (72, "진화")
        ]
        for (threshold, label) in thresholds {
            if hours < threshold {
                if !isEquipped { return "장착하면 성장해요" }
                let remaining = threshold - hours
                if remaining < 1 { return "\(label)까지 \(Int(remaining * 60))분" }
                return "\(label)까지 \(Int(remaining))시간"
            }
        }
        return nil
    }
}

// MARK: - Pet Store (persisted state)

struct PetStore: Codable {
    var currentPetId: UUID?
    var collection: [Pet]
    var freeGachaUsed: Bool
    var gachaTickets: Int
    var inviteCode: String
    var inviteCount: Int
    var adGachaCountToday: Int
    var lastAdGachaDate: Date?

    static let empty = PetStore(
        currentPetId: nil,
        collection: [],
        freeGachaUsed: false,
        gachaTickets: 0,
        inviteCode: UUID().uuidString.prefix(8).lowercased().description,
        inviteCount: 0,
        adGachaCountToday: 0,
        lastAdGachaDate: nil
    )

    var currentPet: Pet? {
        guard let id = currentPetId else { return nil }
        return collection.first { $0.id == id }
    }

    var canFreeGacha: Bool { !freeGachaUsed }

    var canAdGacha: Bool {
        if let lastDate = lastAdGachaDate,
           Calendar.current.isDateInToday(lastDate) {
            return adGachaCountToday < 3
        }
        return true
    }
}

// MARK: - Pet Manager

class PetManager: ObservableObject {
    static let shared = PetManager()

    private static let suiteName = "group.com.jaeyeon.JapaneseClockWidget"
    private static let storeKey = "petStore"

    @Published var store: PetStore

    private var defaults: UserDefaults {
        UserDefaults(suiteName: Self.suiteName) ?? .standard
    }

    private init() {
        if let data = (UserDefaults(suiteName: Self.suiteName) ?? .standard).data(forKey: Self.storeKey),
           let decoded = try? JSONDecoder().decode(PetStore.self, from: data) {
            self.store = decoded
        } else {
            self.store = .empty
        }

    }

    func save() {
        if let data = try? JSONEncoder().encode(store) {
            defaults.set(data, forKey: Self.storeKey)
        }
    }

    // MARK: - Gacha

    func rollGacha() -> Pet {
        let species = PetSpecies.allCases.randomElement()!
        let rarity = rollRarity()
        let maxVariants = rarity == .legendary ? 1 : (variantCounts[species] ?? 2)
        let variant = rarity == .legendary ? 0 : Int.random(in: 0..<maxVariants)

        // 모든 펫에 랜덤 악세사리 부여 (성체가 되면 표시됨)
        let accessory: PetAccessory? = PetAccessory.allCases.randomElement()

        var pet = Pet(
            id: UUID(),
            species: species,
            rarity: rarity,
            colorVariant: variant,
            accessory: accessory,
            createdAt: Date(),
            accumulatedGrowth: 0,
            equippedSince: nil
        )

        // 첫 펫이면 자동 장착
        if store.currentPetId == nil {
            pet.equippedSince = Date()
            store.currentPetId = pet.id
        }

        store.collection.append(pet)
        save()
        return pet
    }

    func useFreeGacha() -> Pet {
        let pet = rollGacha()
        store.freeGachaUsed = true
        save()
        return pet
    }

    func useAdGacha() -> Pet {
        let pet = rollGacha()
        if let lastDate = store.lastAdGachaDate,
           Calendar.current.isDateInToday(lastDate) {
            store.adGachaCountToday += 1
        } else {
            store.adGachaCountToday = 1
            store.lastAdGachaDate = Date()
        }
        save()
        return pet
    }

    func useTicketGacha() -> Pet? {
        guard store.gachaTickets > 0 else { return nil }
        store.gachaTickets -= 1
        let pet = rollGacha()
        save()
        return pet
    }

    func addTickets(_ count: Int) {
        store.gachaTickets += count
        save()
    }

    func equipPet(_ id: UUID) {
        guard let newIndex = store.collection.firstIndex(where: { $0.id == id }) else { return }

        // 기존 장착 펫 해제 — 누적 시간 저장
        if let currentId = store.currentPetId,
           let oldIndex = store.collection.firstIndex(where: { $0.id == currentId }) {
            if let since = store.collection[oldIndex].equippedSince {
                store.collection[oldIndex].accumulatedGrowth += Date().timeIntervalSince(since)
            }
            store.collection[oldIndex].equippedSince = nil
        }

        // 새 펫 장착
        store.collection[newIndex].equippedSince = Date()
        store.currentPetId = id
        save()
    }

    func unequipCurrentPet() {
        guard let currentId = store.currentPetId,
              let index = store.collection.firstIndex(where: { $0.id == currentId }) else { return }

        if let since = store.collection[index].equippedSince {
            store.collection[index].accumulatedGrowth += Date().timeIntervalSince(since)
        }
        store.collection[index].equippedSince = nil
        store.currentPetId = nil
        save()
    }

    // MARK: - Invite

    func claimInviteReward() {
        store.inviteCount += 1
        store.gachaTickets += 1
        save()
    }

    // MARK: - Helpers

    private func rollRarity() -> PetRarity {
        let roll = Double.random(in: 0..<1)
        if roll < PetRarity.legendary.probability { return .legendary }
        if roll < PetRarity.legendary.probability + PetRarity.rare.probability { return .rare }
        return .normal
    }

    // MARK: - Static helper for widget

    static func loadCurrentPet() -> Pet? {
        let defaults = UserDefaults(suiteName: suiteName) ?? .standard
        guard let data = defaults.data(forKey: storeKey),
              let store = try? JSONDecoder().decode(PetStore.self, from: data) else {
            return nil
        }
        return store.currentPet
    }
}
