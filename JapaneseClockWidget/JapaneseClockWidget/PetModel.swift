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
    case hedgehog
    case whale
    case dolphin
    case lizard
    case owl
    case seal
    case axolotl
    case kiwi

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
        case .hedgehog: return "고슴도치"
        case .whale: return "고래"
        case .dolphin: return "돌고래"
        case .lizard: return "도마뱀"
        case .owl: return "부엉이"
        case .seal: return "물범"
        case .axolotl: return "우파루파"
        case .kiwi: return "키위새"
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
        case .hedgehog: return "はりねずみ"
        case .whale: return "くじら"
        case .dolphin: return "イルカ"
        case .lizard: return "トカゲ"
        case .owl: return "ふくろう"
        case .seal: return "アザラシ"
        case .axolotl: return "ウーパールーパー"
        case .kiwi: return "キーウィ"
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
        case .normal: return 0.80
        case .rare: return 0.18
        case .legendary: return 0.02
        }
    }
}

enum WidgetColorMode: String, Codable, CaseIterable {
    case system
    case petColor

    var displayName: String {
        switch self {
        case .system: return "시스템 모드"
        case .petColor: return "캐릭터 색상"
        }
    }

    var description: String {
        switch self {
        case .system: return "라이트/다크 모드를 따릅니다"
        case .petColor: return "장착한 펫의 색상이 반영됩니다"
        }
    }
}

// MARK: - Pet Item

enum PetItem: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }
    case growthPotion   // 성장 촉진 포션
    case food           // 먹이 (30분 단축)
    case dualSlotTicket // 펫 선택 슬롯권

    var displayName: String {
        switch self {
        case .growthPotion: return "성장 촉진 포션"
        case .food: return "먹이"
        case .dualSlotTicket: return "펫 선택 슬롯권"
        }
    }

    var description: String {
        switch self {
        case .growthPotion: return "펫이 한 단계 성장해요"
        case .food: return "성장 시간이 30분 단축돼요"
        case .dualSlotTicket: return "두 마리를 동시에 장착할 수 있어요 (1회)"
        }
    }

    var icon: String {
        switch self {
        case .growthPotion: return "bolt.fill"
        case .food: return "bag.fill"
        case .dualSlotTicket: return "person.2.fill"
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
                let totalMinutes = Int(remaining * 60)
                if totalMinutes < 1 { return "\(label)까지 잠시 후" }
                if totalMinutes < 60 { return "\(label)까지 \(totalMinutes)분" }
                let h = totalMinutes / 60
                let m = totalMinutes % 60
                return m > 0 ? "\(label)까지 \(h)시간 \(m)분" : "\(label)까지 \(h)시간"
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
    var lastDailyFreeDate: Date?
    // 아이템 관련 (신규)
    var itemInventory: [String: Int]  // PetItem.rawValue → count
    var secondaryPetId: UUID?
    var adItemCountToday: Int
    var lastAdItemDate: Date?

    static let empty = PetStore(
        currentPetId: nil,
        collection: [],
        freeGachaUsed: false,
        gachaTickets: 0,
        inviteCode: UUID().uuidString.prefix(8).lowercased().description,
        inviteCount: 0,
        adGachaCountToday: 0,
        lastAdGachaDate: nil,
        lastDailyFreeDate: nil,
        itemInventory: [:],
        secondaryPetId: nil,
        adItemCountToday: 0,
        lastAdItemDate: nil
    )

    // Backward-compatible decoding (기존 저장 데이터에 신규 필드 없어도 OK)
    enum CodingKeys: String, CodingKey {
        case currentPetId, collection, freeGachaUsed, gachaTickets
        case inviteCode, inviteCount, adGachaCountToday, lastAdGachaDate, lastDailyFreeDate
        case itemInventory, secondaryPetId, adItemCountToday, lastAdItemDate
    }

    init(currentPetId: UUID?, collection: [Pet], freeGachaUsed: Bool, gachaTickets: Int,
         inviteCode: String, inviteCount: Int, adGachaCountToday: Int,
         lastAdGachaDate: Date?, lastDailyFreeDate: Date? = nil,
         itemInventory: [String: Int] = [:], secondaryPetId: UUID? = nil,
         adItemCountToday: Int = 0, lastAdItemDate: Date? = nil) {
        self.currentPetId = currentPetId
        self.collection = collection
        self.freeGachaUsed = freeGachaUsed
        self.gachaTickets = gachaTickets
        self.inviteCode = inviteCode
        self.inviteCount = inviteCount
        self.adGachaCountToday = adGachaCountToday
        self.lastAdGachaDate = lastAdGachaDate
        self.lastDailyFreeDate = lastDailyFreeDate
        self.itemInventory = itemInventory
        self.secondaryPetId = secondaryPetId
        self.adItemCountToday = adItemCountToday
        self.lastAdItemDate = lastAdItemDate
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        currentPetId = try c.decodeIfPresent(UUID.self, forKey: .currentPetId)
        collection = try c.decode([Pet].self, forKey: .collection)
        freeGachaUsed = try c.decode(Bool.self, forKey: .freeGachaUsed)
        gachaTickets = try c.decode(Int.self, forKey: .gachaTickets)
        inviteCode = try c.decode(String.self, forKey: .inviteCode)
        inviteCount = try c.decode(Int.self, forKey: .inviteCount)
        adGachaCountToday = try c.decode(Int.self, forKey: .adGachaCountToday)
        lastAdGachaDate = try c.decodeIfPresent(Date.self, forKey: .lastAdGachaDate)
        lastDailyFreeDate = try c.decodeIfPresent(Date.self, forKey: .lastDailyFreeDate)
        itemInventory = try c.decodeIfPresent([String: Int].self, forKey: .itemInventory) ?? [:]
        secondaryPetId = try c.decodeIfPresent(UUID.self, forKey: .secondaryPetId)
        adItemCountToday = try c.decodeIfPresent(Int.self, forKey: .adItemCountToday) ?? 0
        lastAdItemDate = try c.decodeIfPresent(Date.self, forKey: .lastAdItemDate)
    }

    var currentPet: Pet? {
        guard let id = currentPetId else { return nil }
        return collection.first { $0.id == id }
    }

    var secondaryPet: Pet? {
        guard let id = secondaryPetId else { return nil }
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

    var canAdItemDraw: Bool {
        if let lastDate = lastAdItemDate,
           Date().timeIntervalSince(lastDate) < 12 * 3600 {
            return adItemCountToday < 5
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

    var canDailyFreeGacha: Bool {
        guard let lastDate = store.lastDailyFreeDate else { return true }
        return !Calendar.current.isDateInToday(lastDate)
    }

    func useDailyFreeGacha() -> Pet {
        let pet = rollGacha()
        store.lastDailyFreeDate = Date()
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

    // MARK: - Item System

    var canAdItemDraw: Bool { store.canAdItemDraw }

    func itemCount(for item: PetItem) -> Int {
        store.itemInventory[item.rawValue] ?? 0
    }

    /// 확률 기반 랜덤 아이템 반환 (인벤토리에 추가)
    @discardableResult
    func drawRandomItem() -> PetItem {
        let roll = Double.random(in: 0..<1)
        let item: PetItem
        if roll < 0.75 {
            item = .food
        } else if roll < 0.95 {
            item = .growthPotion
        } else {
            item = .dualSlotTicket
        }
        store.itemInventory[item.rawValue, default: 0] += 1
        save()
        return item
    }

    /// 광고 시청 후 아이템 뽑기 (카운터 업데이트 포함)
    func useAdItemDraw() -> PetItem {
        let item = drawRandomItem()
        if let lastDate = store.lastAdItemDate,
           Date().timeIntervalSince(lastDate) < 12 * 3600 {
            store.adItemCountToday += 1
        } else {
            store.adItemCountToday = 1
            store.lastAdItemDate = Date()
        }
        save()
        return item
    }

    /// 성장 촉진 포션 사용 — 다음 단계 임계값까지 성장 추가
    @discardableResult
    func useGrowthPotion(on petId: UUID) -> Bool {
        guard let index = store.collection.firstIndex(where: { $0.id == petId }),
              itemCount(for: .growthPotion) > 0 else { return false }

        // 성체면 사용 불가
        guard store.collection[index].stage != .adult else { return false }

        // 현재 장착 중이면 누적 시간 먼저 flush
        if let since = store.collection[index].equippedSince {
            store.collection[index].accumulatedGrowth += Date().timeIntervalSince(since)
            store.collection[index].equippedSince = Date()
        }

        let thresholds: [Double] = [12.0, 36.0, 72.0]  // hours
        let currentHours = store.collection[index].totalGrowthHours
        if let nextThreshold = thresholds.first(where: { $0 > currentHours }) {
            let needed = (nextThreshold - currentHours) * 3600
            store.collection[index].accumulatedGrowth += needed
        }

        store.itemInventory[PetItem.growthPotion.rawValue, default: 1] -= 1
        save()
        return true
    }

    /// 먹이 사용 — 30분(1800초) 성장 단축
    @discardableResult
    func useFood(on petId: UUID) -> Bool {
        guard let index = store.collection.firstIndex(where: { $0.id == petId }),
              itemCount(for: .food) > 0 else { return false }

        guard store.collection[index].stage != .adult else { return false }

        if let since = store.collection[index].equippedSince {
            store.collection[index].accumulatedGrowth += Date().timeIntervalSince(since)
            store.collection[index].equippedSince = Date()
        }
        store.collection[index].accumulatedGrowth += 1800

        store.itemInventory[PetItem.food.rawValue, default: 1] -= 1
        save()
        return true
    }

    /// 듀얼 슬롯권 사용 — 두 번째 슬롯 활성화
    @discardableResult
    func useDualSlotTicket() -> Bool {
        guard itemCount(for: .dualSlotTicket) > 0 else { return false }
        store.itemInventory[PetItem.dualSlotTicket.rawValue, default: 1] -= 1
        // secondaryPetId는 equipSecondaryPet()에서 지정
        save()
        return true
    }

    /// 두 번째 슬롯에 펫 장착
    func equipSecondaryPet(_ id: UUID) {
        guard let index = store.collection.firstIndex(where: { $0.id == id }) else { return }
        // 기존 세컨더리 펫 해제
        clearSecondaryPet()
        store.collection[index].equippedSince = Date()
        store.secondaryPetId = id
        save()
    }

    /// 두 번째 슬롯 해제
    func clearSecondaryPet() {
        guard let secId = store.secondaryPetId,
              let index = store.collection.firstIndex(where: { $0.id == secId }) else { return }
        if let since = store.collection[index].equippedSince {
            store.collection[index].accumulatedGrowth += Date().timeIntervalSince(since)
        }
        store.collection[index].equippedSince = nil
        store.secondaryPetId = nil
        save()
    }

    // MARK: - Time-based Reset

    /// 앱 포그라운드 복귀 / 뷰 진입 시 호출 — 만료된 카운터 초기화
    func checkAndResetTimers() {
        var changed = false

        // 광고 알 뽑기: 하루(자정) 기준 리셋
        if let lastDate = store.lastAdGachaDate,
           !Calendar.current.isDateInToday(lastDate) {
            store.adGachaCountToday = 0
            store.lastAdGachaDate = nil
            changed = true
        }

        // 광고 아이템 뽑기: 12시간 기준 리셋
        if let lastDate = store.lastAdItemDate,
           Date().timeIntervalSince(lastDate) >= 12 * 3600 {
            store.adItemCountToday = 0
            store.lastAdItemDate = nil
            changed = true
        }

        if changed { save() }
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

    // MARK: - Display Mode (shared with widget)

    private static let displayModeKey = "displayMode"
    private static let widgetColorModeKey = "widgetColorMode"

    func saveDisplayMode(_ mode: DisplayMode) {
        defaults.set(mode.rawValue, forKey: Self.displayModeKey)
    }

    static func loadDisplayMode() -> DisplayMode {
        let defaults = UserDefaults(suiteName: suiteName) ?? .standard
        let raw = defaults.string(forKey: displayModeKey) ?? DisplayMode.kanjiOnly.rawValue
        return DisplayMode(rawValue: raw) ?? .kanjiOnly
    }

    func saveWidgetColorMode(_ mode: WidgetColorMode) {
        defaults.set(mode.rawValue, forKey: Self.widgetColorModeKey)
    }

    static func loadWidgetColorMode() -> WidgetColorMode {
        let defaults = UserDefaults(suiteName: suiteName) ?? .standard
        let raw = defaults.string(forKey: widgetColorModeKey) ?? WidgetColorMode.system.rawValue
        return WidgetColorMode(rawValue: raw) ?? .system
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
