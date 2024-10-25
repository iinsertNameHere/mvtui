import illwill
import strutils

# Custom function to left-justify (ljust) a string by adding spaces
proc ljust(s: string, width: int): string =
  if s.len >= width:
    return s
  else:
    return s & repeat(" ", width - s.len)

proc formatGrid*(data: seq[(string, string)], maxRows: int): string =
  let totalItems = data.len
  let totalCols = (totalItems + maxRows - 1) div maxRows  # Calculate required columns

  # Find the maximum length of the keys and values to align columns
  var maxKeyLen = 0
  var maxValLen = 0
  for (key, value) in data:
    if key.len > maxKeyLen:
      maxKeyLen = key.len
    if value.len > maxValLen:
      maxValLen = value.len
  
  var grid: seq[string] = @[]
  
  # Distribute the tuples across columns and rows
  for rowIdx in 0..<maxRows:
    var row = ""
    for colIdx in 0..<totalCols:
      let idx = colIdx * maxRows + rowIdx
      if idx < totalItems:
        let (key, value) = data[idx]
        row.add(ljust(key, maxKeyLen) & "  ->  " & ljust(value, maxValLen))
        if colIdx < totalCols - 1:
          row.add(repeat(" ", 4)) # Add spacing between columns
    grid.add(row.strip())
  
  return grid.join("\n")

proc exitProc*() {.noconv.} =
  illwillDeinit()
  showCursor()
  quit(0)

const
  BORDER_COLOR*: ForegroundColor = fgWhite
  LOGO_ART*: seq[string] = @[
    r"                        d8b  d8b                          d8b ",
    r"                        88P  88P                          88P ",
    r"                       d88  d88                          d88  ",
    r"  88bd8b,d88b ?88   d8P888  888  ?88   d8P d888b8b   d888888  ",
    r"  88P'`?8P'?8bd88   88 ?88  ?88  d88  d8P'd8P' ?88  d8P' ?88  ",
    r" d88  d88  88P?8(  d88  88b  88b ?8b ,88' 88b  ,88b 88b  ,88b ",
    r"d88' d88'  88b`?88P'?8b  88b  88b`?888P'  `?88P'`88b`?88P'`88b"
  ]
  LOGO_SUBTITLE*: string = "-= Mullvad Terminal User Interface =-"

var
  SELECT_INDEX*: int = 0
  LAST_KEY*: Key     = Key.None
  PAGE*: string      = ""
  ACTIVE_RELAY*: string = "fi-hel-wg-001"
  ACTIVE_RELAY_COUNTRY*: string = "Finland"