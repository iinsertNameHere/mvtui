import illwill, strutils
import "../global"
import "../widgets/button"

var backBtn = newButtonWidget(7, 0, " Back ", false)

proc help_page*(tb: var TerminalBuffer, lastPage: string) =
    SELECT_INDEX = 0

    let ascii_art = @[
        r"            _           __ _     _   ",
        r"  /\  /\___| |_ __     / /(_)___| |_ ",
        r" / /_/ / _ \ | '_ \   / / | / __| __|",
        r"/ __  /  __/ | |_) | / /__| \__ \ |_ ",
        r"\/ /_/ \___|_| .__/  \____/_|___/\__|",
        r"             |_|                     "]

    tb.setForegroundColor(fgGreen)
    for i, line in ascii_art:
        var w = int((tb.width / 2) - (line.len / 2))
        tb.write(w, i + 1, line)
    tb.resetAttributes()

    let help_list = @[
        ("q", "Quit Program"),
        ("Up", "Select Up"),
        ("Down", "Select Down"),
        ("Enter", "Confirm"),
        ("Backspace", "Back"),
        ("F1", "Logout"),
        ("h", "Help Page"),
        ("m", "Main Page"),
    ]

    let h = int(tb.height - (4 + ascii_art.len))
    let grid = formatGrid(help_list, h).split("\n")
    let w = int((tb.width / 2) - (grid[0].len / 2))
    for i, line in grid:
        tb.write(w, i + (2 + ascii_art.len), line)

    backBtn.place(7, 3)
    backBtn.draw(tb, SELECT_INDEX, LAST_KEY)

    if backBtn.triggert:
        PAGE = lastPage