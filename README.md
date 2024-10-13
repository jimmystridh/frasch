# Frasch

Frasch is a collection of personal Mac setup scripts designed to automate the configuration of a new macOS system. These scripts handle various tasks from installing essential software to configuring system preferences, making it easy to set up a new Mac or restore your preferred settings quickly.

## Features

- Installs Homebrew and manages packages via Brewfile
- Sets up Oh My Zsh with custom plugins and themes
- Configures macOS system preferences
- Installs and configures development tools
- Customizes Dock and Finder settings
- Sets up screenshots directory and preferences
- Installs Rosetta for ARM-based Macs
- Configures GitHub CLI with Copilot extension

## Main Components

- `frasch.sh`: The main script that orchestrates the setup process
- `frasch_funcs.sh`: Contains general utility functions
- `frasch_mac_funcs.sh`: Contains macOS-specific configuration functions
- `Brewfile`: Lists all packages to be installed via Homebrew

## Usage

1. Clone this repository to your local machine:
   ```
   git clone https://github.com/yourusername/frasch.git
   cd frasch
   ```

2. Make the main script executable:
   ```
   chmod +x frasch.sh
   ```

3. Run the script:
   ```
   ./frasch.sh
   ```

   Note: You may be prompted for your password to execute certain commands with sudo privileges.

## Customization

Feel free to modify the scripts to suit your personal preferences:

- Edit the `Brewfile` to add or remove software packages
- Modify `frasch_mac_funcs.sh` to change macOS system preferences
- Adjust `frasch.sh` to add or remove setup steps

## Requirements

- macOS (tested on version X.X and above)
- Internet connection for downloading software and tools

## Disclaimer

These scripts make significant changes to your system settings and install software. Please review the scripts and understand the changes they will make before running them. It's recommended to run these scripts on a fresh macOS installation or to backup your system before running them on an existing setup.

## Contributing

This is a personal project, but suggestions and improvements are welcome. Feel free to fork the repository and submit pull requests.

## License

This project is open-source and available under the [MIT License](LICENSE).