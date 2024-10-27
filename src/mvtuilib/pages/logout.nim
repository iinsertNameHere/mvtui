import illwill
import "../mullvad/account"
import "../global"

import "../widgets/button"

const maxSelectIndex = 1
const minSelectIndex = 0

var logoutBtn = newButtonWidget(10, 0, "Logout", true)
var cancleBtn = newButtonWidget(10, 1, "Cancle", true)

proc logout_page*(tb: var TerminalBuffer, account: var Account) =

    if SELECT_INDEX > maxSelectIndex:
        SELECT_INDEX = minSelectIndex
    elif SELECT_INDEX < minSelectIndex:
        SELECT_INDEX = maxSelectIndex
    
    var x = int(tb.width / 2) - 10
    var y = int(tb.height / 2) - 7
    tb.write(x, y, "Are you sure that you")
    tb.write(x + 3, y + 1, "want to Logout?")

    logoutBtn.place(int(tb.width / 2) - 5, int(tb.height / 2) - 2)
    logoutBtn.draw(tb, SELECT_INDEX, LAST_KEY)

    cancleBtn.place(logoutBtn.x, logoutBtn.y + 4)
    cancleBtn.draw(tb, SELECT_INDEX, LAST_KEY)

    if logoutBtn.triggert:
        account.logout()
    elif cancleBtn.triggert:
        PAGE = "MAIN"
        SELECT_INDEX = 0