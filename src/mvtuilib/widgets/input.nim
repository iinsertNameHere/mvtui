import illwill

const
    space*   = " "
    numbers* = "0123456789"
    letters* = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    symbols* = "+-*/#$%&=?!:;.,_<>|()[]{}\\^°´`\"'~"

# InputField object
type InputWidget* = object
    x*, y*: int
    width*: int
    value*: string
    selectIndex*: int
    validCharacters*: string
    borderColor*: ForegroundColor
    textColor*: ForegroundColor

proc newInputWidget*(
    width: int,
    selectIndex: int,
    validCharacters: string = space & numbers & letters & symbols,
    borderColor: ForegroundColor = fgWhite,
    textColor: ForegroundColor = fgWhite
): InputWidget =
    result.x               = 0
    result.y               = 0
    result.width           = width
    result.value           = ""
    result.selectIndex     = selectIndex
    result.validCharacters = validCharacters 
    result.borderColor     = borderColor
    result.textColor       = textColor

proc place*(input: var InputWidget, x: int, y: int) =
    input.x = x
    input.y = y

# Draw the input field on the terminal buffer and handle key input
proc draw*(input: var InputWidget, tb: var TerminalBuffer, selectIndex: int, lastKey: Key) =
    tb.setForegroundColor(input.borderColor)
    tb.drawRect(input.x, input.y, input.x + input.width, input.y + 2, input.selectIndex == selectIndex)

    tb.setForegroundColor(input.textColor)
    tb.write(input.x + 1, input.y + 1, input.value)
    
    tb.resetAttributes()

    # Handle key input
    if input.selectIndex == selectIndex:
        if lastKey == Key.Backspace:
            if input.value.len > 0:
                input.value = input.value[0..^2]  # Remove last character
        else:
            var lastChar = '\0'
            try:
                lastChar = char(lastKey.ord)
            except:
                discard

            if lastChar != '\0' and lastChar in input.validCharacters and input.value.len < input.width - 1:
                input.value &= lastChar