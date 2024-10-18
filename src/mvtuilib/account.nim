import options
import osproc
import strformat
import strutils

type Status* = object
    state*: string
    location*: string
    ipv4*: string

type Account* = object
    accountNumber*: string
    expiresAt*: string
    deviceName*: string
    status*: Status

proc newStatus*(state: string, location: string, ipv4: string): Status =
    result.state = state
    result.location = location
    result.ipv4 = ipv4

const NONESTATUS* = newStatus("NONE", "NONE", "NONE")
proc getStatus*(): Status =
    let
        rawStatusData = execProcess("mullvad status").strip()
        statusDataLines = rawStatusData.split("\n")

    if statusDataLines.len < 2:
        return NONESTATUS

    let locationAndIPv4 = statusDataLines[1].strip().split(":")
    if locationAndIPv4.len < 3:
        return NONESTATUS
    
    let 
        state = statusDataLines[0].split(" ")[0].strip()
        location = locationAndIPv4[1].split(".")[0].strip()
        ipv4 = locationAndIPv4[2].strip()

    return newStatus(state, location, ipv4)

proc newAccount*(accountNumber: string, expiresAt: string, deviceName: string, status: Status): Account =
    result.accountNumber = accountNumber
    result.expiresAt = expiresAt
    result.deviceName = deviceName
    result.status = status

proc getAccount*(): Option[Account] =
    let rawAccountData = execProcess("mullvad account get").strip()
    if rawAccountData == "Not logged in on any account":
        return none(Account) # Return None if account is not logged in

    let rawAccountDataLines = rawAccountData.split('\n')    
    
    let
       accountNumber = rawAccountDataLines[0].split(':')[^1].strip()
       expiresAt     = rawAccountDataLines[1].split(':')[1..^1].join(":").strip()
       deviceName    = rawAccountDataLines[2].split(':')[^1].strip()
       status        = getStatus()

    return some(newAccount(accountNumber, expiresAt, deviceName, status))



proc login*(loginAccountNumber: string = ""): Option[Account]  =
    let account = getAccount()
    if not account.isSome: # Account is not logged in
        let loginMsg = execProcess(&"mullvad account login {loginAccountNumber}").strip()
        if loginMsg.split(' ')[0] == "Error:":
            return none(Account)

        return getAccount()

    # Account is logged in already but is changed now
    elif not loginAccountNumber.contains(r"\D") and loginAccountNumber != account.get().accountNumber:
        let loginMsg = execProcess(&"mullvad account login {loginAccountNumber}").strip()
        if loginMsg.split(' ')[0] == "Error:":
            return none(Account)

        return getAccount()

    else: # Account is logged in already
        return account