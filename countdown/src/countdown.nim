import std/[cmdline, os, strformat, strutils, tables, times, terminal]

const digit0 = [
 " ██████ ",
 "██  ████",
 "██ ██ ██",
 "████  ██",
 " ██████ "
]

const digit1 = [
 " ██",
 "███",
 " ██",
 " ██",
 " ██"
]

const digit2 = [
  "██████ ",
  "     ██",
  " █████ ",
  "██     ",
  "███████"
]

const digit3 = [
  "██████ ",
  "     ██",
  " █████ ",
  "     ██",
  "██████ "
]

const digit4 = [
  "██   ██",
  "██   ██",
  "███████",
  "     ██",
  "     ██"
]

const digit5 = [
  "███████",
  "██     ",
  "███████",
  "     ██",
  "███████"
]

const digit6 = [
  " ██████ ",
  "██      ",
  "███████ ",
  "██    ██",
  " ██████ "
]

const digit7 = [
  "███████",
  "     ██",
  "    ██ ",
  "   ██  ",
  "   ██  "
]

const digit8 = [
  " █████ ",
  "██   ██",
  " █████ ",
  "██   ██",
  " █████ "
]

const digit9 = [
  " █████ ",
  "██   ██",
  " ██████",
  "     ██",
  " █████ "
]

const digitColon = [
  "   ",
  "██ ",
  "   ",
  "██ ",
  "   "
]

# Ascii generator https://patorjk.com/software/taag/
const msgStream = """
███████ ████████ ██████  ███████  █████  ███    ███     ██     ██ ██ ██      ██          ██████  ███████ ███████ ██    ██ ███    ███ ███████     ██ ███    ██    
██         ██    ██   ██ ██      ██   ██ ████  ████     ██     ██ ██ ██      ██          ██   ██ ██      ██      ██    ██ ████  ████ ██          ██ ████   ██ ██ 
███████    ██    ██████  █████   ███████ ██ ████ ██     ██  █  ██ ██ ██      ██          ██████  █████   ███████ ██    ██ ██ ████ ██ █████       ██ ██ ██  ██    
     ██    ██    ██   ██ ██      ██   ██ ██  ██  ██     ██ ███ ██ ██ ██      ██          ██   ██ ██           ██ ██    ██ ██  ██  ██ ██          ██ ██  ██ ██ ██ 
███████    ██    ██   ██ ███████ ██   ██ ██      ██      ███ ███  ██ ███████ ███████     ██   ██ ███████ ███████  ██████  ██      ██ ███████     ██ ██   ████    """


const digits = { '0': digit0, '1': digit1, '2': digit2, '3': digit3, '4': digit4, '5': digit5, '6': digit6, '7': digit7, '8': digit8, '9': digit9, ':': digitColon }.toTable

const
  FG: string = "\e[38;2;"
  BG: string = "\e[48;2;"

proc hexColorToEscapeCode(hexStr: string, backGround: bool = false): string =
  let hex: uint = fromHex[uint](hexStr[1..<7])

  let r = hex.int shr 16 and 0xff
  let g = hex.int shr 8 and 0xff
  let b = hex.int and 0xff
  
  if backGround : result = BG
  else: result = FG

  result &= fmt"{r};{g};{b}m"

stdout.hideCursor()
proc displayDigits(text: string, line: int): string =
  for digit in text:
    result &= "  "
    result &= digits[digit][line]

let params = commandLineParams()
let requestedMinutes = if params.len > 0: params[0].parseInt() else: 5

const message = hexColorToEscapeCode("#FFD921") & msgStream
let startTime = now()
let countdownTime = initDuration(seconds = requestedMinutes * 60)
var elapsedTime = initDuration()


proc displayMessage(message: string, minutes: int, seconds: int) =
  # Move cursor to the beginning of the line and erase the current line
  stdout.setCursorPos 0, 0
  stdout.styledWriteLine message

  for line in 0..4:
    stdout.setCursorPos 0, line + 7
    stdout.styledWriteLine colors["purple"] & displayDigits(fmt"{minutes:02}:{seconds:02}", line)

while countdownTime > elapsedTime:
  sleep(1000)
  stdout.eraseScreen()
  let currentTime = now()
  elapsedTime = currentTime - startTime
  let timeLeft = countdownTime - elapsedTime
  let totalSeconds = timeLeft.inSeconds
  let minutes = totalSeconds div 60
  let seconds = totalSeconds mod 60
  displayMessage message, minutes, seconds

stdout.eraseScreen()
stdout.setCursorPos 0, 3
stdout.styledWriteLine "Ben is supposed to be back NOW!"
stdout.setCursorPos 0, 10
