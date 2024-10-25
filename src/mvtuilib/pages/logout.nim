import illwill
import "../mullvad/account"
import "../global"

const maxSelectIndex = 1
const minSelectIndex = 0
proc logout_page*(tb: var TerminalBuffer, account: var Account) =

    if SELECT_INDEX > maxSelectIndex:
        SELECT_INDEX = minSelectIndex
    elif SELECT_INDEX < minSelectIndex:
        SELECT_INDEX = maxSelectIndex
    
    var x = int(tb.width / 2) - 10
    var y = int(tb.height / 2) - 7
    tb.write(x, y, "Are you sure that you")
    tb.write(x + 3, y + 1, "want to Logout?")

    x = int(tb.width / 2) - 5 
    y = int(tb.height / 2) - 2
    tb.drawRect(x, y, x + 9, y - 2, SELECT_INDEX == 0)
    tb.write(x + 2, y - 1, "Logout")

    y += 3

    tb.drawRect(x, y, x + 9, y - 2, SELECT_INDEX == 1)
    tb.write(x + 2, y - 1, "Cancle")

    if LAST_KEY == Key.Enter:
        if SELECT_INDEX == 0:
            account.logout()
        elif SELECT_INDEX == 1:
            PAGE = "MAIN"