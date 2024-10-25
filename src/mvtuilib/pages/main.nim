import illwill, strutils, tables
import "../global"

import "../mullvad/account"
import "../mullvad/status"
import "../mullvad/connection"

import "../asciiart/countries"
import "../asciiart/logo"

const maxSelectIndex = 5
const minSelectIndex = 0
proc main_page*(tb: var TerminalBuffer, account: var Account) =
    if SELECT_INDEX > maxSelectIndex:
        SELECT_INDEX = minSelectIndex
    elif SELECT_INDEX < minSelectIndex:
        SELECT_INDEX = maxSelectIndex

    let halfwidth  = tb.width / 2

    var x = int(halfwidth - (logoArt[0].len / 2))
    var y = 3

    tb.setForegroundColor(fgBlue)
    var current_y = 0 + y
    for i, line in logoArt:
        current_y = i + y
        tb.write(x, current_y, line)
    
    tb.setForegroundColor(fgYellow)
    x = int(halfwidth - (logoSubtitle.len / 2))
    tb.write(x, current_y + 2, logoSubtitle)
    tb.resetAttributes()

    tb.write(1, 1, "Account:")
    tb.setForegroundColor(fgGreen)
    tb.write(10, 1, account.accountNumber)
    tb.write(17, 1, "*".repeat(account.accountNumber.len - 9))
    tb.resetAttributes()

    
    let expiresAt = account.expiresAt.split(" ")[0..1].join(" ")
    x = tb.width - (19 + expiresAt.len)
    tb.write(x, 1, "Time Expires at:")
    tb.setForegroundColor(fgMagenta)
    tb.write(x+17, 1, expiresAt)
    tb.resetAttributes()

    current_y += 5
    y = current_y
    x = int(halfwidth - 20)

    tb.setForegroundColor(fgCyan, bright=true)

    var location = account.status.location.split(",")[0].strip()
    if not (location in countrynames):
        location = "Mullvad"

    var country = countries[location]
    for line in country:
        tb.write(x, current_y, line)
        current_y += 1

    tb.resetAttributes()

    x = int(halfwidth / 2) + 10
    y = int(tb.height / 2) - 2

    tb.drawRect(x, y, x - 16, y - 2, SELECT_INDEX == 0)
    if account.status.state == "Disconnected":
        tb.write(x - 11, y - 1, "Connect")
    else:
        tb.write(x - 12, y - 1, "Disconnect")

    y += 4

    tb.drawRect(x, y, x - 16, y - 2, SELECT_INDEX == 1)
    tb.setForegroundColor(fgGreen)
    tb.write(x - (8 + int(ACTIVE_RELAY_COUNTRY.len / 2)), y - 1, ACTIVE_RELAY_COUNTRY)
    tb.resetAttributes()

    y += 4    

    tb.drawRect(x, y, x - 16, y - 2, SELECT_INDEX == 2)
    tb.write(x - 10, y - 1, "Quit")


    x = int(halfwidth + (halfwidth / 2)) + 5
    y = int(tb.height / 2) - 2

    tb.drawRect(x, y, x - 16, y - 2, SELECT_INDEX == 3)
    tb.write(x - 12, y - 1, "Settings")

    y += 4

    tb.drawRect(x, y, x - 16, y - 2, SELECT_INDEX == 4)
    tb.write(x - 11, y - 1, "Account")

    y += 4

    tb.drawRect(x, y, x - 16, y - 2, SELECT_INDEX == 5)
    tb.write(x - 10, y - 1, "Infos")


    tb.drawHorizLine(0, tb.width, tb.height - 3)
    tb.write(0, tb.height - 3, "├")
    tb.write(tb.width - 1, tb.height - 3, "┤")

    if account.status.state == "Connected": tb.setForegroundColor(fgGreen)
    elif account.status.state == "Connecting": tb.setForegroundColor(fgYellow)
    else: tb.setForegroundColor(fgRed)
    var state = account.status.state
    if state == "Connecting":
        state &= "..."
    tb.write(7, tb.height - 2, state)
    
    tb.setForegroundColor(fgBlue)
    tb.write(int((tb.width / 2) - (account.status.location.len / 2)), tb.height - 2, account.status.location)

    tb.setForegroundColor(fgMagenta)
    tb.write(tb.width - account.status.ipv4.len - 7, tb.height - 2, account.status.ipv4)

    tb.resetAttributes()

    if LAST_KEY == Key.Enter:
        if SELECT_INDEX == 0:
            if account.status.state == "Disconnected":
                connect()
            else:
                disconnect()    
        elif SELECT_INDEX == 1:
            SELECT_INDEX = 0
            PAGE = "CHOOSERELAY"
        elif SELECT_INDEX == 2:
            exitProc()
        elif SELECT_INDEX == 3:
            discard
        elif SELECT_INDEX == 4:
            discard
        elif SELECT_INDEX == 5:
            discard

