import json
from os import fileExists

import "../global"
import "../terminal/logging"

const settingsFile = "/etc/mullvad-vpn/settings.json"

proc loadSettings*() =
    if not fileExists(settingsFile):
        printError("Settings file not found!")
    
    SETTINGS = parseFile(settingsFile)

proc saveSettings*() =
    if not fileExists(settingsFile):
        printError("Settings file not found!")
    
    let jsonString = SETTINGS.pretty(4)

    let f = open(settingsFile, fmWrite) # fmWrite is the file mode constant
    defer: f.close()

    f.write(jsonString)