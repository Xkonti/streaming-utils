import std/[cmdline, os, strformat, strutils, tables, times, terminal, unicode]
import buffer
import constants
import colors
import time

const timeWidth = (4 * digitWidth) + colonWidth + (4 * digitSpacing)
var buf = Buffer2D[timeWidth, digitHegiht, Rune]()
const message = hexColorToEscapeCode("#FFD921") & msgStream
const characterDelay = 50


proc renderDigits(timeString: string, buf: var Buffer2D[timeWidth, digitHegiht, Rune]) =
  var i = 0
  for line in 0..<digitHegiht:
    for digit in timeString:
      if i mod timeWidth != 0:
        for _ in 0..<digitSpacing:
          buf.set(i, Rune ' ')
          inc i
      let segment = digits[digit][line].toRunes()
      for rune in segment:
        buf.set(i, rune)
        inc i


proc displayMessage(message: string) =
  # Move cursor to the beginning of the line and erase the current line
  stdout.setCursorPos 0, 0
  stdout.styledWriteLine message


# START PROGRAM

stdout.hideCursor()

let params = commandLineParams()
let requestedMinutes = if params.len > 0: params[0].parseInt() else: 5

let startTime = now()
let countdownTime = initDuration(seconds = requestedMinutes * 60)
var elapsedTime = initDuration()

stdout.eraseScreen()
displayMessage message
var colorIndex = -1

while countdownTime > elapsedTime:
  let (minutes, seconds) = calcTime(startTime, countdownTime)

  # Color selection
  colorIndex = (colorIndex + 1) mod len(palette)
  let color = palette[colorIndex]

  var newBuf = buf
  renderDigits fmt"{minutes:02}:{seconds:02}", newBuf
  let diff = buf.diff(newBuf)
  buf = newBuf

  var timeElapsed = 0

  const xOffset = 6
  const yOffset = 12

  for (x, y, rune) in diff:
    let posX = x + xOffset
    let posY = y + yOffset
    stdout.setCursorPos posX, posY
    stdout.styledWriteLine color & $rune
    timeElapsed += characterDelay
    sleep characterDelay

  sleep 250 - timeElapsed


stdout.eraseScreen()
stdout.setCursorPos 0, 3
stdout.styledWriteLine "Ben is supposed to be back NOW!"
stdout.setCursorPos 0, 10