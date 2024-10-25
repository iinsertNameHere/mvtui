import os, illwill, times

import "mvtuilib/global"

import "mvtuilib/mullvad/account"
import "mvtuilib/mullvad/status"

import "mvtuilib/pages/help" 
import "mvtuilib/pages/main" 
import "mvtuilib/pages/login"
import "mvtuilib/pages/logout"
import "mvtuilib/pages/chooserelay"

proc main() =
  illwillInit(fullscreen=true)
  setControlCHook(exitProc)
  hideCursor()


  # Get account and status Data
  var account = getAccount()

  var t0 = epochTime()
  PAGE = "MAIN"
  var lastPage = PAGE
  
  # Main Loop
  while true:
    let 
      termWidth  = terminalWidth()
      termHeight = terminalHeight()
    var tb = newTerminalBuffer(termWidth, termHeight)

    # Define Hotkeys
    LAST_KEY = getKey()
    case LAST_KEY:
      of Key.Escape, Key.Q: exitProc()
      of Key.Up: SELECT_INDEX -= 1
      of Key.Down: SELECT_INDEX += 1
      of Key.H: 
        if PAGE != "HELP": lastPage = PAGE
        SELECT_INDEX = 0
        PAGE = "HELP"
      of Key.F1:
        if account != NONEACCOUNT:
          SELECT_INDEX = 0
          PAGE = "LOGOUT"
      else: discard

    if account == NONEACCOUNT:
      PAGE = "LOGIN"

    # Draw Border
    tb.setForegroundColor(BORDER_COLOR)
    tb.drawRect(0, 0, tb.width-1, tb.height-1)
    tb.resetAttributes()

    # Handle pages
    if PAGE == "MAIN": tb.main_page(account)
    elif PAGE == "HELP": tb.help_page(lastPage)
    elif PAGE == "LOGIN": tb.login_page(account)
    elif PAGE == "LOGOUT": tb.logout_page(account)
    elif PAGE == "CHOOSERELAY": tb.chooserelay_page() 
    else: PAGE = "MAIN"

    # Display Buffer
    tb.display()
    
    # Refresh status all 5 sec
    var time = (epochTime() - t0)
    if time > 4:
      var newstatus = getStatus()
      if newstatus != NONESTATUS:
        account.status = newstatus
      t0 = epochTime()

    sleep(25)

main()