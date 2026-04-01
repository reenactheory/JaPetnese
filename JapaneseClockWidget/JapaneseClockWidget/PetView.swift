import SwiftUI

// MARK: - Animated Pet View (App)

struct PetView: View {
    let pet: Pet
    let pixelSize: CGFloat
    var animated: Bool = true

    @State private var frame = 0
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        let sprite = spriteFor(species: pet.species, stage: pet.stage)
        let palette = paletteFor(species: pet.species, rarity: pet.rarity, variant: pet.colorVariant)
        let current = animated ? (frame % 2 == 0 ? sprite.frame1 : sprite.frame2) : sprite.frame1

        ZStack {
            PixelGrid(pixels: current.pixels, palette: palette, pixelSize: pixelSize)

            // Accessory overlay for adult legendaries
            if pet.stage == .adult,
               let accessory = pet.accessory,
               let data = accessorySprites[accessory] {
                AccessoryOverlay(data: data, pixelSize: pixelSize, baseRows: current.pixels.count, baseCols: current.pixels.map { $0.count }.max() ?? 0)
            }
        }
        .onReceive(timer) { _ in
            if animated { frame += 1 }
        }
    }
}

// MARK: - Static Pet View (Widget)

struct StaticPetView: View {
    let pet: Pet
    let pixelSize: CGFloat

    var body: some View {
        let sprite = spriteFor(species: pet.species, stage: pet.stage)
        let palette = paletteFor(species: pet.species, rarity: pet.rarity, variant: pet.colorVariant)

        ZStack {
            PixelGrid(pixels: sprite.frame1.pixels, palette: palette, pixelSize: pixelSize)

            if pet.stage == .adult,
               let accessory = pet.accessory,
               let data = accessorySprites[accessory] {
                AccessoryOverlay(data: data, pixelSize: pixelSize, baseRows: sprite.frame1.pixels.count, baseCols: sprite.frame1.pixels.map { $0.count }.max() ?? 0)
            }
        }
    }
}

// MARK: - Accessory Overlay

struct AccessoryOverlay: View {
    let data: AccessoryData
    let pixelSize: CGFloat
    let baseRows: Int
    let baseCols: Int

    var body: some View {
        let accRows = data.pixels.count
        let accCols = data.pixels.map { $0.count }.max() ?? 0

        VStack(spacing: 0) {
            ForEach(0..<accRows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<accCols, id: \.self) { col in
                        let val = col < data.pixels[row].count ? data.pixels[row][col] : 0
                        if val == 0 {
                            Color.clear.frame(width: pixelSize, height: pixelSize)
                        } else {
                            (data.colors[val] ?? .clear)
                                .frame(width: pixelSize, height: pixelSize)
                        }
                    }
                }
            }
        }
        .offset(
            x: CGFloat(baseCols - accCols) / 2.0 * pixelSize * 0.6,
            y: CGFloat(data.offsetY) * pixelSize
        )
    }
}

// MARK: - Pixel Grid Renderer

struct PixelGrid: View {
    let pixels: [[Int]]
    let palette: PetPalette
    let pixelSize: CGFloat

    // 0=clear, 1=primary, 2=secondary, 3=accent, 4=eye
    private func colorFor(_ v: Int) -> Color {
        switch v {
        case 1: return palette.primary
        case 2: return palette.secondary
        case 3: return palette.accent
        case 4: return palette.eye
        default: return .clear
        }
    }

    var body: some View {
        let maxCols = pixels.map { $0.count }.max() ?? 0

        VStack(spacing: 0) {
            ForEach(0..<pixels.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<maxCols, id: \.self) { col in
                        let val = col < pixels[row].count ? pixels[row][col] : 0
                        if val == 0 {
                            Color.clear.frame(width: pixelSize, height: pixelSize)
                        } else {
                            colorFor(val).frame(width: pixelSize, height: pixelSize)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Egg View with hatching progress

struct EggView: View {
    let pet: Pet
    let pixelSize: CGFloat

    var body: some View {
        VStack(spacing: 4) {
            PetView(pet: pet, pixelSize: pixelSize)

            if let remaining = pet.nextStageIn {
                Text(remaining)
                    .font(.system(size: pixelSize * 2, weight: .medium))
                    .foregroundStyle(.black.opacity(0.3))
            }
        }
    }
}

#Preview {
    let samplePet = Pet(
        id: UUID(),
        species: .cat,
        rarity: .legendary,
        colorVariant: 0,
        accessory: .crown,
        createdAt: Date(),
        accumulatedGrowth: 80 * 3600,
        equippedSince: nil
    )

    VStack(spacing: 20) {
        PetView(pet: samplePet, pixelSize: 6)
        Text(samplePet.stage.displayName)
    }
    .padding()
}
