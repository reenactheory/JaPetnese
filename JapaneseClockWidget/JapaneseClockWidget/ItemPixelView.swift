import SwiftUI

struct ItemPixelView: View {
    let item: PetItem
    var pixelSize: CGFloat = 6

    var body: some View {
        if let spriteData = itemSprites[item] {
            VStack(spacing: 0) {
                ForEach(0..<spriteData.pixels.count, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<spriteData.pixels[row].count, id: \.self) { col in
                            let val = spriteData.pixels[row][col]
                            Rectangle()
                                .fill(spriteData.colors[val] ?? .clear)
                                .frame(width: pixelSize, height: pixelSize)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Button Icon Pixel View

struct ButtonIconView: View {
    let icon: ButtonIcon
    var pixelSize: CGFloat = 4

    var body: some View {
        if let spriteData = buttonIconSprites[icon] {
            VStack(spacing: 0) {
                ForEach(0..<spriteData.pixels.count, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<spriteData.pixels[row].count, id: \.self) { col in
                            let val = spriteData.pixels[row][col]
                            Rectangle()
                                .fill(spriteData.colors[val] ?? .clear)
                                .frame(width: pixelSize, height: pixelSize)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 24) {
            VStack {
                ItemPixelView(item: .growthPotion, pixelSize: 8)
                Text("포션").font(.caption)
            }
            VStack {
                ItemPixelView(item: .food, pixelSize: 8)
                Text("먹이").font(.caption)
            }
            VStack {
                ItemPixelView(item: .dualSlotTicket, pixelSize: 8)
                Text("슬롯권").font(.caption)
            }
        }
        HStack(spacing: 24) {
            VStack {
                ButtonIconView(icon: .gift, pixelSize: 6)
                Text("선물").font(.caption)
            }
            VStack {
                ButtonIconView(icon: .egg, pixelSize: 6)
                Text("알").font(.caption)
            }
            VStack {
                ButtonIconView(icon: .itemBag, pixelSize: 6)
                Text("가방").font(.caption)
            }
            VStack {
                ButtonIconView(icon: .cooldown, pixelSize: 6)
                Text("시계").font(.caption)
            }
        }
    }
    .padding()
}
