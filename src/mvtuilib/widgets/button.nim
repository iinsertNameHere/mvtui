# widgets.nim
import illwill

# Button object
type ButtonWidget* = object
    x*, y*: int
    width*: int
    label*: string
    selectIndex*: int
    triggert*: bool
    centered*: bool
    borderColor*: ForegroundColor
    textColor*: ForegroundColor

proc newButtonWidget*(
    width: int,
    selectIndex: int,
    label: string,
    centered: bool = true,
    borderColor: ForegroundColor = fgWhite,
    textColor: ForegroundColor = fgWhite
): ButtonWidget =
    result.x = 0
    result.y = 0
    result.width = width
    result.label = label
    result.selectIndex = selectIndex
    result.triggert = false
    result.centered = centered
    result.borderColor = borderColor
    result.textColor = textColor

proc place*(btn: var ButtonWidget, x: int, y: int) =
    btn.x = x
    btn.y = y

# Draw the button on the terminal buffer and handle key input
proc draw*(btn: var ButtonWidget, tb: var TerminalBuffer, selectIndex: int, lastKey: Key) =
    tb.setForegroundColor(btn.borderColor)
    if btn.centered:
        tb.drawRect(btn.x, btn.y, btn.x + btn.width, btn.y + 2, btn.selectIndex == selectIndex)
        tb.setForegroundColor(btn.textColor)
        tb.write(btn.x + ((btn.width div 2) - (btn.label.len div 2)), btn.y + 1, btn.label)
    else:
        tb.drawRect(btn.x, btn.y, btn.x + btn.width, btn.y + 2, btn.selectIndex == selectIndex)
        tb.setForegroundColor(btn.textColor)
        tb.write(btn.x + 1, btn.y + 1, btn.label)
    tb.resetAttributes()

    # Handle key input for button activation
    if lastKey == Key.Enter and btn.selectIndex == selectIndex:
        btn.triggert = true
    else:
        btn.triggert = false