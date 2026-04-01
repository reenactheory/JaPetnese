import SwiftUI

struct PixelCatView: View {
    let pixelSize: CGFloat
    var animated: Bool = true

    @State private var frame = 0

    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    // 0=clear, 1=body, 2=light belly, 3=ear pink, 4=eye, 5=nose pink, 6=tail
    // Cat facing right, tail on left side

    // Frame 1: tail up
    private let f1: [[Int]] = [
        [0,0,0,0,0,0,0,0,1,0,1],
        [0,0,0,0,0,0,0,1,3,1,3,1],
        [6,0,0,0,0,0,0,1,1,1,1,1],
        [0,6,0,0,0,0,0,1,4,1,1,4,1],
        [0,0,6,1,1,1,1,1,1,5,1,1,1],
        [0,0,0,1,1,1,1,1,1,1,1,1,1],
        [0,0,0,1,2,1,1,1,1,1,2,1,0],
        [0,0,0,0,1,0,0,0,0,1,0,0,0],
    ]

    // Frame 2: tail down
    private let f2: [[Int]] = [
        [0,0,0,0,0,0,0,0,1,0,1],
        [0,0,0,0,0,0,0,1,3,1,3,1],
        [0,0,0,0,0,0,0,1,1,1,1,1],
        [0,0,0,0,0,0,0,1,4,1,1,4,1],
        [0,0,0,1,1,1,1,1,1,5,1,1,1],
        [0,0,0,1,1,1,1,1,1,1,1,1,1],
        [6,0,0,1,2,1,1,1,1,1,2,1,0],
        [0,6,0,0,1,0,0,0,0,1,0,0,0],
    ]

    private let body1 = Color(red: 0.35, green: 0.35, blue: 0.38)
    private let belly = Color(red: 0.55, green: 0.55, blue: 0.58)
    private let pink = Color(red: 0.95, green: 0.65, blue: 0.68)
    private let eye = Color(red: 0.15, green: 0.15, blue: 0.18)
    private let tail = Color(red: 0.35, green: 0.35, blue: 0.38)

    private func colorFor(_ v: Int) -> Color {
        switch v {
        case 1: return body1
        case 2: return belly
        case 3: return pink
        case 4: return eye
        case 5: return pink
        case 6: return tail
        default: return .clear
        }
    }

    var body: some View {
        let current = animated ? (frame % 2 == 0 ? f1 : f2) : f1
        let maxCols = current.map { $0.count }.max() ?? 0

        VStack(spacing: 0) {
            ForEach(0..<current.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<maxCols, id: \.self) { col in
                        let val = col < current[row].count ? current[row][col] : 0
                        if val == 0 {
                            Color.clear.frame(width: pixelSize, height: pixelSize)
                        } else {
                            colorFor(val).frame(width: pixelSize, height: pixelSize)
                        }
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            if animated { frame += 1 }
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.96, green: 0.96, blue: 0.96)
        PixelCatView(pixelSize: 8)
    }
}
