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

const colors = { "blue": "\x1b[38;2;94;129;172m", "green": "\x1b[38;2;163;190;140m", "purple": "\x1b[38;2;180;142;173m", "orange": "\x1b[38;2;235;203;139m", "red": "\x1b[38;2;191;97;106m", "white": "\x1b[38;2;236;239;244m"}.toTable

const digits = { '0': digit0, '1': digit1, '2': digit2, '3': digit3, '4': digit4, '5': digit5, '6': digit6, '7': digit7, '8': digit8, '9': digit9, ':': digitColon }.toTable

stdout.hideCursor()
proc displayDigits(text: string, line: int): string =
  for digit in text:
    result &= "  "
    result &= digits[digit][line]

let params = commandLineParams()
let requestedMinutes = if params.len > 0: params[0].parseInt() else: 5

const message = colors["blue"] & "Ben will be back in:"
let startTime = now()
let countdownTime = initDuration(seconds = requestedMinutes * 60)
var elapsedTime = initDuration()


proc displayMessage(message: string, minutes: int, seconds: int) =
  # Move cursor to the beginning of the line and erase the current line
  stdout.setCursorPos 0, 0
  stdout.styledWriteLine message

  for line in 0..4:
    stdout.setCursorPos 0, line + 2
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
