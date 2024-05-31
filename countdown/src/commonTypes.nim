type
  Pos* = object
    x*, y*: int

proc zero* (_: typedesc[Pos]): Pos =
  Pos(x: 0, y: 0)

proc new* (_: typedesc[Pos], x, y: int): Pos =
  Pos(x: x, y: y)

proc `-`*(a, b: Pos): Pos =
  Pos(x: a.x - b.x, y: a.y - b.y)

proc `+`*(a, b: Pos): Pos =
  Pos(x: a.x + b.x, y: a.y + b.y)

proc clamp*(self: Pos, size: tuple[w, h: int]): Pos =
  Pos(x: min(size.w, max(0, self.x)), y: min(size.h, max(0, self.y)))