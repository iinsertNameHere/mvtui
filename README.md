<div align="center">
<img src="images/mvtui.svg" width="170px">

<br>

<h1><code>MvTUI</code> - Mullvad Terminal UI</h1>

</div>

**MvTUI** is a terminal-based user interface for managing **Mullvad VPN** connections. MvTUI provides a convenient way to interact with Mullvad's VPN service directly from the terminal, eliminating the need for CLI commands.

## :telescope: Features

- **Connect / Disconnect**: Quickly toggle your VPN connection on or off.
- **Change Relay**: Switch between different Mullvad VPN relays.
- **Login**: Login to your Mullvad account.
- **Account Information**: View essential account details.

### Planned Features

- **Device Management**: Add or remove devices associated with your Mullvad account.
- **Settings**: Configure fundamental settings such as connection preferences and encryption.

## :wrench: Installation

To install MvTUI, ensure you have `mullvad` and `git` installed on your system. Then, clone this repository and install with the following commands:

```bash
git clone https://github.com/iinsertNameHere/mvtui
cd mvtui
nim release
```

The compiled binary can be found in the `mvtui/bin/` folder.

## :satellite: Usage

Start MvTUI by running it in your terminal:

```bash
./mvtui
```

### :paperclip: Keybindings

- **q**: Quit MvTUI
- **Up Arrow**: Move selection up
- **Down Arrow**: Move selection down
- **Enter**: Confirm selection
- **Backspace**: Go back to the previous menu
- **h**: Display the help menu with keybindings and feature info

## :bangbang: Disclaimer

MvTUI is an independent project and is not affiliated with [Mullvad](https://mullvad.net/). Use this software responsibly and follow [Mullvad's](https://mullvad.net/) terms of service.


## :bug: Bugs


Feel free to reach out via Issues for questions, feature requests, or bug reports.
