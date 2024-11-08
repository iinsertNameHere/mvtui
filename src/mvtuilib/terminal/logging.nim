import terminal

template printLog(color: ForegroundColor, prefixName: string, message: string) = 
    styledEcho(color, "[" & prefixName & "]: " & message)

proc printInfo*(message: string) =
    printLog(fgYellow, "INFO", message)

proc printSuccess*(message: string) =
    printLog(fgYellow, "SUCCESS", message)

proc printWarning*(message: string) =
    printLog(fgYellow, "WARNING", message)

proc printError*(message: string, fatal: bool = true, exitCode: int = 1) =
    printLog(fgYellow, "ERROR", message)
    if fatal: quit(exitCode)