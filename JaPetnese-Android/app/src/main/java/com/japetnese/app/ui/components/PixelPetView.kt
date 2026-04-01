package com.japetnese.app.ui.components

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.size
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import com.japetnese.app.model.*
import kotlinx.coroutines.delay

data class PetPalette(
    val primary: Color,
    val secondary: Color,
    val accent: Color,
    val eye: Color
)

// Sprite data: 0=clear, 1=primary, 2=secondary, 3=accent, 4=eye
data class SpriteFrame(val pixels: List<List<Int>>)
data class SpriteSet(val frame1: SpriteFrame, val frame2: SpriteFrame)

@Composable
fun PixelPetView(
    pet: Pet,
    pixelSize: Float,
    animated: Boolean = false,
    modifier: Modifier = Modifier
) {
    val sprite = spriteFor(pet.species, pet.stage)
    val palette = paletteFor(pet.species, pet.rarity, pet.colorVariant)

    var frame by remember { mutableIntStateOf(0) }

    if (animated) {
        LaunchedEffect(Unit) {
            while (true) {
                delay(500)
                frame++
            }
        }
    }

    val current = if (animated && frame % 2 == 1) sprite.frame2 else sprite.frame1
    val maxCols = current.pixels.maxOf { it.size }
    val rows = current.pixels.size

    Canvas(
        modifier = modifier.size(
            width = (maxCols * pixelSize).dp,
            height = (rows * pixelSize).dp
        )
    ) {
        current.pixels.forEachIndexed { rowIdx, row ->
            row.forEachIndexed { colIdx, value ->
                if (value != 0) {
                    val color = when (value) {
                        1 -> palette.primary
                        2 -> palette.secondary
                        3 -> palette.accent
                        4 -> palette.eye
                        else -> Color.Transparent
                    }
                    drawRect(
                        color = color,
                        topLeft = Offset(colIdx * pixelSize.dp.toPx(), rowIdx * pixelSize.dp.toPx()),
                        size = Size(pixelSize.dp.toPx(), pixelSize.dp.toPx())
                    )
                }
            }
        }
    }
}

// Egg sprite (universal)
val eggSprite = SpriteSet(
    SpriteFrame(listOf(
        listOf(0,0,1,1,1,0,0), listOf(0,1,2,2,2,1,0), listOf(1,2,2,3,2,2,1),
        listOf(1,2,2,2,2,2,1), listOf(1,2,2,2,3,2,1), listOf(0,1,2,2,2,1,0), listOf(0,0,1,1,1,0,0)
    )),
    SpriteFrame(listOf(
        listOf(0,0,1,1,1,0,0), listOf(0,1,2,2,2,1,0), listOf(1,2,3,2,2,2,1),
        listOf(1,2,2,2,2,2,1), listOf(1,2,2,3,2,2,1), listOf(0,1,2,2,2,1,0), listOf(0,0,1,1,1,0,0)
    ))
)

// Cat sprites
val catBaby = SpriteSet(
    SpriteFrame(listOf(listOf(0,1,0,0,0,1,0),listOf(1,3,1,1,1,3,1),listOf(1,4,1,2,1,4,1),listOf(1,1,3,3,3,1,1),listOf(0,1,1,1,1,1,0),listOf(0,0,1,0,1,0,0))),
    SpriteFrame(listOf(listOf(0,1,0,0,0,1,0),listOf(1,3,1,1,1,3,1),listOf(1,1,1,2,1,1,1),listOf(1,1,3,3,3,1,1),listOf(0,1,1,1,1,1,0),listOf(0,1,0,0,0,1,0)))
)
val catAdult = SpriteSet(
    SpriteFrame(listOf(listOf(0,0,0,0,0,0,0,0,1,0,1),listOf(0,0,0,0,0,0,0,1,3,1,3,1),listOf(1,0,0,0,0,0,0,1,1,1,1,1),listOf(0,1,0,0,0,0,0,1,4,1,1,4,1),listOf(0,0,1,1,1,1,1,1,1,3,1,1,1),listOf(0,0,0,1,1,1,1,1,1,1,1,1,1),listOf(0,0,0,1,2,1,1,1,1,1,2,1,0),listOf(0,0,0,0,1,0,0,0,0,1,0,0,0))),
    SpriteFrame(listOf(listOf(0,0,0,0,0,0,0,0,1,0,1),listOf(0,0,0,0,0,0,0,1,3,1,3,1),listOf(0,0,0,0,0,0,0,1,1,1,1,1),listOf(0,0,0,0,0,0,0,1,4,1,1,4,1),listOf(0,0,0,1,1,1,1,1,1,3,1,1,1),listOf(0,0,0,1,1,1,1,1,1,1,1,1,1),listOf(1,0,0,1,2,1,1,1,1,1,2,1,0),listOf(0,1,0,0,1,0,0,0,0,1,0,0,0)))
)

fun spriteFor(species: PetSpecies, stage: PetStage): SpriteSet {
    if (stage == PetStage.EGG) return eggSprite
    // For simplicity, use cat sprites as default, baby for BABY, adult for JUVENILE/ADULT
    return when (stage) {
        PetStage.BABY -> catBaby
        else -> catAdult
    }
}

fun paletteFor(species: PetSpecies, rarity: PetRarity, variant: Int): PetPalette {
    if (rarity == PetRarity.LEGENDARY) {
        return PetPalette(
            Color(0xFFE6BF4D), Color(0xFFFAEB99), Color(0xFFF26673), Color(0xFF8C3399)
        )
    }
    return when (species) {
        PetSpecies.CAT -> if (variant == 0) PetPalette(Color(0xFF66666E), Color(0xFF99999F), Color(0xFFF2A7AD), Color(0xFF26262E))
            else PetPalette(Color(0xFF2E2E33), Color(0xFF595960), Color(0xFFF28C94), Color(0xFFD9BF33))
        PetSpecies.SHIBA -> PetPalette(Color(0xFFCC8C4D), Color(0xFFF2E6CC), Color(0xFFF2A7AD), Color(0xFF26262E))
        PetSpecies.RABBIT -> PetPalette(Color(0xFFEBE6E0), Color(0xFFFAF8F5), Color(0xFFF29AA6), Color(0xFFBF3340))
        PetSpecies.FOX -> PetPalette(Color(0xFFE68C33), Color(0xFFF2EBDA), Color(0xFFF2A7AD), Color(0xFF26262E))
        PetSpecies.PENGUIN -> PetPalette(Color(0xFF262E40), Color(0xFFF2F2F2), Color(0xFFF2B333), Color(0xFF26262E))
        PetSpecies.FROG -> PetPalette(Color(0xFF59B859), Color(0xFFB3E6A6), Color(0xFFE64D4D), Color(0xFF26262E))
        PetSpecies.PANDA -> PetPalette(Color(0xFF1F1F26), Color(0xFFF2F2F8), Color(0xFF26262E), Color(0xFF26262E))
        else -> PetPalette(Color(0xFF666670), Color(0xFFA6A6AD), Color(0xFFF2A7AD), Color(0xFF26262E))
    }
}
