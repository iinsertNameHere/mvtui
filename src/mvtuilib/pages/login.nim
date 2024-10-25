import illwill

import "../global"

import "../mullvad/account"

import "../asciiart/logo"

const maxSelectIndex = 1
const minSelectIndex = 0
var inputBuffer = ""
var loginFailed = false
proc login_page*(tb: var TerminalBuffer, account: var Account) =
    if SELECT_INDEX > maxSelectIndex:
        SELECT_INDEX = minSelectIndex
    elif SELECT_INDEX < minSelectIndex:
        SELECT_INDEX = maxSelectIndex
    
    var x = int((tb.width / 2) - (logoArt[0].len / 2))
    var y = 5

    tb.setForegroundColor(fgBlue)
    var current_y = 0 + y
    for i, line in logoArt:
        current_y = i + y
        tb.write(x, current_y, line)
    
    tb.setForegroundColor(fgYellow)
    x = int((tb.width / 2) - (logoSubtitle.len / 2))
    tb.write(x, current_y + 2, logoSubtitle)
    tb.resetAttributes()
    
    x = int(tb.width / 2) - 9
    y = int(tb.height / 2) - 2
    tb.write(x, y, "Please Login using")
    tb.write(x - 1, y + 1, "your Account number:")

    x = int(tb.width / 2) + 8
    y = int(tb.height / 2) + 1
    tb.drawRect(x, y, x - 17, y + 2, SELECT_INDEX == 0)
    tb.write(x - 16, y + 1, inputBuffer)

    y += 3
    tb.drawRect(x, y, x - 17, y + 2, SELECT_INDEX == 1)
    tb.write(x - 11, y + 1, "Login")

    if loginFailed:
        y += 4
        x = int(tb.width / 2) - 11
        tb.setForegroundColor(fgRed)
        tb.write(x, y, "ERROR: Failed to Login")
        tb.resetAttributes()

    var keychar = '\0'
    try:
        keychar = char(LAST_KEY.ord)
    except:
        discard

    if SELECT_INDEX == 0:
        if $keychar in @["1","2","3","4","5","6","7","8","9","0"] and inputBuffer.len < 16:
            inputBuffer &= $keychar
        elif LAST_KEY == Key.Backspace and inputBuffer.len > 0:
            inputBuffer = inputBuffer[0..inputBuffer.len - 2]
    elif SELECT_INDEX == 1 and LAST_KEY == Key.Enter and inputBuffer.len > 0:
        let acc = login(inputBuffer)
        if acc != NONEACCOUNT:
            account = acc
            PAGE = "MAIN"
            loginFailed = false
            inputBuffer = ""
        else:
            loginFailed = true


    