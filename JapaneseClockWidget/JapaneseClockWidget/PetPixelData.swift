import SwiftUI

// MARK: - Pixel Color Palette

struct PetPalette {
    let primary: Color
    let secondary: Color
    let accent: Color  // ears, nose, cheeks
    let eye: Color

    static let grayCat = PetPalette(
        primary: Color(red: 0.40, green: 0.40, blue: 0.43),
        secondary: Color(red: 0.60, green: 0.60, blue: 0.63),
        accent: Color(red: 0.95, green: 0.65, blue: 0.68),
        eye: Color(red: 0.15, green: 0.15, blue: 0.18)
    )
    static let blackCat = PetPalette(
        primary: Color(red: 0.18, green: 0.18, blue: 0.20),
        secondary: Color(red: 0.35, green: 0.35, blue: 0.38),
        accent: Color(red: 0.95, green: 0.55, blue: 0.58),
        eye: Color(red: 0.85, green: 0.75, blue: 0.20)
    )
    static let brownShiba = PetPalette(
        primary: Color(red: 0.80, green: 0.55, blue: 0.30),
        secondary: Color(red: 0.95, green: 0.90, blue: 0.80),
        accent: Color(red: 0.95, green: 0.65, blue: 0.68),
        eye: Color(red: 0.15, green: 0.15, blue: 0.18)
    )
    static let blackShiba = PetPalette(
        primary: Color(red: 0.20, green: 0.20, blue: 0.22),
        secondary: Color(red: 0.90, green: 0.85, blue: 0.75),
        accent: Color(red: 0.80, green: 0.55, blue: 0.50),
        eye: Color(red: 0.15, green: 0.15, blue: 0.18)
    )
    static let whiteRabbit = PetPalette(
        primary: Color(red: 0.92, green: 0.90, blue: 0.88),
        secondary: Color(red: 0.98, green: 0.97, blue: 0.96),
        accent: Color(red: 0.95, green: 0.60, blue: 0.65),
        eye: Color(red: 0.75, green: 0.20, blue: 0.25)
    )
    static let brownRabbit = PetPalette(
        primary: Color(red: 0.60, green: 0.40, blue: 0.30),
        secondary: Color(red: 0.85, green: 0.75, blue: 0.65),
        accent: Color(red: 0.95, green: 0.65, blue: 0.68),
        eye: Color(red: 0.15, green: 0.15, blue: 0.18)
    )
    static let orangeFox = PetPalette(
        primary: Color(red: 0.90, green: 0.55, blue: 0.20),
        secondary: Color(red: 0.95, green: 0.92, blue: 0.85),
        accent: Color(red: 0.95, green: 0.65, blue: 0.68),
        eye: Color(red: 0.15, green: 0.15, blue: 0.18)
    )
    static let raccoon = PetPalette(
        primary: Color(red: 0.45, green: 0.40, blue: 0.35),
        secondary: Color(red: 0.75, green: 0.70, blue: 0.65),
        accent: Color(red: 0.25, green: 0.22, blue: 0.20),
        eye: Color(red: 0.15, green: 0.15, blue: 0.18)
    )
    static let penguin = PetPalette(
        primary: Color(red: 0.15, green: 0.18, blue: 0.25),
        secondary: Color(red: 0.95, green: 0.95, blue: 0.95),
        accent: Color(red: 0.95, green: 0.70, blue: 0.20),
        eye: Color(red: 0.15, green: 0.15, blue: 0.18)
    )

    // Cat variants: 0=gray, 1=black, 2=orange tabby, 3=white, 4=calico
    static let orangeTabbyCat = PetPalette(
        primary: Color(red: 0.85, green: 0.55, blue: 0.25),
        secondary: Color(red: 0.95, green: 0.85, blue: 0.65),
        accent: Color(red: 0.95, green: 0.65, blue: 0.68),
        eye: Color(red: 0.45, green: 0.65, blue: 0.20)
    )
    static let whiteCat = PetPalette(
        primary: Color(red: 0.90, green: 0.88, blue: 0.86),
        secondary: Color(red: 0.98, green: 0.97, blue: 0.96),
        accent: Color(red: 0.95, green: 0.60, blue: 0.65),
        eye: Color(red: 0.35, green: 0.55, blue: 0.80)
    )
    static let calicoCat = PetPalette(
        primary: Color(red: 0.85, green: 0.60, blue: 0.30),
        secondary: Color(red: 0.95, green: 0.93, blue: 0.90),
        accent: Color(red: 0.95, green: 0.50, blue: 0.50),
        eye: Color(red: 0.15, green: 0.15, blue: 0.18)
    )

    // Shiba variants: 0=brown, 1=black, 2=cream, 3=sesame
    static let creamShiba = PetPalette(
        primary: Color(red: 0.95, green: 0.88, blue: 0.75),
        secondary: Color(red: 0.98, green: 0.96, blue: 0.92),
        accent: Color(red: 0.95, green: 0.65, blue: 0.68),
        eye: Color(red: 0.15, green: 0.15, blue: 0.18)
    )
    static let sesameShiba = PetPalette(
        primary: Color(red: 0.65, green: 0.45, blue: 0.30),
        secondary: Color(red: 0.90, green: 0.82, blue: 0.70),
        accent: Color(red: 0.95, green: 0.65, blue: 0.68),
        eye: Color(red: 0.15, green: 0.15, blue: 0.18)
    )

    // Rabbit variants: 0=white, 1=brown, 2=gray, 3=black
    static let grayRabbit = PetPalette(
        primary: Color(red: 0.55, green: 0.55, blue: 0.58),
        secondary: Color(red: 0.80, green: 0.80, blue: 0.82),
        accent: Color(red: 0.95, green: 0.60, blue: 0.65),
        eye: Color(red: 0.15, green: 0.15, blue: 0.18)
    )
    static let blackRabbit = PetPalette(
        primary: Color(red: 0.15, green: 0.15, blue: 0.18),
        secondary: Color(red: 0.30, green: 0.30, blue: 0.33),
        accent: Color(red: 0.95, green: 0.55, blue: 0.60),
        eye: Color(red: 0.70, green: 0.20, blue: 0.25)
    )

    // Fox variants: 0=orange, 1=silver, 2=arctic
    static let silverFox = PetPalette(
        primary: Color(red: 0.40, green: 0.42, blue: 0.48),
        secondary: Color(red: 0.70, green: 0.72, blue: 0.78),
        accent: Color(red: 0.95, green: 0.65, blue: 0.68),
        eye: Color(red: 0.80, green: 0.65, blue: 0.15)
    )
    static let arcticFox = PetPalette(
        primary: Color(red: 0.90, green: 0.92, blue: 0.95),
        secondary: Color(red: 0.98, green: 0.98, blue: 1.0),
        accent: Color(red: 0.85, green: 0.60, blue: 0.65),
        eye: Color(red: 0.20, green: 0.35, blue: 0.55)
    )

    // Raccoon variants: 0=brown, 1=gray, 2=red
    static let grayRaccoon = PetPalette(
        primary: Color(red: 0.50, green: 0.50, blue: 0.55),
        secondary: Color(red: 0.78, green: 0.78, blue: 0.82),
        accent: Color(red: 0.25, green: 0.25, blue: 0.28),
        eye: Color(red: 0.15, green: 0.15, blue: 0.18)
    )
    static let redRaccoon = PetPalette(
        primary: Color(red: 0.65, green: 0.35, blue: 0.25),
        secondary: Color(red: 0.85, green: 0.70, blue: 0.60),
        accent: Color(red: 0.35, green: 0.20, blue: 0.15),
        eye: Color(red: 0.15, green: 0.15, blue: 0.18)
    )

    // Penguin variants: 0=classic, 1=emperor, 2=fairy
    static let emperorPenguin = PetPalette(
        primary: Color(red: 0.12, green: 0.15, blue: 0.22),
        secondary: Color(red: 0.95, green: 0.90, blue: 0.75),
        accent: Color(red: 0.95, green: 0.80, blue: 0.25),
        eye: Color(red: 0.15, green: 0.15, blue: 0.18)
    )
    static let fairyPenguin = PetPalette(
        primary: Color(red: 0.35, green: 0.50, blue: 0.70),
        secondary: Color(red: 0.88, green: 0.92, blue: 0.96),
        accent: Color(red: 0.55, green: 0.55, blue: 0.60),
        eye: Color(red: 0.15, green: 0.15, blue: 0.18)
    )

    // Legendary variants (1 per species)
    static let goldenCat = PetPalette(
        primary: Color(red: 0.90, green: 0.75, blue: 0.30),
        secondary: Color(red: 0.98, green: 0.92, blue: 0.60),
        accent: Color(red: 0.95, green: 0.40, blue: 0.45),
        eye: Color(red: 0.55, green: 0.20, blue: 0.60)
    )
    static let legendaryShiba = PetPalette(
        primary: Color(red: 0.95, green: 0.85, blue: 0.90),
        secondary: Color(red: 0.98, green: 0.95, blue: 0.97),
        accent: Color(red: 0.90, green: 0.50, blue: 0.60),
        eye: Color(red: 0.40, green: 0.30, blue: 0.80)
    )
    static let legendaryRabbit = PetPalette(
        primary: Color(red: 0.70, green: 0.85, blue: 0.95),
        secondary: .white,
        accent: Color(red: 0.95, green: 0.60, blue: 0.70),
        eye: Color(red: 0.30, green: 0.30, blue: 0.80)
    )
    static let legendaryFox = PetPalette(
        primary: Color(red: 0.85, green: 0.85, blue: 0.95),
        secondary: .white,
        accent: Color(red: 0.60, green: 0.50, blue: 0.90),
        eye: Color(red: 0.55, green: 0.20, blue: 0.60)
    )
    static let legendaryRaccoon = PetPalette(
        primary: Color(red: 0.90, green: 0.80, blue: 0.50),
        secondary: Color(red: 0.98, green: 0.95, blue: 0.80),
        accent: Color(red: 0.70, green: 0.50, blue: 0.20),
        eye: Color(red: 0.60, green: 0.20, blue: 0.20)
    )
    static let legendaryPenguin = PetPalette(
        primary: Color(red: 0.25, green: 0.25, blue: 0.55),
        secondary: Color(red: 0.90, green: 0.90, blue: 1.0),
        accent: Color(red: 0.95, green: 0.80, blue: 0.30),
        eye: Color(red: 0.15, green: 0.15, blue: 0.18)
    )
}

// MARK: - Sprite Data

// 0=clear, 1=primary, 2=secondary, 3=accent, 4=eye
struct SpriteFrame {
    let pixels: [[Int]]
}

struct SpriteSet {
    let frame1: SpriteFrame
    let frame2: SpriteFrame
}

// MARK: - Egg Sprites (universal)

let eggSprite = SpriteSet(
    frame1: SpriteFrame(pixels: [
        [0,0,1,1,1,0,0],
        [0,1,2,2,2,1,0],
        [1,2,2,3,2,2,1],
        [1,2,2,2,2,2,1],
        [1,2,2,2,3,2,1],
        [0,1,2,2,2,1,0],
        [0,0,1,1,1,0,0],
    ]),
    frame2: SpriteFrame(pixels: [
        [0,0,1,1,1,0,0],
        [0,1,2,2,2,1,0],
        [1,2,3,2,2,2,1],
        [1,2,2,2,2,2,1],
        [1,2,2,3,2,2,1],
        [0,1,2,2,2,1,0],
        [0,0,1,1,1,0,0],
    ])
)

// MARK: - Cat Sprites

let catBaby = SpriteSet(
    frame1: SpriteFrame(pixels: [
        [0,1,0,0,0,1,0],
        [1,3,1,1,1,3,1],
        [1,4,1,2,1,4,1],
        [1,1,3,3,3,1,1],
        [0,1,1,1,1,1,0],
        [0,0,1,0,1,0,0],
    ]),
    frame2: SpriteFrame(pixels: [
        [0,1,0,0,0,1,0],
        [1,3,1,1,1,3,1],
        [1,1,1,2,1,1,1],
        [1,1,3,3,3,1,1],
        [0,1,1,1,1,1,0],
        [0,1,0,0,0,1,0],
    ])
)

let catAdult = SpriteSet(
    frame1: SpriteFrame(pixels: [
        [0,0,0,0,0,0,0,0,1,0,1],
        [0,0,0,0,0,0,0,1,3,1,3,1],
        [1,0,0,0,0,0,0,1,1,1,1,1],
        [0,1,0,0,0,0,0,1,4,1,1,4,1],
        [0,0,1,1,1,1,1,1,1,3,1,1,1],
        [0,0,0,1,1,1,1,1,1,1,1,1,1],
        [0,0,0,1,2,1,1,1,1,1,2,1,0],
        [0,0,0,0,1,0,0,0,0,1,0,0,0],
    ]),
    frame2: SpriteFrame(pixels: [
        [0,0,0,0,0,0,0,0,1,0,1],
        [0,0,0,0,0,0,0,1,3,1,3,1],
        [0,0,0,0,0,0,0,1,1,1,1,1],
        [0,0,0,0,0,0,0,1,4,1,1,4,1],
        [0,0,0,1,1,1,1,1,1,3,1,1,1],
        [0,0,0,1,1,1,1,1,1,1,1,1,1],
        [1,0,0,1,2,1,1,1,1,1,2,1,0],
        [0,1,0,0,1,0,0,0,0,1,0,0,0],
    ])
)

// MARK: - Shiba Sprites

let shibaBaby = SpriteSet(
    frame1: SpriteFrame(pixels: [
        [1,1,0,0,0,1,1],
        [1,3,1,1,1,3,1],
        [1,4,1,2,1,4,1],
        [1,2,2,3,2,2,1],
        [0,1,1,1,1,1,0],
        [0,0,1,0,1,0,0],
    ]),
    frame2: SpriteFrame(pixels: [
        [1,1,0,0,0,1,1],
        [1,3,1,1,1,3,1],
        [1,4,1,2,1,4,1],
        [1,2,2,3,2,2,1],
        [0,1,1,1,1,1,0],
        [0,1,0,0,0,1,0],
    ])
)

let shibaAdult = SpriteSet(
    frame1: SpriteFrame(pixels: [
        [0,0,0,0,0,0,0,1,1,0,0,1,1],
        [0,0,0,0,0,0,0,1,2,1,1,2,1],
        [0,0,0,0,0,0,1,2,4,2,2,4,2,1],
        [1,1,0,0,0,0,1,2,2,3,3,2,2,1],
        [0,1,1,1,1,1,1,1,1,1,1,1,1,1],
        [0,0,1,1,1,1,1,1,2,2,2,1,1,0],
        [0,0,0,1,2,1,0,0,1,2,1,0,0,0],
        [0,0,0,0,1,0,0,0,0,1,0,0,0,0],
    ]),
    frame2: SpriteFrame(pixels: [
        [0,0,0,0,0,0,0,1,1,0,0,1,1],
        [0,0,0,0,0,0,0,1,2,1,1,2,1],
        [0,0,0,0,0,0,1,2,4,2,2,4,2,1],
        [0,0,0,0,0,0,1,2,2,3,3,2,2,1],
        [0,0,1,1,1,1,1,1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1,1,2,2,2,1,1,0],
        [0,0,0,1,2,1,0,0,1,2,1,0,0,0],
        [0,0,0,0,1,0,0,0,0,1,0,0,0,0],
    ])
)

// MARK: - Rabbit Sprites

let rabbitBaby = SpriteSet(
    frame1: SpriteFrame(pixels: [
        [0,1,0,0,0,1,0],
        [0,1,0,0,0,1,0],
        [1,3,1,1,1,3,1],
        [1,4,1,2,1,4,1],
        [1,1,1,3,1,1,1],
        [0,1,1,1,1,1,0],
        [0,0,1,0,1,0,0],
    ]),
    frame2: SpriteFrame(pixels: [
        [0,1,0,0,1,0,0],
        [0,1,0,0,0,1,0],
        [1,3,1,1,1,3,1],
        [1,4,1,2,1,4,1],
        [1,1,1,3,1,1,1],
        [0,1,1,1,1,1,0],
        [0,1,0,0,0,1,0],
    ])
)

let rabbitAdult = SpriteSet(
    frame1: SpriteFrame(pixels: [
        [0,0,0,0,0,0,0,0,1,0,0,1,0],
        [0,0,0,0,0,0,0,0,1,0,0,1,0],
        [0,0,0,0,0,0,0,1,3,1,1,3,1],
        [0,0,0,0,0,0,0,1,4,2,2,4,1],
        [0,0,0,1,1,1,1,1,1,3,1,1,1],
        [1,0,0,1,1,2,2,2,1,1,1,1,0],
        [0,0,0,1,1,1,1,1,1,1,1,0,0],
        [0,0,0,0,1,0,0,0,0,1,0,0,0],
    ]),
    frame2: SpriteFrame(pixels: [
        [0,0,0,0,0,0,0,0,1,0,1,0,0],
        [0,0,0,0,0,0,0,0,1,0,0,1,0],
        [0,0,0,0,0,0,0,1,3,1,1,3,1],
        [0,0,0,0,0,0,0,1,4,2,2,4,1],
        [0,0,0,1,1,1,1,1,1,3,1,1,1],
        [0,0,0,1,1,2,2,2,1,1,1,1,0],
        [0,1,0,1,1,1,1,1,1,1,1,0,0],
        [0,0,0,0,1,0,0,0,0,1,0,0,0],
    ])
)

// MARK: - Fox Sprites

let foxBaby = SpriteSet(
    frame1: SpriteFrame(pixels: [
        [1,0,0,0,0,0,1],
        [1,1,0,0,0,1,1],
        [1,4,1,2,1,4,1],
        [1,2,2,3,2,2,1],
        [0,1,1,1,1,1,0],
        [0,0,1,0,1,0,0],
    ]),
    frame2: SpriteFrame(pixels: [
        [1,0,0,0,0,0,1],
        [1,1,0,0,0,1,1],
        [1,4,1,2,1,4,1],
        [1,2,2,3,2,2,1],
        [0,1,1,1,1,1,0],
        [0,1,0,0,0,1,0],
    ])
)

let foxAdult = SpriteSet(
    frame1: SpriteFrame(pixels: [
        [0,0,0,0,0,0,0,1,0,0,0,0,1],
        [0,0,0,0,0,0,0,1,1,0,0,1,1],
        [0,0,0,0,0,0,1,1,4,1,1,4,1,1],
        [1,1,0,0,0,0,0,1,2,2,2,2,1],
        [0,1,1,1,1,1,1,1,1,3,1,1,1],
        [0,0,1,1,1,1,1,1,2,2,2,1,0],
        [0,0,0,1,2,1,0,0,1,2,1,0,0],
        [0,0,0,0,1,0,0,0,0,1,0,0,0],
    ]),
    frame2: SpriteFrame(pixels: [
        [0,0,0,0,0,0,0,1,0,0,0,0,1],
        [0,0,0,0,0,0,0,1,1,0,0,1,1],
        [0,0,0,0,0,0,1,1,4,1,1,4,1,1],
        [0,0,0,0,0,0,0,1,2,2,2,2,1],
        [0,0,1,1,1,1,1,1,1,3,1,1,1],
        [1,1,1,1,1,1,1,1,2,2,2,1,0],
        [0,0,0,1,2,1,0,0,1,2,1,0,0],
        [0,0,0,0,1,0,0,0,0,1,0,0,0],
    ])
)

// MARK: - Raccoon Sprites

let raccoonBaby = SpriteSet(
    frame1: SpriteFrame(pixels: [
        [1,1,0,0,0,1,1],
        [1,2,1,1,1,2,1],
        [3,4,3,2,3,4,3],
        [1,1,1,3,1,1,1],
        [0,1,1,1,1,1,0],
        [0,0,1,0,1,0,0],
    ]),
    frame2: SpriteFrame(pixels: [
        [1,1,0,0,0,1,1],
        [1,2,1,1,1,2,1],
        [3,4,3,2,3,4,3],
        [1,1,1,3,1,1,1],
        [0,1,1,1,1,1,0],
        [0,1,0,0,0,1,0],
    ])
)

let raccoonAdult = SpriteSet(
    frame1: SpriteFrame(pixels: [
        [0,0,0,0,0,0,0,1,1,0,0,1,1],
        [0,0,0,0,0,0,0,1,2,1,1,2,1],
        [0,0,0,0,0,0,1,3,4,3,3,4,3,1],
        [1,1,0,0,0,0,0,1,1,3,1,1,1],
        [0,1,1,1,1,1,1,1,1,1,1,1,1],
        [0,0,1,1,2,2,2,1,2,2,1,1,0],
        [0,0,0,1,1,1,0,0,1,1,1,0,0],
        [0,0,0,0,1,0,0,0,0,1,0,0,0],
    ]),
    frame2: SpriteFrame(pixels: [
        [0,0,0,0,0,0,0,1,1,0,0,1,1],
        [0,0,0,0,0,0,0,1,2,1,1,2,1],
        [0,0,0,0,0,0,1,3,4,3,3,4,3,1],
        [0,0,0,0,0,0,0,1,1,3,1,1,1],
        [0,0,1,1,1,1,1,1,1,1,1,1,1],
        [1,1,1,1,2,2,2,1,2,2,1,1,0],
        [0,0,0,1,1,1,0,0,1,1,1,0,0],
        [0,0,0,0,1,0,0,0,0,1,0,0,0],
    ])
)

// MARK: - Penguin Sprites

let penguinBaby = SpriteSet(
    frame1: SpriteFrame(pixels: [
        [0,0,1,1,1,0,0],
        [0,1,2,2,2,1,0],
        [1,4,2,2,2,4,1],
        [1,1,2,2,2,1,1],
        [0,1,2,2,2,1,0],
        [0,0,3,0,3,0,0],
    ]),
    frame2: SpriteFrame(pixels: [
        [0,0,1,1,1,0,0],
        [0,1,2,2,2,1,0],
        [1,4,2,2,2,4,1],
        [1,1,2,2,2,1,1],
        [0,1,2,2,2,1,0],
        [0,3,0,0,0,3,0],
    ])
)

let penguinAdult = SpriteSet(
    frame1: SpriteFrame(pixels: [
        [0,0,0,0,0,0,0,0,1,1,1,0,0],
        [0,0,0,0,0,0,0,1,2,2,2,1,0],
        [0,0,0,0,0,0,1,4,2,2,2,4,1],
        [0,0,0,0,0,0,1,1,2,2,2,1,1],
        [0,0,0,0,1,1,1,1,2,2,2,1,1],
        [0,0,0,0,1,1,1,1,2,2,2,1,0],
        [0,0,0,0,0,1,1,2,2,2,1,0,0],
        [0,0,0,0,0,0,3,0,0,3,0,0,0],
    ]),
    frame2: SpriteFrame(pixels: [
        [0,0,0,0,0,0,0,0,1,1,1,0,0],
        [0,0,0,0,0,0,0,1,2,2,2,1,0],
        [0,0,0,0,0,0,1,4,2,2,2,4,1],
        [0,0,0,0,0,0,1,1,2,2,2,1,1],
        [0,0,0,0,1,1,1,1,2,2,2,1,1],
        [0,0,0,0,1,1,1,1,2,2,2,1,0],
        [0,0,0,0,0,1,1,2,2,2,1,0,0],
        [0,0,0,0,0,3,0,0,0,0,3,0,0],
    ])
)

// MARK: - Palette Lookup

// Normal variant counts per species
let variantCounts: [PetSpecies: Int] = [
    .cat: 5,        // gray, black, orange tabby, white, calico
    .shiba: 4,      // brown, black, cream, sesame
    .rabbit: 4,     // white, brown, gray, black
    .fox: 3,        // orange, silver, arctic
    .raccoon: 3,    // brown, gray, red
    .penguin: 3,    // classic, emperor, fairy
    .hamster: 3,    // cream, gray, golden
    .capybara: 2,   // brown, dark
    .jellyfish: 3,  // blue, pink, purple
    .goldfish: 3,   // red, calico, black
    .clownfish: 2,  // orange, tomato
    .otter: 2,      // brown, dark
    .squirrel: 3,   // brown, gray, red
    .polarBear: 2,  // white, cream
    .frog: 3,       // green, blue, red
    .panda: 2,      // classic, brown(red panda)
]

func paletteFor(species: PetSpecies, rarity: PetRarity, variant: Int) -> PetPalette {
    if rarity == .legendary {
        switch species {
        case .cat: return .goldenCat
        case .shiba: return .legendaryShiba
        case .rabbit: return .legendaryRabbit
        case .fox: return .legendaryFox
        case .raccoon: return .legendaryRaccoon
        case .penguin: return .legendaryPenguin
        default:
            // Generic legendary: sparkly purple
            return PetPalette(
                primary: Color(red: 0.75, green: 0.60, blue: 0.95),
                secondary: Color(red: 0.92, green: 0.88, blue: 1.0),
                accent: Color(red: 0.95, green: 0.65, blue: 0.80),
                eye: Color(red: 0.45, green: 0.20, blue: 0.70)
            )
        }
    }

    switch species {
    case .cat:
        return [.grayCat, .blackCat, .orangeTabbyCat, .whiteCat, .calicoCat][min(variant, 4)]
    case .shiba:
        return [.brownShiba, .blackShiba, .creamShiba, .sesameShiba][min(variant, 3)]
    case .rabbit:
        return [.whiteRabbit, .brownRabbit, .grayRabbit, .blackRabbit][min(variant, 3)]
    case .fox:
        return [.orangeFox, .silverFox, .arcticFox][min(variant, 2)]
    case .raccoon:
        return [.raccoon, .grayRaccoon, .redRaccoon][min(variant, 2)]
    case .penguin:
        return [.penguin, .emperorPenguin, .fairyPenguin][min(variant, 2)]
    case .hamster:
        let palettes: [PetPalette] = [
            PetPalette(primary: .init(red: 0.90, green: 0.80, blue: 0.65), secondary: .init(red: 0.98, green: 0.95, blue: 0.90), accent: .init(red: 0.95, green: 0.65, blue: 0.68), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
            PetPalette(primary: .init(red: 0.55, green: 0.55, blue: 0.58), secondary: .init(red: 0.82, green: 0.82, blue: 0.85), accent: .init(red: 0.95, green: 0.65, blue: 0.68), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
            PetPalette(primary: .init(red: 0.85, green: 0.70, blue: 0.35), secondary: .init(red: 0.95, green: 0.90, blue: 0.70), accent: .init(red: 0.95, green: 0.65, blue: 0.68), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
        ]
        return palettes[min(variant, 2)]
    case .capybara:
        let palettes: [PetPalette] = [
            PetPalette(primary: .init(red: 0.55, green: 0.40, blue: 0.30), secondary: .init(red: 0.75, green: 0.65, blue: 0.55), accent: .init(red: 0.30, green: 0.22, blue: 0.18), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
            PetPalette(primary: .init(red: 0.35, green: 0.28, blue: 0.22), secondary: .init(red: 0.55, green: 0.48, blue: 0.40), accent: .init(red: 0.25, green: 0.18, blue: 0.15), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
        ]
        return palettes[min(variant, 1)]
    case .jellyfish:
        let palettes: [PetPalette] = [
            PetPalette(primary: .init(red: 0.55, green: 0.70, blue: 0.95), secondary: .init(red: 0.80, green: 0.88, blue: 1.0), accent: .init(red: 0.55, green: 0.70, blue: 0.95), eye: .init(red: 0.20, green: 0.30, blue: 0.60)),
            PetPalette(primary: .init(red: 0.95, green: 0.60, blue: 0.75), secondary: .init(red: 1.0, green: 0.85, blue: 0.92), accent: .init(red: 0.95, green: 0.60, blue: 0.75), eye: .init(red: 0.60, green: 0.20, blue: 0.40)),
            PetPalette(primary: .init(red: 0.70, green: 0.50, blue: 0.90), secondary: .init(red: 0.88, green: 0.78, blue: 1.0), accent: .init(red: 0.70, green: 0.50, blue: 0.90), eye: .init(red: 0.40, green: 0.20, blue: 0.60)),
        ]
        return palettes[min(variant, 2)]
    case .goldfish:
        let palettes: [PetPalette] = [
            PetPalette(primary: .init(red: 0.90, green: 0.35, blue: 0.20), secondary: .init(red: 0.95, green: 0.60, blue: 0.40), accent: .init(red: 0.95, green: 0.80, blue: 0.30), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
            PetPalette(primary: .init(red: 0.90, green: 0.55, blue: 0.25), secondary: .init(red: 0.98, green: 0.95, blue: 0.90), accent: .init(red: 0.95, green: 0.80, blue: 0.30), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
            PetPalette(primary: .init(red: 0.15, green: 0.15, blue: 0.18), secondary: .init(red: 0.30, green: 0.30, blue: 0.35), accent: .init(red: 0.85, green: 0.65, blue: 0.20), eye: .init(red: 0.80, green: 0.60, blue: 0.15)),
        ]
        return palettes[min(variant, 2)]
    case .clownfish:
        let palettes: [PetPalette] = [
            PetPalette(primary: .init(red: 0.95, green: 0.55, blue: 0.15), secondary: .init(red: 0.98, green: 0.98, blue: 0.98), accent: .init(red: 0.95, green: 0.80, blue: 0.30), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
            PetPalette(primary: .init(red: 0.85, green: 0.25, blue: 0.20), secondary: .init(red: 0.98, green: 0.98, blue: 0.98), accent: .init(red: 0.95, green: 0.80, blue: 0.30), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
        ]
        return palettes[min(variant, 1)]
    case .otter:
        let palettes: [PetPalette] = [
            PetPalette(primary: .init(red: 0.45, green: 0.32, blue: 0.22), secondary: .init(red: 0.80, green: 0.72, blue: 0.62), accent: .init(red: 0.30, green: 0.20, blue: 0.15), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
            PetPalette(primary: .init(red: 0.28, green: 0.22, blue: 0.18), secondary: .init(red: 0.65, green: 0.58, blue: 0.50), accent: .init(red: 0.20, green: 0.15, blue: 0.12), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
        ]
        return palettes[min(variant, 1)]
    case .squirrel:
        let palettes: [PetPalette] = [
            PetPalette(primary: .init(red: 0.65, green: 0.40, blue: 0.22), secondary: .init(red: 0.90, green: 0.82, blue: 0.70), accent: .init(red: 0.95, green: 0.65, blue: 0.68), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
            PetPalette(primary: .init(red: 0.50, green: 0.50, blue: 0.55), secondary: .init(red: 0.82, green: 0.82, blue: 0.85), accent: .init(red: 0.85, green: 0.60, blue: 0.62), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
            PetPalette(primary: .init(red: 0.75, green: 0.35, blue: 0.20), secondary: .init(red: 0.92, green: 0.78, blue: 0.65), accent: .init(red: 0.95, green: 0.65, blue: 0.68), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
        ]
        return palettes[min(variant, 2)]
    case .polarBear:
        let palettes: [PetPalette] = [
            PetPalette(primary: .init(red: 0.95, green: 0.95, blue: 0.97), secondary: .init(red: 0.98, green: 0.98, blue: 1.0), accent: .init(red: 0.20, green: 0.20, blue: 0.22), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
            PetPalette(primary: .init(red: 0.95, green: 0.92, blue: 0.85), secondary: .init(red: 0.98, green: 0.96, blue: 0.92), accent: .init(red: 0.20, green: 0.20, blue: 0.22), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
        ]
        return palettes[min(variant, 1)]
    case .frog:
        let palettes: [PetPalette] = [
            PetPalette(primary: .init(red: 0.35, green: 0.72, blue: 0.35), secondary: .init(red: 0.70, green: 0.90, blue: 0.65), accent: .init(red: 0.90, green: 0.30, blue: 0.30), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
            PetPalette(primary: .init(red: 0.30, green: 0.55, blue: 0.85), secondary: .init(red: 0.60, green: 0.78, blue: 0.95), accent: .init(red: 0.90, green: 0.75, blue: 0.20), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
            PetPalette(primary: .init(red: 0.85, green: 0.30, blue: 0.25), secondary: .init(red: 0.95, green: 0.55, blue: 0.45), accent: .init(red: 0.20, green: 0.35, blue: 0.80), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
        ]
        return palettes[min(variant, 2)]
    case .panda:
        let palettes: [PetPalette] = [
            PetPalette(primary: .init(red: 0.12, green: 0.12, blue: 0.15), secondary: .init(red: 0.95, green: 0.95, blue: 0.97), accent: .init(red: 0.15, green: 0.15, blue: 0.18), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
            PetPalette(primary: .init(red: 0.60, green: 0.30, blue: 0.15), secondary: .init(red: 0.90, green: 0.75, blue: 0.60), accent: .init(red: 0.40, green: 0.20, blue: 0.12), eye: .init(red: 0.15, green: 0.15, blue: 0.18)),
        ]
        return palettes[min(variant, 1)]
    }
}

// MARK: - Sprite Lookup

// MARK: - New Animals: Baby sprites (7x6~7)

let hamsterBaby = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,1,1,1,1,1,0],[1,3,1,1,1,3,1],[1,4,1,2,1,4,1],[1,1,3,3,3,1,1],[0,1,2,2,2,1,0],[0,0,1,0,1,0,0]]),
    frame2: SpriteFrame(pixels: [[0,1,1,1,1,1,0],[1,3,1,1,1,3,1],[1,4,1,2,1,4,1],[1,1,3,3,3,1,1],[0,1,2,2,2,1,0],[0,1,0,0,0,1,0]])
)
let hamsterAdult = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,0,0,0,0,0,0,1,1,1,1,1],[0,0,0,0,0,0,1,3,1,1,3,1],[0,0,0,0,0,0,1,4,1,1,4,1],[1,0,0,0,0,0,1,1,3,3,1,1],[0,1,1,1,1,1,1,2,2,2,2,1],[0,0,1,1,2,2,2,2,2,2,1,0],[0,0,0,1,1,1,1,1,1,1,0,0],[0,0,0,0,1,0,0,0,1,0,0,0]]),
    frame2: SpriteFrame(pixels: [[0,0,0,0,0,0,0,1,1,1,1,1],[0,0,0,0,0,0,1,3,1,1,3,1],[0,0,0,0,0,0,1,4,1,1,4,1],[0,0,0,0,0,0,1,1,3,3,1,1],[0,1,1,1,1,1,1,2,2,2,2,1],[1,0,1,1,2,2,2,2,2,2,1,0],[0,0,0,1,1,1,1,1,1,1,0,0],[0,0,0,0,1,0,0,0,1,0,0,0]])
)

let capybaraBaby = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,1,1,1,1,1,0],[1,1,1,1,1,1,1],[1,4,1,1,1,4,1],[1,1,1,3,1,1,1],[0,1,1,1,1,1,0],[0,0,1,0,1,0,0]]),
    frame2: SpriteFrame(pixels: [[0,1,1,1,1,1,0],[1,1,1,1,1,1,1],[1,4,1,1,1,4,1],[1,1,1,3,1,1,1],[0,1,1,1,1,1,0],[0,1,0,0,0,1,0]])
)
let capybaraAdult = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,0,0,0,0,0,0,0,1,1,1,1],[0,0,0,0,0,0,0,1,1,1,1,1],[0,0,0,0,0,0,0,1,4,1,4,1],[0,0,0,0,0,0,0,1,1,3,1,1],[0,0,0,1,1,1,1,1,1,1,1,1],[0,0,0,1,1,1,1,1,1,1,1,0],[0,0,0,1,2,1,0,0,1,2,1,0],[0,0,0,0,1,0,0,0,0,1,0,0]]),
    frame2: SpriteFrame(pixels: [[0,0,0,0,0,0,0,0,1,1,1,1],[0,0,0,0,0,0,0,1,1,1,1,1],[0,0,0,0,0,0,0,1,4,1,4,1],[0,0,0,0,0,0,0,1,1,3,1,1],[0,0,0,1,1,1,1,1,1,1,1,1],[0,0,0,1,1,1,1,1,1,1,1,0],[0,0,0,0,1,2,0,0,1,2,0,0],[0,0,0,0,0,1,0,0,0,1,0,0]])
)

let jellyfishBaby = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,0,1,1,1,0,0],[0,1,2,2,2,1,0],[1,4,2,2,2,4,1],[0,1,2,2,2,1,0],[0,0,1,0,1,0,0],[0,1,0,1,0,1,0]]),
    frame2: SpriteFrame(pixels: [[0,0,1,1,1,0,0],[0,1,2,2,2,1,0],[1,4,2,2,2,4,1],[0,1,2,2,2,1,0],[0,1,0,1,0,1,0],[0,0,1,0,1,0,0]])
)
let jellyfishAdult = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,0,0,0,1,1,1,1,1,0,0],[0,0,0,1,2,2,2,2,2,1,0],[0,0,1,2,4,2,2,4,2,2,1],[0,0,1,2,2,2,2,2,2,2,1],[0,0,0,1,2,2,2,2,2,1,0],[0,0,0,0,1,0,1,0,1,0,0],[0,0,0,1,0,1,0,1,0,1,0],[0,0,1,0,0,0,1,0,0,0,0]]),
    frame2: SpriteFrame(pixels: [[0,0,0,0,1,1,1,1,1,0,0],[0,0,0,1,2,2,2,2,2,1,0],[0,0,1,2,4,2,2,4,2,2,1],[0,0,1,2,2,2,2,2,2,2,1],[0,0,0,1,2,2,2,2,2,1,0],[0,0,0,1,0,1,0,1,0,0,0],[0,0,0,0,1,0,1,0,1,0,0],[0,0,0,0,0,1,0,0,0,1,0]])
)

let goldfishBaby = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,0,0,1,1,0,0],[0,0,1,1,1,1,0],[0,1,4,1,1,1,1],[0,0,1,1,1,3,0],[0,0,0,1,1,0,0],[0,0,1,0,0,1,0]]),
    frame2: SpriteFrame(pixels: [[0,0,0,1,1,0,0],[0,0,1,1,1,1,0],[0,1,4,1,1,1,1],[0,0,1,1,1,3,0],[0,0,0,1,1,0,0],[0,1,0,0,0,0,1]])
)
let goldfishAdult = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,0,0,0,0,1,1,0,0,0,0],[0,0,0,0,1,1,1,1,0,0,0],[3,3,0,1,1,1,1,1,1,0,0],[0,3,1,4,1,1,1,1,1,3,0],[0,0,0,1,1,1,1,1,1,0,0],[0,0,0,0,1,1,1,1,0,0,0],[0,0,0,0,0,1,1,0,0,0,0],[0,0,0,0,0,0,3,3,0,0,0]]),
    frame2: SpriteFrame(pixels: [[0,0,0,0,0,1,1,0,0,0,0],[0,0,0,0,1,1,1,1,0,0,0],[0,3,0,1,1,1,1,1,1,0,0],[3,3,1,4,1,1,1,1,1,3,0],[0,0,0,1,1,1,1,1,1,0,0],[0,0,0,0,1,1,1,1,0,0,0],[0,0,0,0,0,1,1,0,0,0,0],[0,0,0,0,3,3,0,0,0,0,0]])
)

let clownfishBaby = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,0,1,1,1,0,0],[0,1,2,1,2,1,0],[1,4,1,2,1,2,1],[0,1,2,1,2,1,0],[0,0,1,1,1,0,0],[0,0,0,3,0,0,0]]),
    frame2: SpriteFrame(pixels: [[0,0,1,1,1,0,0],[0,1,2,1,2,1,0],[1,4,1,2,1,2,1],[0,1,2,1,2,1,0],[0,0,1,1,1,0,0],[0,0,3,0,0,0,0]])
)
let clownfishAdult = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,0,0,0,1,1,1,0,0,0],[0,0,0,1,2,1,2,1,0,0],[3,0,1,1,2,1,2,1,1,0],[0,1,4,1,2,1,2,1,1,3],[0,0,1,1,2,1,2,1,1,0],[0,0,0,1,2,1,2,1,0,0],[0,0,0,0,1,1,1,0,0,0],[0,0,0,0,0,3,0,0,0,0]]),
    frame2: SpriteFrame(pixels: [[0,0,0,0,1,1,1,0,0,0],[0,0,0,1,2,1,2,1,0,0],[0,0,1,1,2,1,2,1,1,0],[3,1,4,1,2,1,2,1,1,3],[0,0,1,1,2,1,2,1,1,0],[0,0,0,1,2,1,2,1,0,0],[0,0,0,0,1,1,1,0,0,0],[0,0,0,0,3,0,0,0,0,0]])
)

let otterBaby = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,1,0,0,0,1,0],[1,1,1,1,1,1,1],[1,4,2,2,2,4,1],[1,1,1,3,1,1,1],[0,1,2,2,2,1,0],[0,0,1,0,1,0,0]]),
    frame2: SpriteFrame(pixels: [[0,1,0,0,0,1,0],[1,1,1,1,1,1,1],[1,4,2,2,2,4,1],[1,1,1,3,1,1,1],[0,1,2,2,2,1,0],[0,1,0,0,0,1,0]])
)
let otterAdult = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,0,0,0,0,0,0,1,0,0,0,1],[0,0,0,0,0,0,1,1,1,1,1,1,1],[1,0,0,0,0,0,1,4,2,2,2,4,1],[0,1,0,0,0,0,1,1,1,3,1,1,1],[0,0,1,1,1,1,1,1,2,2,2,1,0],[0,0,0,1,2,2,2,1,1,1,1,0,0],[0,0,0,0,1,1,0,0,1,1,0,0,0],[0,0,0,0,0,1,0,0,0,1,0,0,0]]),
    frame2: SpriteFrame(pixels: [[0,0,0,0,0,0,0,1,0,0,0,1],[0,0,0,0,0,0,1,1,1,1,1,1,1],[0,0,0,0,0,0,1,4,2,2,2,4,1],[0,0,0,0,0,0,1,1,1,3,1,1,1],[0,0,1,1,1,1,1,1,2,2,2,1,0],[1,0,0,1,2,2,2,1,1,1,1,0,0],[0,1,0,0,1,1,0,0,1,1,0,0,0],[0,0,0,0,0,1,0,0,0,1,0,0,0]])
)

let squirrelBaby = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,1,0,0,0,1,0],[1,3,1,1,1,3,1],[1,4,1,2,1,4,1],[1,1,1,1,1,1,1],[0,1,1,1,1,1,0],[0,0,1,0,1,0,0]]),
    frame2: SpriteFrame(pixels: [[0,1,0,0,0,1,0],[1,3,1,1,1,3,1],[1,4,1,2,1,4,1],[1,1,1,1,1,1,1],[0,1,1,1,1,1,0],[0,1,0,0,0,1,0]])
)
let squirrelAdult = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,0,0,0,0,0,0,0,1,0,1],[1,1,0,0,0,0,0,1,3,1,3,1],[0,1,1,0,0,0,0,1,4,1,4,1],[0,0,1,0,0,0,0,1,1,1,1,1],[0,0,0,1,1,1,1,1,1,1,1,1],[0,0,0,1,2,2,2,1,1,1,0,0],[0,0,0,0,1,1,0,0,1,0,0,0],[0,0,0,0,0,1,0,0,0,1,0,0]]),
    frame2: SpriteFrame(pixels: [[0,0,0,0,0,0,0,0,1,0,1],[0,1,0,0,0,0,0,1,3,1,3,1],[1,1,0,0,0,0,0,1,4,1,4,1],[0,0,1,0,0,0,0,1,1,1,1,1],[0,0,0,1,1,1,1,1,1,1,1,1],[0,0,0,1,2,2,2,1,1,1,0,0],[0,0,0,0,1,1,0,0,1,0,0,0],[0,0,0,0,0,1,0,0,0,1,0,0]])
)

let polarBearBaby = SpriteSet(
    frame1: SpriteFrame(pixels: [[1,1,0,0,0,1,1],[1,1,1,1,1,1,1],[1,4,1,1,1,4,1],[1,1,1,3,1,1,1],[0,1,1,1,1,1,0],[0,0,1,0,1,0,0]]),
    frame2: SpriteFrame(pixels: [[1,1,0,0,0,1,1],[1,1,1,1,1,1,1],[1,4,1,1,1,4,1],[1,1,1,3,1,1,1],[0,1,1,1,1,1,0],[0,1,0,0,0,1,0]])
)
let polarBearAdult = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,0,0,0,0,0,0,1,1,0,0,1,1],[0,0,0,0,0,0,0,1,1,1,1,1,1],[0,0,0,0,0,0,1,4,1,1,1,4,1],[0,0,0,0,0,0,1,1,1,3,1,1,1],[0,0,1,1,1,1,1,1,1,1,1,1,1],[0,0,1,1,1,1,1,1,1,1,1,1,0],[0,0,0,1,1,1,0,0,1,1,1,0,0],[0,0,0,0,1,0,0,0,0,1,0,0,0]]),
    frame2: SpriteFrame(pixels: [[0,0,0,0,0,0,0,1,1,0,0,1,1],[0,0,0,0,0,0,0,1,1,1,1,1,1],[0,0,0,0,0,0,1,4,1,1,1,4,1],[0,0,0,0,0,0,1,1,1,3,1,1,1],[0,0,1,1,1,1,1,1,1,1,1,1,1],[0,0,1,1,1,1,1,1,1,1,1,1,0],[0,0,0,0,1,1,0,0,1,1,0,0,0],[0,0,0,0,1,0,0,0,0,1,0,0,0]])
)

let frogBaby = SpriteSet(
    frame1: SpriteFrame(pixels: [[4,0,0,0,0,0,4],[1,1,1,1,1,1,1],[1,1,1,1,1,1,1],[0,1,1,3,1,1,0],[0,0,1,1,1,0,0],[0,1,0,0,0,1,0]]),
    frame2: SpriteFrame(pixels: [[4,0,0,0,0,0,4],[1,1,1,1,1,1,1],[1,1,1,1,1,1,1],[0,1,1,3,1,1,0],[0,0,1,1,1,0,0],[0,0,1,0,1,0,0]])
)
let frogAdult = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,0,0,0,0,0,4,0,0,0,0,4],[0,0,0,0,0,1,1,1,1,1,1,1],[0,0,0,0,0,1,1,1,1,1,1,1],[0,0,0,0,0,1,1,1,3,1,1,1],[0,0,1,1,1,1,1,1,1,1,1,0],[0,0,1,2,2,1,1,1,1,1,0,0],[0,0,0,1,1,0,0,1,1,0,0,0],[0,0,1,1,0,0,0,0,1,1,0,0]]),
    frame2: SpriteFrame(pixels: [[0,0,0,0,0,0,4,0,0,0,0,4],[0,0,0,0,0,1,1,1,1,1,1,1],[0,0,0,0,0,1,1,1,1,1,1,1],[0,0,0,0,0,1,1,1,3,1,1,1],[0,0,1,1,1,1,1,1,1,1,1,0],[0,0,1,2,2,1,1,1,1,1,0,0],[0,0,1,1,0,0,0,1,1,0,0,0],[0,0,0,1,1,0,0,0,0,1,1,0]])
)

let pandaBaby = SpriteSet(
    frame1: SpriteFrame(pixels: [[1,1,0,0,0,1,1],[1,1,1,2,1,1,1],[1,4,2,2,2,4,1],[2,2,2,3,2,2,2],[0,2,2,2,2,2,0],[0,0,1,0,1,0,0]]),
    frame2: SpriteFrame(pixels: [[1,1,0,0,0,1,1],[1,1,1,2,1,1,1],[1,4,2,2,2,4,1],[2,2,2,3,2,2,2],[0,2,2,2,2,2,0],[0,1,0,0,0,1,0]])
)
let pandaAdult = SpriteSet(
    frame1: SpriteFrame(pixels: [[0,0,0,0,0,0,0,1,1,0,0,1,1],[0,0,0,0,0,0,0,1,1,2,2,1,1],[0,0,0,0,0,0,2,1,4,2,2,4,1],[0,0,0,0,0,0,2,2,2,3,2,2,2],[0,0,1,1,1,2,2,2,2,2,2,2,0],[0,0,1,1,2,2,2,2,2,2,2,0,0],[0,0,0,1,1,1,0,0,1,1,0,0,0],[0,0,0,0,1,0,0,0,0,1,0,0,0]]),
    frame2: SpriteFrame(pixels: [[0,0,0,0,0,0,0,1,1,0,0,1,1],[0,0,0,0,0,0,0,1,1,2,2,1,1],[0,0,0,0,0,0,2,1,4,2,2,4,1],[0,0,0,0,0,0,2,2,2,3,2,2,2],[0,0,1,1,1,2,2,2,2,2,2,2,0],[0,0,1,1,2,2,2,2,2,2,2,0,0],[0,0,0,0,1,1,0,0,1,1,0,0,0],[0,0,0,0,1,0,0,0,0,1,0,0,0]])
)

// MARK: - Accessory Overlays (rendered on top of adult sprite)
// Uses separate color: 0=skip(transparent), 5=gold, 6=white, 7=pink, 8=red

struct AccessoryData {
    let pixels: [[Int]]
    let offsetY: Int // negative = above head
    let colors: [Int: Color]
}

let accessoryGold = Color(red: 0.95, green: 0.80, blue: 0.25)
let accessoryWhite = Color(red: 0.98, green: 0.98, blue: 1.0)
let accessoryPink = Color(red: 0.95, green: 0.60, blue: 0.70)
let accessoryRed = Color(red: 0.90, green: 0.30, blue: 0.30)
let accessoryGreen = Color(red: 0.45, green: 0.80, blue: 0.45)
let accessoryBlue = Color(red: 0.55, green: 0.70, blue: 0.95)

let accessorySprites: [PetAccessory: AccessoryData] = [
    .crown: AccessoryData(
        pixels: [[0,5,0,5,0],[5,5,5,5,5],[0,5,5,5,0]],
        offsetY: -3,
        colors: [5: accessoryGold]
    ),
    .wings: AccessoryData(
        pixels: [[6,0,0,0,0,0,6],[6,6,0,0,0,6,6],[0,6,0,0,0,6,0]],
        offsetY: 1,
        colors: [6: accessoryWhite]
    ),
    .ribbon: AccessoryData(
        pixels: [[7,0,7],[0,7,0]],
        offsetY: -2,
        colors: [7: accessoryPink]
    ),
    .scarf: AccessoryData(
        pixels: [[8,8,8,8,8,8],[0,0,0,0,8,8],[0,0,0,0,0,8]],
        offsetY: 3,
        colors: [8: accessoryRed]
    ),
    .halo: AccessoryData(
        pixels: [[0,5,5,5,0],[5,0,0,0,5],[0,5,5,5,0]],
        offsetY: -3,
        colors: [5: accessoryGold]
    ),
    .flowerCrown: AccessoryData(
        pixels: [[7,0,8,0,7],[0,7,0,8,0]],
        offsetY: -2,
        colors: [7: accessoryPink, 8: accessoryRed]
    ),
]

// MARK: - Sprite Lookup

func spriteFor(species: PetSpecies, stage: PetStage) -> SpriteSet {
    if stage == .egg { return eggSprite }

    switch species {
    case .cat: return stage == .baby ? catBaby : catAdult
    case .shiba: return stage == .baby ? shibaBaby : shibaAdult
    case .rabbit: return stage == .baby ? rabbitBaby : rabbitAdult
    case .fox: return stage == .baby ? foxBaby : foxAdult
    case .raccoon: return stage == .baby ? raccoonBaby : raccoonAdult
    case .penguin: return stage == .baby ? penguinBaby : penguinAdult
    case .hamster: return stage == .baby ? hamsterBaby : hamsterAdult
    case .capybara: return stage == .baby ? capybaraBaby : capybaraAdult
    case .jellyfish: return stage == .baby ? jellyfishBaby : jellyfishAdult
    case .goldfish: return stage == .baby ? goldfishBaby : goldfishAdult
    case .clownfish: return stage == .baby ? clownfishBaby : clownfishAdult
    case .otter: return stage == .baby ? otterBaby : otterAdult
    case .squirrel: return stage == .baby ? squirrelBaby : squirrelAdult
    case .polarBear: return stage == .baby ? polarBearBaby : polarBearAdult
    case .frog: return stage == .baby ? frogBaby : frogAdult
    case .panda: return stage == .baby ? pandaBaby : pandaAdult
    }
}
