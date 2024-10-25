import re, strutils, osproc

type Status* = object
    state*: string
    relay*: string
    features*: string
    location*: string
    ipv4*: string

let
    statusRegex = re"(Connected|Connecting|Disconnected)"
    relayRegex = re"Relay:\s+(.+)"
    featuresRegex = re"Features:\s+(.+)"
    locationRegex = re"Visible location:\s+([^\.]+)"
    ipv4Regex = re"IPv4:\s+([\d\.]+)"

proc newStatus*(state: string, relay: string, features: string, location: string, ipv4: string): Status =
  result.state = state
  result.relay = relay
  result.features = features
  result.location = location
  result.ipv4 = ipv4    

const NONESTATUS* = newStatus("", "", "", "", "")

proc getStatus*(): Status =
  let text = execProcess("mullvad status")

  # Find and assign status
  var matches = text.findAll(statusRegex)
  if matches.len > 0:
    result.state = matches[0]

  # Find and assign relay if present
  matches = text.findAll(relayRegex)
  if matches.len > 0:
    result.relay = matches[0].split(":")[1].strip()

  # Find and assign features if present
  matches = text.findAll(featuresRegex)
  if matches.len > 0:
    result.features = matches[0].split(":")[1].strip()

  # Find and assign location if present
  matches = text.findAll(locationRegex)
  if matches.len > 0:
    result.location = matches[0].split(":")[1].strip()

  # Find and assign IPv4 if present
  matches = text.findAll(ipv4Regex)
  if matches.len > 0:
    result.ipv4 = matches[0].split(":")[1].strip()
