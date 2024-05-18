import std/[strformat, strutils]

const
  FG: string = "\e[38;2;"
  BG: string = "\e[48;2;"

proc hexColorToEscapeCode*(hexStr: string, backGround: bool = false): string =
  let hex: uint = fromHex[uint](hexStr[1..<7])

  let r = hex.int shr 16 and 0xff
  let g = hex.int shr 8 and 0xff
  let b = hex.int and 0xff
  
  if backGround : result = BG
  else: result = FG

  result &= fmt"{r};{g};{b}m"


const palette* = @[
  hexColorToEscapeCode("#f93037"),
  hexColorToEscapeCode("#ff542f"),
  hexColorToEscapeCode("#ff7227"),
  hexColorToEscapeCode("#ff8c23"),
  hexColorToEscapeCode("#ffa525"),
  hexColorToEscapeCode("#ffbc2e"),
  hexColorToEscapeCode("#ffd33e"),
  hexColorToEscapeCode("#ffe953"),
  hexColorToEscapeCode("#ffd33e"),
  hexColorToEscapeCode("#ffbc2e"),
  hexColorToEscapeCode("#ffa525"),
  hexColorToEscapeCode("#ff8c23"),
  hexColorToEscapeCode("#ff7227"),
  hexColorToEscapeCode("#ff542f"),
]