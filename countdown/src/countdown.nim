import std/[cmdline, os, strformat, strutils, tables, times]
import constants
import colors
import time
import terminal

const message = msgStream


proc renderDigits(timeString: string) =
  var i = 0
  for digit in timeString:
    drawGlyph(i * 9, 12, digits[digit])
    inc i


# proc displayMessage(message: string) =
#   # Move cursor to the beginning of the line and erase the current line
#   stdout.setCursorPos 0, 0
#   stdout.styledWriteLine message


# START PROGRAM


let params = commandLineParams()
let requestedMinutes = if params.len > 0: params[0].parseInt() else: 5

let startTime = now()
let countdownTime = initDuration(seconds = requestedMinutes * 60)
var elapsedTime = initDuration()

# displayMessage message
var colorIndex = -1

while countdownTime > elapsedTime:
  let (minutes, seconds) = calcTime(startTime, countdownTime)

  # Color selection
  colorIndex = (colorIndex + 1) mod len(palette)
  let color = palette[colorIndex]
  setFColor(color)

  renderDigits fmt"{minutes:02}:{seconds:02}"

  # let characterDelay = 1000 div diff.len

  var timeElapsed = 0

  render()
  sleep 1000 - timeElapsed


# stdout.eraseScreen()
# stdout.setCursorPos 0, 3
# stdout.styledWriteLine "Ben is supposed to be back NOW!"
# stdout.setCursorPos 0, 10