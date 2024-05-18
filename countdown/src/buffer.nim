type
  Buffer2D*[Width: static[int], Height: static[int], TCell] = object
    data*: array[Width*Height, TCell]

proc width*[Width: static[int], Height: static[int], TCell](self: Buffer2D[Width, Height, TCell]): int =
  Width

proc height*[Width: static[int], Height: static[int], TCell](self: Buffer2D[Width, Height, TCell]): int =
  Height

proc get*[Width: static[int], Height: static[int], TCell](self: Buffer2D[Width, Height, TCell], x, y: int): TCell =
  self.data[y * Width + x]

proc set*[Width: static[int], Height: static[int], TCell](self: var Buffer2D[Width, Height, TCell], x, y: int, value: TCell) =
  self.data[y * Width + x] = value


proc get*[Width: static[int], Height: static[int], TCell](self: Buffer2D[Width, Height, TCell], index: int): TCell =
  self.data[index]

proc set*[Width: static[int], Height: static[int], TCell](self: var Buffer2D[Width, Height, TCell], index: int, value: TCell) =
  self.data[index] = value

proc diff*[Width: static[int], Height: static[int], TCell](bufA: Buffer2D[Width, Height, TCell], bufB: Buffer2D[Width, Height, TCell]): seq[tuple[x: int, y: int, value: TCell]] =
  for y in 0..<bufA.height:
    for x in 0..<bufA.width:
      let i = y * bufA.width + x
      if bufA.data[i] != bufB.data[i]:
        result.add((x, y, bufB.data[i]))