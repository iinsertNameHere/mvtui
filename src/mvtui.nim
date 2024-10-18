# Simple example that prints out the size of the terminal window and
# demonstrates the basic structure of a full-screen app.

import os
import options
import illwill
import times
from "mvtuilib/global" import BORDER_COLOR
import "mvtuilib/account"

import "mvtuilib/pages/help" 
import "mvtuilib/pages/main" 

proc exitProc() {.noconv.} =
  illwillDeinit()
  showCursor()
  quit(0)

proc main() =
  illwillInit(fullscreen=true)
  setControlCHook(exitProc)
  hideCursor()


  # Get account and status Data
  var opt_account = getAccount()
  var account: Account
  if opt_account.isSome:
    account = opt_account.get()
  else:
    account = newAccount("0000000000000", "NONE", "NONE", newStatus("Dissconected", "NONE", "NONE"))
  var t0 = epochTime()

  var page: string = "MAIN"
  
  # Main Loop
  while true:
    let 
      termWidth  = terminalWidth()
      termHeight = terminalHeight()
    var tb = newTerminalBuffer(termWidth, termHeight)

    # Define Hotkeys
    var key = getKey()
    case key
    of Key.Escape, Key.Q: exitProc()
    of Key.H: page = "HELP"
    of Key.M: page = "MAIN"
    else: discard

    # Draw Border
    tb.setForegroundColor(BORDER_COLOR)
    tb.drawRect(0, 0, tb.width-1, tb.height-1)
    tb.resetAttributes()

    # Handle pages
    if page == "MAIN": tb.main_page(account)
    elif page == "HELP": tb.help_page()

    # Display Buffer
    tb.display()
    
    # Refresh status all 5 sec
    var time = (epochTime() - t0)
    if int(time) > 5:
      var newstatus = getStatus()
      if newstatus != NONESTATUS:
        account.status = newstatus
      t0 = epochTime()

    sleep(20)

main()
