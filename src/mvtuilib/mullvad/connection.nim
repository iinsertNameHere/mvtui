import osproc
import "../global"

proc connect*() =
    discard execProcess("mullvad relay set location " & ACTIVE_RELAY)
    discard execProcess("mullvad connect")

proc disconnect*() = 
    discard execProcess("mullvad disconnect")