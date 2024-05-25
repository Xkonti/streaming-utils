import std/[colors, os, terminal, unicode]
import buffer

var size: tuple[w: int, h: int] = (0, 0)
var buf: Buffer2D
var diff: DiffSeq = @[]

var currentFColor: Color
var currentBColor: Color
var currentStyle: Style = styleBright
var currentPixelFlags: PixelFlags = {}
var previousPixel = Pixel()

# Initialization code

size = terminalSize()
buf = initBuffer2D(size.w, size.h)
stdout.eraseScreen()
stdout.resetAttributes()

proc resetFColor*() {.inline.} =
  currentPixelFlags.excl HasFgColor

proc setFColor*(color: Color) {.inline.} =
  currentFColor = color
  currentPixelFlags.incl HasFgColor

proc resetBColor*() {.inline.} =
  currentPixelFlags.excl HasBgColor

proc setBColor*(color: Color) {.inline.} =
  currentBColor = color
  currentPixelFlags.incl HasBgColor

proc resetStyle*() {.inline.} =
  currentPixelFlags.excl HasStyle

proc setStyle*(style: Style) {.inline.} =
  currentStyle = style
  currentPixelFlags.incl HasStyle

proc write*(x, y: int, text: string) =
  let runes = text.toRunes()
  for iX, r in runes:
    let pixel = Pixel(fc: currentFColor, bc: currentBColor, style: currentStyle, rune: r, flags: currentPixelFlags)
    buf.set(x + iX, y, pixel, diff)

proc write*(x, y: int, strings: varargs[string, `$`]) =
  var iX = 0
  for s in strings:
    let runes = s.toRunes()
    for r in runes:
      let pixel = Pixel(fc: currentFColor, bc: currentBColor, style: currentStyle, rune: r, flags: currentPixelFlags)
      buf.set(x + iX, y, pixel, diff)
      inc iX

proc drawGlyph*(x, y: int, glyph: openArray[string]) =
  for iY, line in glyph:
    let runes = line.toRunes()
    for iX, r in runes:
      let pixel = Pixel(
        fc: currentFColor,
        bc: currentBColor,
        style: currentStyle,
        rune: r,
        flags: currentPixelFlags)
      buf.set(x + iX, y + iY, pixel, diff)



proc render*() =
  let diffCopy = diff
  diff = @[]

  for (x, y, pixel) in diffCopy:
    let posX = x
    let posY = y
    stdout.setCursorPos posX, posY

    # Does need a reset?
    var reset = false
    if (HasBgColor in previousPixel.flags and HasBgColor notin pixel.flags) or
      (HasFgColor in previousPixel.flags and HasFgColor notin pixel.flags) or
      (HasStyle in previousPixel.flags and HasStyle notin pixel.flags):
      stdout.resetAttributes()
      reset = true
      write(0, 0, "Resetting at ", posX, ", ", posY)

    # Write bg color
    if HasBgColor in pixel.flags and (reset or previousPixel.bc != pixel.bc):
      stdout.write ansiBackgroundColorCode(pixel.bc)
    
    # Write fg color
    if HasFgColor in pixel.flags and (reset or previousPixel.fc != pixel.fc):
      stdout.write ansiForegroundColorCode(pixel.fc)

    # Write style
    if HasStyle in pixel.flags and (reset or previousPixel.style != pixel.style):
      stdout.write ansiStyleCode(pixel.style)

    # Write rune
    stdout.write pixel.rune
    previousPixel = pixel

  stdout.flushFile()