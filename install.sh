#!/usr/bin/env bash

{ # this ensures the entire script is downloaded #

install_brew() {
  echo "Installing Homebrew and packages..."
  echo "Verifying if you have Homebrew installed."
  
  if [ "$(uname)" == "Darwin" ]; then
    echo "You're running it from macOS."
    if [ ! "$(command -v brew)" ]; then
      echo "You don't have brew installed yet, so, let's install it."
      echo "It could ask for your password a few times."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null 2>&1
    fi
    
    echo "Adding taps for fonts and old versions of apps.."
    brew tap homebrew/cask-fonts > /dev/null 2>&1
    brew tap homebrew/cask-versions > /dev/null 2>&1
    brew install --cask font-jetbrains-mono-nerd-font iterm2 > /dev/null 2>&1

    read -p "Do you want to install your most used apps? (Discord, Firefox, VSCodium and so on.) [Y/n] " XCODE
    if [ "$XCODE" == "y" ] || [ "$XCODE" == "Y" ]; then
      echo "Installing your most used tools and apps, please wait."
      brew install aria2 exa htop wget > /dev/null 2>&1
      brew install --cask discord dropbox firefox-developer-edition font-open-sans keka the-unarchiver telegram vscodium > /dev/null 2>&1
    fi
    
  elif [ "$(uname -s | cut -b 1-5)" == "Linux" ]; then
    echo "You're running it from Linux."
    if [ "$(command -v curl)" ]; then
      curl -o /tmp/font.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip > /dev/null 2>&1
      unzip /tmp/font.zip -d /tmp > /dev/null 2>&1
      mv /tmp/*.ttf "$HOME"/.fonts > /dev/null 2>&1
      rm -rf /tmp/font.zip > /dev/null 2>&1
      fc-cache -f -v > /dev/null 2>&1
    fi
  fi
}

install_nvm() {
  if [ ! "$(command -v nvm)" ]; then
    echo "Installing nvm..."
    rm -rf "$HOME"/.nvm > /dev/null 2>&1
    git clone https://github.com/nvm-sh/nvm.git "$HOME"/.nvm > /dev/null 2>&1
  else
    echo "You already have nvm installed on your system."
  fi
}

install_omz() {
  if [ ! "$(command -v zsh)" ]; then
    echo "You don't have zsh shell installed. Aborting."
    exit 1
  else
    echo "Removing old zsh and oh-my-zsh files before installation."
    rm -f "$HOME"/.zshrc* > /dev/null 2>&1
    rm -rf "$HOME"/.oh-my-zsh > /dev/null 2>&1
    rm -f "$HOME"~/.p10k.zsh > /dev/null 2>&1
    
    echo "Installing oh-my-zsh..."
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME"/.oh-my-zsh > /dev/null 2>&1

    echo "Installing powerlevel10k zsh theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME"/.oh-my-zsh/custom/themes/powerlevel10k > /dev/null 2>&1
  fi
}

configure_dotfiles() {
  echo "Configuring your Dotfiles..."
  rm -f "$HOME"/.gitconfig* > /dev/null 2>&1
  rm -rf "$HOME"/.git-template > /dev/null 2>&1
  rm -f "$HOME"~/.p10k.zsh > /dev/null 2>&1

  if [ -d "$HOME"/.config ]; then
    git clone https://github.com/felipemeamaral/dotfiles.git "$HOME"/.config/dotfiles > /dev/null 2>&1
    ln -s "$HOME"/.config/dotfiles/git/gitconfig "$HOME"/.gitconfig > /dev/null 2>&1
    mkdir -p "$HOME"/.git-template > /dev/null 2>&1
    ln -s "$HOME"/.config/dotfiles/git/HEAD "$HOME"/.git-template/HEAD > /dev/null 2>&1
    cp "$HOME"/.config/dotfiles/colors/colors /usr/local/bin > /dev/null 2>&1
    chmod +x /usr/local/bin/colors > /dev/null 2>&1
    cp "$HOME"/.config/dotfiles/zsh/zshrc "$HOME"/.zshrc > /dev/null 2>&1
    cp "$HOME"/.config/dotfiles/zsh/p10k.zsh "$HOME"/.p10k.zsh > /dev/null 2>&1
    
    # iTerm2
    defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$HOME/.config/dotfiles/iterm2" > /dev/null 2>&1
  else
    git clone https://github.com/felipemeamaral/dotfiles.git "$HOME"/.config > /dev/null 2>&1
    ln -s "$HOME"/.config/git/gitconfig "$HOME"/.gitconfig > /dev/null 2>&1
    mkdir -p "$HOME"/.git-template > /dev/null 2>&1
    ln -s "$HOME"/.config/git/HEAD "$HOME"/.git-template/HEAD > /dev/null 2>&1
    cp "$HOME"/.config/dotfiles/colors/colors /usr/local/bin > /dev/null 2>&1
    chmod +x /usr/local/bin/colors > /dev/null 2>&1
    cp "$HOME"/.config/zsh/zshrc "$HOME"/.zshrc > /dev/null 2>&1
    cp "$HOME"/.config/zsh/p10k.zsh "$HOME"/.p10k.zsh > /dev/null 2>&1
    
    # iTerm2
    defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$HOME/.config/iterm2" > /dev/null 2>&1
    fi
    touch ~/.hushlogin > /dev/null 2>&1
}

configure_environment() {
  if [ "$(uname)" == "Darwin" ]; then
    echo "Setting System Variables and Configurations..."

    # Safari
    defaults write com.apple.Safari IncludeInternalDebugMenu -bool true > /dev/null 2>&1
    defaults write com.apple.Safari IncludeDevelopMenu -bool true > /dev/null 2>&1
    defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true > /dev/null 2>&1
    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true > /dev/null 2>&1
    defaults write NSGlobalDomain WebKitDeveloperExtras -bool true > /dev/null 2>&1

    # TextEdit
    defaults write com.apple.TextEdit RichText -int 0 > /dev/null 2>&1
    defaults write -g NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false > /dev/null 2>&1
    defaults write com.apple.TextEdit NSDocumentSaveNewDocumentsToCloud -bool false > /dev/null 2>&1

    # Dock
    defaults write com.apple.dock scroll-to-open -bool true > /dev/null 2>&1
    defaults write com.apple.dock autohide-delay -int 0 > /dev/null 2>&1
    defaults write com.apple.dock autohide-time-modifier -float 0.5 > /dev/null 2>&1

    # Show Library folder on profile`s folder
    chflags nohidden ~/Library > /dev/null 2>&1

    # Hide icons from Desktop
    defaults write com.apple.finder CreateDesktop false > /dev/null 2>&1

    # Finder
    defaults write com.apple.finder ShowPathbar -bool true > /dev/null 2>&1
    defaults write com.apple.finder ShowStatusBar -bool true > /dev/null 2>&1
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" > /dev/null 2>&1

    # Disable saving files to iCloud automatically
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false > /dev/null 2>&1
    defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1 > /dev/null 2>&1

    # Disable creation of .DS_Store files on USB and Remote folders
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true > /dev/null 2>&1
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true > /dev/null 2>&1

    # Setting pip folder permissions
    chmod -R 755 ~/Library/Caches/pip > /dev/null 2>&1

    # Creating downloads folder structure
    mkdir -p ~/Downloads/Torrent/{Animes,Books,Courses,Games,General,Incomplete,Mac,Movies,Music,Series} > /dev/null 2>&1
  fi
}

install_xcode() {
  if [ "$(uname)" == "Darwin" ]; then
    read -p "Do you want to install Xcode? [Y/n] " XCODE
    if [ "$XCODE" == "y" ] || [ "$XCODE" == "Y" ]; then
      brew install robotsandpencils/made/xcodes > /dev/null 2>&1
      xcodes --generate-completion-script > ~/.oh-my-zsh/plugins/_xcodes > /dev/null 2>&1
      read -p "Which version of Xcode do you want to install? " XCODE_VERSION
      if [ "$XCODE_VERSION" == "" ]; then
        xcodes install --latest
      else
        xcodes install "$XCODE_VERSION"
      fi
    fi
  fi
}

install_vnc() {
  if [ "$(uname)" == "Darwin" ]; then
    echo "Setting up VNC service and password. It'd ask for you root password."
    read -p "Type the password you want to setup for VNC connection: " VNC
    while [ "$VNC" == "" ]; do
      read -p "You forgot to type a password. Type the password you want to setup for VNC connection: " VNC
    done
    echo "It'll define your VNC's password and restart VNC's services, so it'll take a while."
    echo "Now it's time to enter your password to be able to do that."
    #sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate > /dev/null 2>&1
    #sudo defaults write /Library/Preferences/com.apple.RemoteManagement VNCAlwaysStartOnConsole -bool true > /dev/null 2>&1
    #sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all > /dev/null 2>&1
    #sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes > /dev/null 2>&1
    #sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvncpw -vncpw "$VNC" > /dev/null 2>&1
    #sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console > /dev/null 2>&1
  fi
}

sudo_commands() {
  if [ "$(uname)" == "Darwin" ]; then
    echo "Enabling SSH."
    sudo systemsetup -setremotelogin on > /dev/null 2>&1
  fi

  read -p "Do you want to install an ad blocking hosts file? [Y/n] " HOSTS
  if [ "$HOSTS" == "y" ] || [ "$HOSTS" == "Y" ]; then
    echo "Backing up hosts file and installing the adblocker hosts..."
    sudo mv /etc/hosts /etc/hosts.bak > /dev/null 2>&1
    sudo wget -O /tmp/hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts > /dev/null 2>&1
    sudo mv /tmp/hosts /etc/hosts 2>&1
    rm -rf /tmp/hosts > /dev/null 2>&1
    
    echo "Flushing DNS Cache..."
    if [ "$(uname)" == "Darwin" ]; then
      sudo dscacheutil -flushcache > /dev/null 2>&1
      sudo killall -HUP mDNSResponder > /dev/null 2>&1
    
    elif [ -f /etc/redhat-release ]; then
      sudo systemctl restart nscd.service > /dev/null 2>&1

    elif [ -f /etc/lsb-release ]; then
      sudo systemd-resolve --flush-caches > /dev/null 2>&1
      
    else
      sudo service dnsmasq restart > /dev/null 2>&1
    fi
  fi
}

start() {
  install_brew
  install_nvm
  install_omz
  configure_dotfiles
  configure_environment
  install_xcode
  #install_vnc
  sudo_commands
}

start
echo "Job done. Restart your terminal and you're good to go."

} # this ensures the entire script is downloaded #
