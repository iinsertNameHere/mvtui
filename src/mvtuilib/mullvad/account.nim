import osproc, strformat, strutils
import "status"

type Account* = object
    accountNumber*: string
    expiresAt*: string
    deviceName*: string
    status*: Status

proc newAccount*(accountNumber: string, expiresAt: string, deviceName: string, status: Status): Account =
    result.accountNumber = accountNumber
    result.expiresAt = expiresAt
    result.deviceName = deviceName
    result.status = status

const NONEACCOUNT* = newAccount("NONE", "NONE", "NONE", NONESTATUS)
proc getAccount*(): Account =
    let rawAccountData = execProcess("mullvad account get").strip()
    if rawAccountData == "Not logged in on any account":
        return NONEACCOUNT

    let rawAccountDataLines = rawAccountData.split('\n')    
    
    let
       accountNumber = rawAccountDataLines[0].split(':')[^1].strip()
       expiresAt     = rawAccountDataLines[1].split(':')[1..^1].join(":").strip()
       deviceName    = rawAccountDataLines[2].split(':')[^1].strip()
       status        = getStatus()

    return newAccount(accountNumber, expiresAt, deviceName, status)

proc login*(loginAccountNumber: string = ""): Account  =
    let account = getAccount()
    if account != NONEACCOUNT: # Account is not logged in
        let loginMsg = execProcess(&"mullvad account login {loginAccountNumber}").strip()
        if loginMsg.split(' ')[0] == "Error:":
            return NONEACCOUNT

        return getAccount()

    # Account is logged in already but is changed now
    elif not loginAccountNumber.contains(r"\D") and loginAccountNumber != account.accountNumber:
        let loginMsg = execProcess(&"mullvad account login {loginAccountNumber}").strip()
        if loginMsg.split(' ')[0] == "Error:":
            return NONEACCOUNT

        return getAccount()

    else: # Account is logged in already
        return account

proc logout*(account: var Account) =
    discard execProcess("mullvad account logout")
    account = NONEACCOUNT