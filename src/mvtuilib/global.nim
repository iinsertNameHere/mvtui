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

const
    BORDER_COLOR*: ForegroundColor = fgWhite