import std/[colors, terminal, unicode]
import buffer
import commonTypes

var size: tuple[w: int, h: int] = (0, 0)
var buf: Buffer2D = initBuffer2D(0, 0)
var diff: DiffSeq = @[]

var currentFColor: Color
var currentBColor: Color
var currentStyle: Style = styleBright
var currentPixelFlags: PixelFlags = {}
var previousPixel = Pixel()

proc hideCursor*() =
  stdout.hideCursor()

proc showCursor*() =
  stdout.showCursor()

proc setFColor*(color: Color) {.inline.} =
  currentFColor = color

proc transparentBColor*() {.inline.} =
  currentPixelFlags.excl HasBgColor

proc setBColor*(color: Color) {.inline.} =
  currentBColor = color
  currentPixelFlags.incl HasBgColor

proc resetStyle*() {.inline.} =
  currentPixelFlags.excl HasStyle

proc setStyle*(style: Style) {.inline.} =
  currentStyle = style
  currentPixelFlags.incl HasStyle

proc applyBuffer*(pos: Pos, buffer: Buffer2D) =
  let maxX = min(size.w, buffer.width)
  let maxY = min(size.h, buffer.height)
  for y in 0 ..< maxY:
    for x in 0 ..< maxX:
      let pixel = buffer.get(x, y)
      buf.set(pos.x + x, pos.y + y, pixel, diff)

proc write*(pos: Pos, text: string) =
  let runes = text.toRunes()
  for iX, r in runes:
    let pixel = Pixel(fc: currentFColor, bc: currentBColor, style: currentStyle, rune: r, flags: currentPixelFlags)
    buf.set(pos.x + iX, pos.y, pixel, diff)

proc write*(pos: Pos, strings: varargs[string, `$`]) =
  var iX = 0
  for s in strings:
    let runes = s.toRunes()
    for r in runes:
      let pixel = Pixel(fc: currentFColor, bc: currentBColor, style: currentStyle, rune: r, flags: currentPixelFlags)
      buf.set(pos.x + iX, pos.y, pixel, diff)
      inc iX

proc drawFilledRect*(startPos, endPos: Pos) =
  for x in startPos.x .. endPos.x:
    for y in startPos.y .. endPos.y:
      let pixel = Pixel(fc: currentFColor, bc: currentBColor, style: currentStyle, rune: ' '.Rune, flags: currentPixelFlags)
      buf.set(x, y, pixel, diff)

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

proc updateTerminalSize*() =
  let newSize = terminalSize()
  if newSize == size: return

  # Set new size
  size = newSize

  # Init new buffer
  let oldBuf = buf
  buf = initBuffer2D(size.w, size.h)

  # Clear screen to black
  stdout.write ansiBackgroundColorCode(colBlack)
  stdout.eraseScreen()

  # Copy old buffer to new buffer
  applyBuffer(Pos.zero, oldBuf)

proc render*() =
  updateTerminalSize()

  let diffCopy = diff
  diff = @[]

  for (x, y, pixel) in diffCopy:
    let posX = x
    let posY = y
    stdout.setCursorPos posX, posY

    var reset = false
    if HasStyle in previousPixel.flags and HasStyle notin pixel.flags:
      stdout.resetAttributes()
      reset = true

    # Write bg color
    if reset or previousPixel.bc != pixel.bc:
      stdout.write ansiBackgroundColorCode(pixel.bc)
    
    # Write fg color
    if reset or previousPixel.fc != pixel.fc:
      stdout.write ansiForegroundColorCode(pixel.fc)

    # Write style
    if HasStyle in pixel.flags and (reset or previousPixel.style != pixel.style):
      stdout.write ansiStyleCode(pixel.style)

    # Write rune
    stdout.write pixel.rune
    previousPixel = pixel

  stdout.flushFile()


# Initialization code
# updateTerminalSize()
stdout.resetAttributes()