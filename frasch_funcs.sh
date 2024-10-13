#!/bin/bash

# set to abort script after any error
set -e

function install_oh_my_zsh() {
  # Check if Oh My Zsh is installed
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "🟢 Oh My Zsh is already installed."
    return
  fi

  # download and run the Oh My Zsh installation script
  echo "🔨 Oh My Zsh is not installed. Installing Oh My Zsh."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  if [ $? -ne 0 ]; then
    echo "🔴 Oh My Zsh installation failed."
    exit 1
  fi
  echo "✅ Oh My Zsh installed."
}