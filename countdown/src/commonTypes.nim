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