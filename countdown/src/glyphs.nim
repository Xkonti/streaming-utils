import std/[strutils, sequtils, tables, unicode]
import commonTypes

type
  WriteableSegment* = object
    pos*: Pos
    text*: seq[Rune]

  Glyph* = object
    width*: int
    height*: int
    segments*: seq[WriteableSegment]

  LineSet = tuple[setRunes: seq[Rune], glyphLines: seq[seq[Rune]]]
  GlyphRange = tuple[start: int, length: int]

const space = ' '.Rune


proc processGlyph(lines: openArray[seq[Rune]], width: int): Glyph =
  ## Processes a glyph as as list of lines (string array)
  ## and produces a list of locations and strings.
  ## This allows it to be easily printed to the terminal
  ## and avoid applying background color to the pixels that
  ## are not part of the glyph.
  var segments: seq[WriteableSegment] = @[]

  var isSegment = false
  var currentSegment: WriteableSegment

  # Process each line
  for iY, runes in lines:
    # Process each rune
    for iX, r in runes:
      # If it's empty space end existing segment or skip
      if r == space:
        if isSegment:
          segments.add(currentSegment)
          isSegment = false
          currentSegment = WriteableSegment()
          continue
        else:
          continue
      
      # When there's a rune start new segment
      if not isSegment:
        currentSegment.pos = Pos.new(iX, iY)
        currentSegment.text = @[r]
        isSegment = true
      # Or add to existing one
      else:
        currentSegment.text.add(r)

    # Add last segment
    if isSegment:
      segments.add(currentSegment)
      isSegment = false
      currentSegment = WriteableSegment()

  return Glyph(width: width, height: lines.len, segments: segments)


proc splitGlyphLineSets*(text: string): seq[LineSet] =
  ## Split input into sets of lines, where each set starts with `<:>`
  var currentLineSet: LineSet = (@[], @[])
  for line in text.split("\n"):
    # Process first line
    if line.startsWith(">>>"):
      # If there's a previous set, add it to the list
      if currentLineSet.setRunes.len != 0:
        result.add(currentLineSet)
      # Start a new set with the runes from the first line
      let setRunes = line[3..^1].toRunes()
      currentLineSet = (setRunes, @[])
    else:
      # Add glyph line to current set
      currentLineSet.glyphLines.add(line.toRunes())

  # After all lines have been processed, add the last set
  if currentLineSet.setRunes.len > 0:
    result.add(currentLineSet)


proc selectGlyphs*(lineSet: LineSet): seq[GlyphRange] =
  ## Takes a line set and returns a list of x-ranges that can be used to
  ## select glyphs from the line set.

  # Calculate max line length
  var maxLineLength = lineSet.glyphLines[0].len
  for line in lineSet.glyphLines:
    maxLineLength = max(maxLineLength, line.len)

  # Scan all glyph lines from left to right together
  var currentGlyphRange: GlyphRange = (0, 0)
  for x in 0 ..< maxLineLength:
    # Check if all lines at this position are empty
    var allEmpty = true
    for glyphLine in lineSet.glyphLines:
      if glyphLine.len <= x: continue # assume lines are extended with empty spaces
      if glyphLine[x] == space: continue # skip empty spaces
      allEmpty = false
      break

    # If empty across all lines, add current glyph if present
    if allEmpty and currentGlyphRange.length > 0:
      result.add(currentGlyphRange)
      currentGlyphRange = (x, 0)

    # Advance glyph range
    if allEmpty:
      inc currentGlyphRange.start

    # If not all empty, add to current glyph range
    else:
      inc currentGlyphRange.length
    
  # Remember to add last glyph
  if currentGlyphRange.length > 0:
    result.add(currentGlyphRange)

  


proc processGlyphs*(text: string, spaceWidth: int): Table[Rune, Glyph] =
  ## Processes a string of thext that contains characters and glyphs
  ## into a list of available glyphs.
  
  # The input text is divided into sets of lines. Each set represents:
  # - A lined starting with `<:>` that contains a list of runes that
  #   will be in the following lines.
  # - A set of lines that contain the glyphs for the runes. There could
  #   be multiple lines for each rune.
  # Example:
  # >>>ABCD
  # /-\ |-\ /-\ |-\
  # |-| |-< |   | |
  # | | |_/ \-/ |_/
  #
  # Those sets of lines are then repeated for various different runes.

  # result = newTable[Rune, Glyph]()
  var lineSets = splitGlyphLineSets(text)
  
  # Split each set of glyph lines into separate glyphs
  for lineSet in lineSets:
    let glyphRanges = selectGlyphs(lineSet)

    assert lineSet.setRunes.len == glyphRanges.len

    # Extract glyphs from line set
    # and add them to the result
    for i, glyphRange in glyphRanges: 
      var rune = lineSet.setRunes[i]
      var lines: seq[seq[Rune]] = @[]
      for glyphLine in lineSet.glyphLines:
        let startIndex = glyphRange.start
        let endIndex = min(glyphRange.start + glyphRange.length, glyphLine.len)
        lines.add(glyphLine[startIndex ..< endIndex])
      let glyph = processGlyph(lines, glyphRange.length)
      result[rune] = glyph

  # Add space glyph
  result[space] = Glyph(width: spaceWidth, height: lineSets[0].glyphLines.len, segments: @[])

include fonts/glyphs_blocky
include fonts/glyphs_shady
include fonts/glyphs_tmplr

type
  GlyphFont* = enum
    Blocky
    Shady
    Tmplr

proc getGlyph*(character: Rune, font: GlyphFont = Blocky): Glyph =
  case font
  of Blocky:
    glyphsBlocky[character]
  of Shady:
    glyphsShady[character]
  of Tmplr:
    glyphsTmplr[character]

proc getFontHeight*(font: GlyphFont): int =
  case font
  of Blocky:
    glyphsBlocky[space].height
  of Shady:
    glyphsShady[space].height
  of Tmplr:
    glyphsTmplr[space].height