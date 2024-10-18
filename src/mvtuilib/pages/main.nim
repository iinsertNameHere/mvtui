import illwill
import strutils
import tables
import "../account"
import "../countries"

proc main_page*(tb: var TerminalBuffer, account: var Account) =
    let ascii_art = @[
        r"                        d8b  d8b                          d8b ",
        r"                        88P  88P                          88P ",
        r"                       d88  d88                          d88  ",
        r"  88bd8b,d88b ?88   d8P888  888  ?88   d8P d888b8b   d888888  ",
        r"  88P'`?8P'?8bd88   88 ?88  ?88  d88  d8P'd8P' ?88  d8P' ?88  ",
        r" d88  d88  88P?8(  d88  88b  88b ?8b ,88' 88b  ,88b 88b  ,88b ",
        r"d88' d88'  88b`?88P'?8b  88b  88b`?888P'  `?88P'`88b`?88P'`88b"
    ]

    let halfwidth  = tb.width / 2
    let halfheight = tb.height / 2

    var x = int(halfwidth - (ascii_art[0].len / 2))
    var y = 5

    tb.setForegroundColor(fgBlue)
    var current_y = 0 + y
    for i, line in ascii_art:
        current_y = i + y
        tb.write(x, current_y, line)
    
    tb.setForegroundColor(fgYellow)
    let subtitle = "-= Mullvad Terminal User Interface =-"
    x = int(halfwidth - (subtitle.len / 2))
    tb.write(x, current_y + 2, subtitle)
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

    var country = countries[account.status.location.split(",")[0].strip()]
    for line in country:
        tb.write(x, current_y, line)
        current_y += 1

    tb.resetAttributes()

    tb.drawHorizLine(0, tb.width, tb.height - 3)
    tb.write(0, tb.height - 3, "├")
    tb.write(tb.width - 1, tb.height - 3, "┤")

    if account.status.state == "Connected": tb.setForegroundColor(fgGreen)
    else: tb.setForegroundColor(fgRed)
    tb.write(7, tb.height - 2, account.status.state)
    
    tb.setForegroundColor(fgBlue)
    tb.write(int((tb.width / 2) - (account.status.location.len / 2)), tb.height - 2, account.status.location)

    tb.setForegroundColor(fgMagenta)
    tb.write(tb.width - account.status.ipv4.len - 7, tb.height - 2, account.status.ipv4)

    tb.resetAttributes()

