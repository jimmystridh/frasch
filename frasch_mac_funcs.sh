#!/bin/bash

function clear_dock_items() {
    local key=$1
    local message=$2
    local cleared_message="🟢 $message are already cleared from the Dock."

    if defaults read com.apple.dock | grep -q "$key = (\\n[^)]"; then
        echo "✅ Clearing $message from the Dock."
        defaults delete com.apple.dock "$key"
    else
        echo "$cleared_message"
    fi
}

function clearRecentApps() {
    clear_dock_items recent-apps "Recent apps"
}

function clearPersistentItems() {
    clear_dock_items persistent-others "Persistent items"
}

function clearPersistentApps() {
    clear_dock_items persistent-apps "Persistent apps"
}

# Function to auto-hide the Dock
function setAutoHideDock() {
    autoHide=$(defaults read com.apple.dock autohide)
    if [ "$autoHide" -eq 0 ]; then
        echo "✅ Setting Dock to auto-hide."
        defaults write com.apple.dock autohide -bool true
    else
        echo "🟢 Dock is already set to auto-hide."
    fi
}

function enableTapToClick() {
    set_defaults com.apple.AppleMultitouchTrackpad Clicking true "bool" "Enabled tap-to-click"
}

function enableThreeFingerDrag() {
    set_defaults com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag true "bool" "Enabled three finger drag"
}

function expand_save_panel_by_default() {
    set_defaults NSGlobalDomain NSNavPanelExpandedStateForSaveMode true "bool" "Expanded the save panel by default"
}

function disable_window_animations() {
    set_defaults NSGlobalDomain NSAutomaticWindowAnimationsEnabled 0 "int" "Disabled automatic window animations"
}

function set_update_frequency() {
    set_defaults com.apple.SoftwareUpdate ScheduleFrequency 1 "int" "Set software update schedule frequency to 1 day"
}

function disable_photos_auto_open() {
    set_defaults com.apple.ImageCapture disableHotPlug true "bool" "Stopped Photos from opening automatically when devices are connected"
}

function show_finder_quit_menu_item() {
    set_defaults com.apple.finder QuitMenuItem true "bool" "Set Finder to show Quit menu item"
    killall Finder
}

function hide_desktop_items() {
    set_defaults com.apple.finder ShowExternalHardDrivesOnDesktop 0 "int" "Set to hide external hard drives on desktop"
    set_defaults com.apple.finder ShowHardDrivesOnDesktop 0 "int" "Set to hide hard drives on desktop"
    set_defaults com.apple.finder ShowMountedServersOnDesktop 0 "int" "Set to hide mounted servers on desktop"
    set_defaults com.apple.finder ShowRemovableMediaOnDesktop 0 "int" "Set to hide removable media on desktop"
}
function skip_diskimage_verification() {
    set_defaults com.apple.frameworks.diskimages skip-verify true "bool" "Set disk image verification to skip"
    set_defaults com.apple.frameworks.diskimages skip-verify-locked true "bool" "Set locked disk image verification to skip"
    set_defaults com.apple.frameworks.diskimages skip-verify-remote true "bool" "Set remote disk image verification to skip"
}

function enable_safari_developer_options() {
    set_defaults com.apple.Safari IncludeInternalDebugMenu 1 "int" "Enabled Safari internal debug menu"
    set_defaults com.apple.Safari IncludeDevelopMenu true "bool" "Enabled Safari develop menu"
    set_defaults com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey true "bool" "Enabled Safari WebKit developer extras"
    set_defaults com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled true "bool" "Enabled Safari WebKit2 developer extras"
    set_defaults NSGlobalDomain WebKitDeveloperExtras true "bool" "Enabled global WebKit developer extras"
}

function set_nvram() {
    local key=$1
    local value=$2
    local changed=false

    sudo nvram "$key" 2>/dev/null | grep -q "$value" || \
    { sudo nvram "$key"="$value"; changed=true; }

    if [ "$changed" = true ]; then
        echo "✅ Set $key to $value."
    else
        echo "🟢 $key is already set to $value."
    fi
}

function disable_boot_sound() {
    set_nvram SystemAudioVolume " "
}

# Function to set the Dock orientation to the bottom
function set_dock_orientation_bottom() {
    # Check if already set to left first
    if defaults read com.apple.dock orientation | grep -q "bottom"; then
        echo "🟢 Dock orientation is already set to bottom."
        return
    fi

    defaults write com.apple.dock orientation -string bottom
    echo "✅ Set Dock orientation to bottom."
}

function set_defaults() {
    local domain=$1
    local key=$2
    local value=$3
    local type=$4
    local message=$5
    local changed=false

    if [ "$type" = "bool" ]; then
        defaults read "$domain" "$key" 2>/dev/null | grep -q "1" || \
        { defaults write "$domain" "$key" -bool "$value"; changed=true; }
    elif [ "$type" = "int" ]; then
        defaults read "$domain" "$key" 2>/dev/null | grep -q "$value" || \
        { defaults write "$domain" "$key" -int "$value"; changed=true; }
    else
        defaults read "$domain" "$key" 2>/dev/null | grep -q "$value" || \
        { defaults write "$domain" "$key" -string "$value"; changed=true; }
    fi

    if [ "$changed" = true ]; then
        echo "✅ $message"
    else
        echo "🟢 $message is already set."
    fi
}

function set_finder_view_style() {
    set_defaults com.apple.finder FXPreferredViewStyle "Nlsv" "string" "Set Finder view style to List view"
}

function set_screensaver_password_delay() {
    set_defaults com.apple.screensaver askForPasswordDelay 60 "int" "Set screensaver password delay to 60 seconds"
}

function set_always_show_scroll_bars() {
    set_defaults NSGlobalDomain AppleShowScrollBars "Always" "string" "Set to always show scroll bars"
}

function set_expanded_save_panel() {
    set_defaults NSGlobalDomain NSNavPanelExpandedStateForSaveMode true "bool" "Set to use expanded save panel"
    set_defaults NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 true "bool" "Set to use expanded save panel nr 2"
}

function enable_close_view_scroll_wheel_toggle() {
    set_defaults com.apple.universalaccess closeViewScrollWheelToggle true "bool" "Enabled close view scroll wheel toggle"
}

function enable_function_keys() {
    set_defaults NSGlobalDomain com.apple.keyboard.fnState 1 "int" "Enabled function keys"
}

function enable_window_switching() {
    # Check if already enabled first
    local enabled=$(/usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:27:enabled" ~/Library/Preferences/com.apple.symbolichotkeys.plist)
    local param0=$(/usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:27:value:parameters:0" ~/Library/Preferences/com.apple.symbolichotkeys.plist)
    local param1=$(/usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:27:value:parameters:1" ~/Library/Preferences/com.apple.symbolichotkeys.plist)
    local param2=$(/usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:27:value:parameters:2" ~/Library/Preferences/com.apple.symbolichotkeys.plist)

    if [ "$enabled" = "true" ] && [ "$param0" -eq 60 ] && [ "$param1" -eq 50 ] && [ "$param2" -eq 1048576 ]; then
        echo "🟢 Window switching with Cmd+< is already enabled."
        return
    fi

    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:27:enabled true" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:27:value:parameters:0 60" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:27:value:parameters:1 50" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:27:value:parameters:2 1048576" ~/Library/Preferences/com.apple.symbolichotkeys.plist

    # Ask the system to read the hotkey plist file and ignore the output. Likely updates an in-memory cache with the new plist values.
    defaults read com.apple.symbolichotkeys.plist > /dev/null

    # Run reactivateSettings to apply the updated settings.
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

    echo "✅ Enabled window switching with Cmd+<."
}

function configure_screenshots() {
    # Save screenshots in png format
    set_defaults com.apple.screencapture type "png" "string" "Set screenshot format to PNG"
    
    # Disable shadow in screenshots
    set_defaults com.apple.screencapture disable-shadow true "bool" "Disabled shadow in screenshots"
        
    # Create Screenshots directory if it doesn't exist
    if [ ! -d "${HOME}/Pictures/Screenshots" ]; then
        mkdir "${HOME}/Pictures/Screenshots"
        echo "✅ Created Screenshots directory"
    else
        echo "🟢 Screenshots directory already exists."
    fi
    
    # Set screenshot location
    set_defaults com.apple.screencapture location "${HOME}/Pictures/Screenshots" "string" "Set screenshot location to ${HOME}/Pictures/Screenshots"
}

function add_ios_simulator_to_launchpad() {
    local source_path="/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
    local target_path="/Applications/Simulator.app"

    if [ ! -L "$target_path" ] || [ "$(readlink "$target_path")" != "$source_path" ]; then
        sudo ln -sf "$source_path" "$target_path"
        echo "✅ Added iOS Simulator to Launchpad"
    else
        echo "🟢 iOS Simulator is already added to Launchpad"
    fi
}

function add_watch_simulator_to_launchpad() {
    local source_path="/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app"
    local target_path="/Applications/Simulator (Watch).app"

    if [ ! -L "$target_path" ] || [ "$(readlink "$target_path")" != "$source_path" ]; then
        sudo ln -sf "$source_path" "$target_path"
        echo "✅ Added Watch Simulator to Launchpad"
    else
        echo "🟢 Watch Simulator is already added to Launchpad"
    fi
}

# Function to install Homebrew
function install_homebrew() {
    # Check if Homebrew is installed
    if [ ! -x "$(command -v brew)" ]; then
        echo "🔨 Homebrew is not installed. Installing Homebrew."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        if [ $? -ne 0 ]; then
            echo "🔴 Homebrew installation failed."
            exit 1
        fi
        echo "✅ Homebrew installed."
    else
        echo "🟢 Homebrew is already installed."
    fi
}

# Function to install Rosetta
function install_rosetta() {
    # Check if the machine is arm64
    if [ "$(uname -m)" = "arm64" ]; then
        # Check if Rosetta is installed
        if ! pkgutil --pkg-info=com.apple.pkg.RosettaUpdateAuto > /dev/null 2>&1; then
            echo "🔨 Rosetta is not installed. Installing Rosetta."
            # Install Rosetta
            softwareupdate --install-rosetta --agree-to-license
            if [ $? -ne 0 ]; then
                echo "🔴 Rosetta installation failed."
                exit 1
            fi
            echo "✅ Rosetta installed."
        else
            echo "🟢 Rosetta is already installed."
        fi
    fi
}

function set_key_repeat_rates() {
    # Get the current values
    # Try to read the InitialKeyRepeat value
    current_initial=$(defaults read -g InitialKeyRepeat 2>/dev/null) || {
        echo "Failed to read InitialKeyRepeat"
        current_initial="0"
    }

    # Try to read the KeyRepeat value
    current_repeat=$(defaults read -g KeyRepeat 2>/dev/null) || {
        echo "Failed to read KeyRepeat"
        current_repeat="0"
    }

    # Check if the current values are already set to the desired ones
    if [ "$current_initial" -eq 15 ] && [ "$current_repeat" -eq 2 ]; then
        echo "🟢 Key repeat rates are already set to the desired values."
        return 0
    fi

    # Set the initial key repeat rate
    defaults write -g InitialKeyRepeat -int 20

    # Check if the operation was successful
    if [ $? -ne 0 ]; then
        echo "🔴 Failed to set InitialKeyRepeat."
        exit 1
    fi

    # Set the key repeat rate
    defaults write -g KeyRepeat -int 2

    # Check if the operation was successful
    if [ $? -ne 0 ]; then
        echo "🔴 Failed to set KeyRepeat."
        exit 1
    fi

    echo "✅ Key repeat rates set successfully."
}

# Function to install oh-my-zsh
function install_oh_my_zsh() {
    # Check if oh-my-zsh is installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "🔨 oh-my-zsh is not installed. Installing oh-my-zsh."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        if [ $? -ne 0 ]; then
            echo "🔴 oh-my-zsh installation failed."
            exit 1
        fi
        echo "✅ oh-my-zsh installed."
    else
        echo "🟢 oh-my-zsh is already installed."
    fi
}

# Function to clone fzf-zsh-plugin if it doesn't exist
function clone_fzf_zsh_plugin() {
    # Define the target directory
    TARGET_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin"
    # Check if the directory exists
    if [ ! -d "$TARGET_DIR" ]; then
        echo "🔨 Directory does not exist. Cloning fzf-zsh-plugin."
        # Clone the repository
        git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git $TARGET_DIR
        if [ $? -ne 0 ]; then
            echo "🔴 Cloning failed."
            exit 1
        fi
        echo "✅ Cloning completed."
    else
        echo "🟢 Directory already exists."
    fi
}

# Function to clone powerlevel10k theme if it doesn't exist
function clone_powerlevel10k_theme() {
    # Define the target directory
    TARGET_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

    # Check if the directory exists
    if [ ! -d "$TARGET_DIR" ]; then
        echo "🔨 Directory does not exist. Cloning powerlevel10k theme."
        # Clone the repository
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $TARGET_DIR
        if [ $? -ne 0 ]; then
            echo "🔴 Cloning failed."
            exit 1
        fi
        echo "✅ Cloning completed."
    else
        echo "🟢 Directory already exists."
    fi
}

# Function to install gh-copilot extension if it doesn't exist
function install_gh_copilot() {
    # Check if the user is logged in to GitHub
    if ! gh auth status >/dev/null 2>&1; then
        echo "🔴 Not logged in to GitHub. Running 'gh auth login'."
        gh auth login
        if [ $? -ne 0 ]; then
            echo "🔴 GitHub login failed."
            exit 1
        fi
    fi

    # Check if the gh-copilot extension is installed
    if ! gh extension list | grep -q "github/gh-copilot"; then
        echo "🔨 gh-copilot is not installed. Installing gh-copilot."
        # Install the extension
        gh extension install github/gh-copilot
        if [ $? -ne 0 ]; then
            echo "🔴 gh-copilot installation failed."
            exit 1
        fi
        echo "✅ gh-copilot installed."
    else
        echo "🟢 gh-copilot is already installed."
    fi
}

function check_and_trust_dotnet_dev_certs() {
    # Check if dotnet is installed
    if ! command -v dotnet &> /dev/null; then
        echo "🔴 .NET Core SDK is not installed. Please install it first."
        exit 1
    fi

    # Check if dev-certs are already trusted
    if ! dotnet dev-certs https --check --trust >/dev/null 2>&1; then
        echo "🔨 .NET Core development certificates are not trusted. Trusting the certificates."
        # Trust the dev-certs
        dotnet dev-certs https --trust
        if [ $? -ne 0 ]; then
            echo "🔴 Trusting .NET Core development certificates failed."
            exit 1
        fi
        echo "✅ .NET Core development certificates trusted."
    else
        echo "🟢 .NET Core development certificates are already trusted."
    fi
}

function set_computer_name() {
    local name="$1"
    if [ -z "$name" ]; then
        echo "🔴 No name provided. Please provide a name as an argument."
        return 1
    fi

    # Check if the name is already set
    if [[ $(scutil --get ComputerName) == "$name" && $(scutil --get HostName) == "$name" && $(scutil --get LocalHostName) == "$name" ]]; then
        echo "🟢 Computer name and hostname are already set to '$name'."
        return 0
    fi

    sudo scutil --set ComputerName "$name"
    sudo scutil --set HostName "$name"
    sudo scutil --set LocalHostName "$name"
    echo "✅ Computer name and hostname set to '$name'."
}





function install_brewfile() {
    # get path to current script
    SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    BREWFILE="$SCRIPT_PATH/Brewfile"

    # Check if brewfile needs installing
    if [ ! -f "$BREWFILE" ]; then
        echo "🔴 Brewfile not found. That's not expected."
        exit 1
    else
        echo "🔨 Brewfile found. Checking for updates."
        brew update

        # Filter all lines starting with vscode from the brewfile
        # since we rely on the vscode settings sync to install
        # vscode extensions.
        TEMP_BREWFILE=$(mktemp)
        grep -v '^vscode' "$BREWFILE" > "$TEMP_BREWFILE"
    
        brew bundle check --file="$TEMP_BREWFILE" || check_result=1

        check_result=${check_result:-0}

        if [ $check_result -ne 0 ]; then
            echo "🔨 Brewfile is outdated. Installing Brewfile."
            brew bundle --file="$TEMP_BREWFILE"
            if [ $? -ne 0 ]; then
                echo "🔴 Brewfile installation failed."
                exit 1
            fi
        fi
    fi
}



