import std/[colors, terminal, unicode]

type
  PixelFlag* = enum
    HasBgColor
    HasStyle
  PixelFlags* = set[PixelFlag]

  Pixel* = object
    fc*: Color
    bc*: Color
    style*: Style
    rune*: Rune
    flags*: PixelFlags

  Buffer2D* = object
    data*: seq[Pixel]
    w, h: int

  DiffEntry* = tuple[x: int, y: int, value: Pixel]
  DiffSeq* = seq[DiffEntry]

proc initBuffer2D*(width, height: int): Buffer2D {.inline.} =
  result = Buffer2D(w: width, h: height)
  result.data = newSeq[Pixel](width * height)

proc width*(self: Buffer2D): int =
  self.w

proc height*(self: Buffer2D): int =
  self.h

proc posToIndex*(self: Buffer2D, x, y: int): int {.inline.} =
  y * self.w + x

proc indexToPos*(self: Buffer2D, index: int): tuple[x: int, y: int] {.inline.} =
  (index mod self.w, index div self.w)

proc get*(self: Buffer2D, x, y: int): Pixel =
  self.data[self.posToIndex(x, y)]

proc set*(self: var Buffer2D, x, y: int, value: Pixel, diffSeq: var DiffSeq) =
  let index = self.posToIndex(x, y)
  let oldValue = self.data[index]

  # Detect changes
  var changed = false
  if oldValue.rune != value.rune:
    changed = true
  elif oldValue.fc != value.fc:
    changed = true
  elif (HasBgColor in value.flags) and oldValue.bc != value.bc:
    changed = true
  elif (HasStyle in oldValue.flags) and oldValue.style != value.style:
    changed = true

  if not changed: return

  # Backgorund
  if HasBgColor in value.flags:
    self.data[index].bc = value.bc

  # Foreground
  self.data[index].fc = value.fc
  self.data[index].rune = value.rune

  # Style
  if HasStyle in value.flags:
    self.data[index].flags.incl HasStyle
    self.data[index].style = value.style
  else:
    self.data[index].flags.excl HasStyle

  # Add to diff sequence
  diffSeq.add((x, y, self.data[index]))

proc get*(self: Buffer2D, index: int): Pixel =
  self.data[index]

proc set*(self: var Buffer2D, index: int, value: Pixel, diffSeq: var DiffSeq) =
  let oldValue = self.data[index]
  if oldValue != value:
    self.data[index] = value
    let (x, y) = self.indexToPos(index)
    diffSeq.add((x, y, value))