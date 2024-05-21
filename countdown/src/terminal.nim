import std/[colors, os, terminal, unicode]
import buffer

var size: tuple[w: int, h: int] = (0, 0)
var buf: Buffer2D
var diff: DiffSeq = @[]

var currentFColor: string = ansiForegroundColorCode(colWhite)
var currentBColor: string = ansiBackgroundColorCode(colBlack)
var currentStyle: Style = styleBright

# Initialization code

size = terminalSize()
buf = initBuffer2D(size.w, size.h)
stdout.eraseScreen()

proc render*() =
  for (x, y, pixel) in diff:
    let posX = x
    let posY = y
    stdout.setCursorPos posX, posY
    stdout.styledWriteLine pixel.fc & pixel.bc & ansiStyleCode(pixel.style) & $pixel.rune
  stdout.flushFile()
  diff = @[]

proc setFColor*(color: Color) {.inline.} =
  currentFColor = ansiForegroundColorCode(color)

proc setBColor*(color: Color) {.inline.} =
  currentBColor = ansiBackgroundColorCode(color)

proc setStyle*(style: Style) {.inline.} =
  currentStyle = style

proc write(x, y: int, text: string) =
  let runes = text.toRunes()
  for iX, r in runes:
    let pixel = Pixel(fc: currentFColor, bc: currentBColor, style: currentStyle, rune: r)
    buf.set(x + iX, y, pixel, diff)

proc write(x, y: int, strings: varargs[string, `$`]) =
  var iX = 0
  for s in strings:
    let runes = s.toRunes()
    for r in runes:
      let pixel = Pixel(fc: currentFColor, bc: currentBColor, style: currentStyle, rune: r)
      buf.set(x + iX, y, pixel, diff)
      inc iX

proc drawGlyph*(x, y: int, glyph: openArray[string]) =
  for iY, line in glyph:
    let runes = line.toRunes()
    for iX, r in runes:
      let pixel = Pixel(fc: currentFColor, bc: currentBColor, style: currentStyle, rune: r)
      buf.set(x + iX, y + iY, pixel, diff)