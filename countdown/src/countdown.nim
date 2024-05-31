import std/[cmdline, os, strformat, strutils, times]
import constants
import colors
import time
import terminal
import commonTypes
import glyphs

proc renderDigits(timeString: string) =
  drawGlyphs(Pos.new(2, 14), Shady, timeString)

proc displayMessage(message: string) =
  # Move cursor to the beginning of the line and erase the current line
  const font = Shady
  const fontHeight = getFontHeight(font)
  let lines = message.split("\n")
  for i, line in lines:
    drawGlyphs(Pos(x: 0, y: i * (fontHeight + 1)), font, line)

proc displaySubMessage(pos: Pos,message: string) =
  # Move cursor to the beginning of the line and erase the current line
  const font = Tmplr
  const fontHeight = getFontHeight(font)
  let lines = message.split("\n")
  for i, line in lines:
    drawGlyphs(Pos(x: pos.x, y: pos.y + (i * (fontHeight + 1))), font, line)


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

proc runProgram() =
  hideCursor()
  defer: showCursor()

  render()

  while countdownTime > elapsedTime:
    let (minutes, seconds) = calcTime(startTime, countdownTime)

    # Color selection
    colorIndex = (colorIndex + 1) mod len(palette)
    let bgColor = palette[(colorIndex+(len(palette) div 2)) mod len(palette)]
    setBColor(bgColor)
    drawFilledRect(Pos(x: 15, y: 5), Pos(x: 80, y: 24))

    let textColor = palette[colorIndex]
    transparentBColor()
    setFColor(textColor)
    displayMessage message
    renderDigits fmt"{minutes:02}:{seconds:02}"
    displaySubMessage(Pos(x: 0, y: 24), fmt"Or he won't be in {minutes:02}:{seconds:02}...")
    
    render()
    sleep 1000


  # stdout.eraseScreen()
  # stdout.setCursorPos 0, 3
  # stdout.styledWriteLine "Ben is supposed to be back NOW!"
  # stdout.setCursorPos 0, 10

runProgram()