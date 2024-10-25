import illwill
import tables
import "../global"
import "../mullvad/relays"

var SELECT_INDEX = 0  # Keeps track of the currently selected country
var relayIndex = 0  # Keeps track of the currently selected relay
var showRelays = false  # Determines whether to show the relay list or country list
var selectedRelay: string  # Holds the currently selected relay
var selectedCountry: string

proc updateScrollRange(maxSelectIndex: int, visibleHeight: int, scrollStart: var int, scrollEnd: var int, index: int) =
    ## Updates the scroll range based on the selected index and visible height.
    if index >= scrollEnd:
        scrollStart = index - visibleHeight + 1
        scrollEnd = index + 1
    elif index < scrollStart:
        scrollStart = index
        scrollEnd = index + visibleHeight

    # Ensure scrollStart and scrollEnd are clamped within valid bounds
    if scrollStart < 0:
        scrollStart = 0
    if scrollEnd > maxSelectIndex + 1:
        scrollEnd = maxSelectIndex + 1

proc displayCountries*(tb: var TerminalBuffer) =
    ## Display only the countries in the terminal buffer.
    let visibleHeight = tb.height - 6
    let maxSelectIndex = RELAYS.len - 1  # Total number of countries selectable

    # Dynamically update scroll range for the current selected index
    var scrollStart = 0
    var scrollEnd = visibleHeight
    updateScrollRange(maxSelectIndex, visibleHeight, scrollStart, scrollEnd, SELECT_INDEX)

    # Adjusted coordinates for visual alignment
    var x = int(tb.width / 4)  # Align to 1/4th of the screen width
    var y = tb.height - 3
    tb.drawRect(x - 2, y, tb.width - x + 4, 2)  # Adjust the bottom rectangle for clarity

    x += 6
    y = 3  # Starting Y position for content

    var idx = 0  # Index to track the selected country
    for country in RELAYS.keys:
        if idx >= scrollStart and idx < scrollEnd:  # Only render visible countries
            if y <= tb.height - 4:
                if ACTIVE_RELAY_COUNTRY == country and SELECT_INDEX == idx:
                    tb.setForegroundColor(fgYellow)
                elif SELECT_INDEX == idx:
                    tb.setForegroundColor(fgGreen)  # Highlight the selected country
                elif ACTIVE_RELAY_COUNTRY == country:
                    tb.setForegroundColor(fgBlue)
                tb.write(x, y, country)
                tb.resetAttributes()
            y += 1
        idx += 1

proc displayRelaysForCountry*(tb: var TerminalBuffer, selectedCountry: string) =
    ## Display the relays for the currently selected country.
    let visibleHeight = tb.height - 6
    let maxSelectIndex = RELAYS[selectedCountry].len - 1  # Total relays for selected country

    # Dynamically update scroll range for relays
    var scrollStart = 0
    var scrollEnd = visibleHeight
    updateScrollRange(maxSelectIndex, visibleHeight, scrollStart, scrollEnd, relayIndex)

    # Adjusted coordinates for visual alignment
    var x = int(tb.width / 4)  # Align to 1/4th of the screen width
    var y = tb.height - 3
    tb.drawRect(x - 2, y, tb.width - x + 4, 2)  # Adjust the bottom rectangle for clarity

    x += 6
    y = 3  # Starting Y position for content

    var idx = 0  # Index to track the relays
    for relay in RELAYS[selectedCountry]:
        if idx >= scrollStart and idx < scrollEnd:  # Only render visible relays
            if y <= tb.height - 4:
                if ACTIVE_RELAY == relay and relayIndex == idx:
                    tb.setForegroundColor(fgYellow)
                elif relayIndex == idx:
                    tb.setForegroundColor(fgGreen)  # Highlight the selected relay
                elif ACTIVE_RELAY == relay:
                    tb.setForegroundColor(fgBlue)
                tb.write(x, y, relay)
                tb.resetAttributes()
            y += 1
        idx += 1

proc chooserelay_page*(tb: var TerminalBuffer) =
    if showRelays:
        # Display relays for the selected country
        var keys: seq[string]
        for k in RELAYS.keys: keys.add(k)

        selectedCountry = keys[SELECT_INDEX]  # Get the selected country
        displayRelaysForCountry(tb, selectedCountry)

        # Update the selected relay based on the relayIndex
        selectedRelay = RELAYS[selectedCountry][relayIndex]
    else:
        # Display the list of countries
        displayCountries(tb)

    if showRelays:
        # Relay navigation
        var keys: seq[string]
        for k in RELAYS.keys: keys.add(k)

        let selectedCountry = keys[SELECT_INDEX]
        if LAST_KEY == Key.Enter:
            showRelays = false
            ACTIVE_RELAY = selectedRelay
            ACTIVE_RELAY_COUNTRY = selectedCountry
            PAGE = "MAIN"
            SELECT_INDEX = 0
        elif LAST_KEY == Key.Backspace:
            showRelays = false  # Go back to showing countries
            relayIndex = 0  # Reset relay selection when going back to country view
        elif LAST_KEY == Key.Up:
            if relayIndex > 0:
                relayIndex -= 1
        elif LAST_KEY == Key.Down:
            if relayIndex < RELAYS[selectedCountry].len - 1:
                relayIndex += 1

        # Update the selected relay when navigating
        selectedRelay = RELAYS[selectedCountry][relayIndex]
    else:
        # Country navigation
        if LAST_KEY == Key.Enter:         
            showRelays = true  # Switch to relay view
            relayIndex = 0  # Reset relay selection
            selectedRelay = ""  # Clear selectedRelay when switching bac
        elif LAST_KEY == Key.Up:
            if SELECT_INDEX > 0:
                SELECT_INDEX -= 1
        elif LAST_KEY == Key.Down:
            if SELECT_INDEX < RELAYS.len - 1:
                SELECT_INDEX += 1
        elif LAST_KEY == Key.Backspace:
            showRelays = false
            PAGE = "MAIN"
            SELECT_INDEX = 0
