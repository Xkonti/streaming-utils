type
  Buffer2D*[Width: static[int], Height: static[int], TCell] = object
    data*: array[Width*Height, TCell]

  DiffEntry*[TCell] = tuple[x: int, y: int, value: TCell]
  DiffSeq*[TCell] = seq[DiffEntry[TCell]]

proc width*[Width: static[int], Height: static[int], TCell](self: Buffer2D[Width, Height, TCell]): int =
  Width

proc height*[Width: static[int], Height: static[int], TCell](self: Buffer2D[Width, Height, TCell]): int =
  Height

proc posToIndex*[Width: static[int], Height: static[int], TCell](self: Buffer2D[Width, Height, TCell], x, y: int): int {.inline.} =
  y * Width + x

proc indexToPos*[Width: static[int], Height: static[int], TCell](self: Buffer2D[Width, Height, TCell], index: int): tuple[x: int, y: int] {.inline.} =
  (index mod Width, index div Width)

proc get*[Width: static[int], Height: static[int], TCell](self: Buffer2D[Width, Height, TCell], x, y: int): TCell =
  self.data[self.posToIndex(x, y)]

proc set*[Width: static[int], Height: static[int], TCell](self: var Buffer2D[Width, Height, TCell], x, y: int, value: TCell, diffSeq: var DiffSeq) =
  let index = self.posToIndex(x, y)
  let oldValue = self.data[index]
  if oldValue != value:
    self.data[index] = value
    diffSeq.add((x, y, value))

proc get*[Width: static[int], Height: static[int], TCell](self: Buffer2D[Width, Height, TCell], index: int): TCell =
  self.data[index]

proc set*[Width: static[int], Height: static[int], TCell](self: var Buffer2D[Width, Height, TCell], index: int, value: TCell, diffSeq: var DiffSeq) =
  let oldValue = self.data[index]
  if oldValue != value:
    self.data[index] = value
    let (x, y) = self.indexToPos(index)
    diffSeq.add((x, y, value))