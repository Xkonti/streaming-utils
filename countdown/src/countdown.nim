import std/[cmdline, os, strformat, strutils, tables, times]
import constants
import colors
import time
import terminal

proc renderDigits(timeString: string) =
  var i = 0
  for digit in timeString:
    drawGlyph(i * 9, 12, digits[digit])
    inc i


proc displayMessage(message: string) =
  # Move cursor to the beginning of the line and erase the current line
  let lines = message.split("\n")
  for i, line in lines:
    write(0, i, line)


# START PROGRAM


let params = commandLineParams()
let requestedMinutes = if params.len > 0: params[0].parseInt() else: 5
let message = if params.len > 1 and params[1] == "start":
    msgStreamStart
  else:
    msgStreamResume

let startTime = now()
let countdownTime = initDuration(seconds = requestedMinutes * 60)
var elapsedTime = initDuration()

var colorIndex = -1

while countdownTime > elapsedTime:
  let (minutes, seconds) = calcTime(startTime, countdownTime)

  # Color selection
  colorIndex = (colorIndex + 1) mod len(palette)
  let color = palette[colorIndex]
  setFColor(color)

  displayMessage message
  renderDigits fmt"{minutes:02}:{seconds:02}"
  
  render()
  sleep 1000


# stdout.eraseScreen()
# stdout.setCursorPos 0, 3
# stdout.styledWriteLine "Ben is supposed to be back NOW!"
# stdout.setCursorPos 0, 10