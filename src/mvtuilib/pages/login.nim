import illwill

import "../global"
import "../mullvad/account"
import "../asciiart/logo"
import "../widgets/button"
import "../widgets/input"

const maxSelectIndex = 1
const minSelectIndex = 0
var loginFailed = false

var inputbox  = newInputWidget(17, 0, numbers)
var loginbtn  = newButtonWidget(17, 1, "Login", true)

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

    inputbox.place(int(tb.width / 2) - 9, int(tb.height / 2))
    inputbox.draw(tb, SELECT_INDEX, LAST_KEY)

    tb.write(0, 0, inputbox.value)

    loginbtn.place(inputbox.x, inputbox.y + 3 )
    loginbtn.draw(tb, SELECT_INDEX, LAST_KEY)

    if loginbtn.triggert:
        if inputbox.value.len > 0:
            let acc = login(inputbox.value)
            if acc != NONEACCOUNT:
                account = acc
                PAGE = "MAIN"
                loginFailed = false
                inputbox.value = ""
            else:
                loginFailed = true

    if loginFailed:
        y = loginbtn.y + 4
        x = int(tb.width / 2) - 11
        tb.setForegroundColor(fgRed)
        tb.write(x, y, "ERROR: Failed to Login")
        tb.resetAttributes()


    