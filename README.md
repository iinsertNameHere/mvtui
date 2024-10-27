# MvTUI

**MvTUI** is a terminal-based user interface for managing **Mullvad VPN** connections. Designed for speed and simplicity, MvTUI provides a convenient way to interact with Mullvad's VPN service directly from the terminal, eliminating the need for complex CLI commands. With MvTUI, you can connect and disconnect, change servers, log in, and view account information with ease.

## Features

- **Connect / Disconnect**: Quickly toggle your VPN connection on or off.
- **Change Relays**: Easily switch between different Mullvad VPN relays for better performance or specific location requirements.
- **Login**: Enter your Mullvad account token to authenticate and start using the VPN.
- **Account Information**: View essential account details, including subscription status and expiration.

### Planned Features

- **Device Management**: Add or remove devices associated with your Mullvad account.
- **Basic Settings**: Configure fundamental settings such as startup behavior and connection preferences.
- **WireGuard Support**: Optional support for managing connections using WireGuard, potentially bypassing the need for `mullvad-cli`.

## Installation

To install MvTUI, ensure you have `mullvad-cli` and `git` installed on your system. Then, clone this repository and install with the following commands:

```bash
git clone https://github.com/iinsertNameHere/mvtui
cd mvtui
nim install
```

> **Note:** Installation requires `mullvad-cli`. Please install it from [Mullvad's official website](https://mullvad.net) if it's not already available.

## Usage

Start MvTUI with:

```bash
mvtui
```

Upon launching, you will be presented with an interactive terminal interface. Use the menu options on the main page to:

- **Connect/Disconnect**: Toggle your VPN connection.
- **Relays**: Switch between available servers based on country, city, and server ID.
- **Settings**: Configure basic settings for your connection and usage preferences.
- **Account**: View your account status, expiration, and log out if needed.
- **Infos**: Access information about the MvTUI project itself.

### Keybindings

- **q**: Quit MvTUI
- **Up Arrow**: Move selection up
- **Down Arrow**: Move selection down
- **Enter**: Confirm selection
- **Backspace**: Go back to the previous menu
- **H**: Display the help menu with keybindings and feature info

## Disclaimer

MvTUI is an independent project and is not affiliated with Mullvad VPN. Use this software responsibly and follow Mullvad’s terms of service.

---

Feel free to reach out via the Issues tab for questions, feature requests, or bug reports. Happy browsing!