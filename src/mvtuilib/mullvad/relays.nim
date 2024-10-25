import osproc, strutils, tables

proc getRelays*(): OrderedTable[string, seq[string]] = 
    let rawData = execProcess("mullvad relay list").splitLines()
    var currentCountry = ""
    var idx = 0
    
    while idx < rawData.len:
        let line = rawData[idx].strip()
        
        # Check if the line is a country line (no "-" and no "@")
        if line.len > 0 and "-" notin line and "@" notin line:  
            currentCountry = line.split("(")[0].strip()  # Extract the country name before "("
            result[currentCountry] = @[]  # Initialize the sequence for relays
        
        # Check if the line is a relay line (contains "-" and does not contain "@")
        elif currentCountry != "" and "-" in line and "@" notin line:  
            let relay = line.strip().splitWhitespace()[0]  # Extract the relay name
            result[currentCountry].add(relay)  # Add relay to the current country
        
        idx += 1  # Move to the next line

    return result

let RELAYS* = getRelays()