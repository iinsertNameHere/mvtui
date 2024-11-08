import illwill, strutils, tables
import "../global"

import "../mullvad/account"
import "../mullvad/status"
import "../mullvad/connection"

import "../asciiart/countries"
import "../asciiart/logo"

import "../widgets/button"

const maxSelectIndex = 2
const minSelectIndex = 0

var connectionBtn = newButtonWidget(20, 0, "",         true)
var relayBtn      = newButtonWidget(20, 1, "",         true, textColor = fgGreen)
var settingsBtn   = newButtonWidget(20, 2, "Settings", true)

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

    # connectionBtn.place(int(halfwidth / 2) - 10, int(tb.height / 2) - 4)
    connectionBtn.place(1, int(tb.height / 2) - 4)
    if account.status.state == "Disconnected": connectionBtn.label = "Connect"
    else: connectionBtn.label = "Disconnect"
    connectionBtn.draw(tb, SELECT_INDEX, LAST_KEY)

    relayBtn.place(connectionBtn.x, connectionBtn.y + 4)
    relayBtn.label = ACTIVE_RELAY_COUNTRY
    relayBtn.draw(tb, SELECT_INDEX, LAST_KEY)

    settingsBtn.place(relayBtn.x, relayBtn.y + 4)
    settingsBtn.draw(tb, SELECT_INDEX, LAST_KEY)

    tb.drawRect(0, connectionBtn.y - 1, 22, settingsBtn.y + 3)
    tb.write(0, connectionBtn.y - 1, "├")
    tb.write(0, settingsBtn.y + 3, "├")

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

    if connectionBtn.triggert:
        if account.status.state == "Disconnected":
            connect()
        else:
            disconnect()    
    elif relayBtn.triggert:
        SELECT_INDEX = 0
        PAGE = "CHOOSERELAY"
    elif settingsBtn.triggert:
        discard

