type
  Pos* = object
    x*, y*: int


proc `-`*(a, b: Pos): Pos =
  Pos(x: a.x - b.x, y: a.y - b.y)

proc `+`*(a, b: Pos): Pos =
  Pos(x: a.x + b.x, y: a.y + b.y)