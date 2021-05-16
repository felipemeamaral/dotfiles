#!/bin/sh
echo "Installing Homebrew and packages..."
echo "Verifying if you have Homebrew installed"
if [ ! "$(command -v unzip)" ]; then
  echo "You don\'t have it installed yet, so, let\'s install it."
  echo "It could ask for your password a few times."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null 2>&1
fi
echo "Adding taps for fonts and old versions of apps"
brew tap homebrew/cask-fonts > /dev/null 2>&1
homebrew/cask-versions > /dev/null 2>&1
brew install aria2 exa nvm p7zip rclone wget > /dev/null 2>&1
brew install --cask discord dropbox firefox-developer-edition font-jetbrains-mono-nerd-font iterm2 keka lulu the-unarchiver telegram  virtualhere > /dev/null 2>&1

echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>&1

echo "Installing powerlevel10k zsh theme"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k > /dev/null 2>&1

echo "Inslatting nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash > /dev/null 2>&1

echo "Configuring your dotfiles..."
echo "Type your repository password."
git clone https://github.com/pulgalipe/dotfiles ~/.config/ > /dev/null 2>&1
touch ~/.hushlogin > /dev/null 2>&1
mkdir -p ~/Downloads/Torrent/{Animes,Books,Courses,Games,General,Incomplete,Mac,Movies,Music,Series} > /dev/null 2>&1

echo "Setting VNC to hide Desktop"
sudo defaults write /Library/Preferences/com.apple.RemoteManagement VNCAlwaysStartOnConsole -bool true > /dev/null 2>&1

echo "Setting System Variables and Configurations"
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

echo "Enabling SSH"
sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist > /dev/null 2>&1

echo "Backing up hosts file and installing the adblocker hosts"
sudo mv /etc/hosts /etc/hosts.bak > /dev/null 2>&1
sudo wget -O /tmp/hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts > /dev/null 2>&1
sudo cat /tmp/hosts >> /etc/hosts 2>&1
rm -rf /tmp/hosts 2>&1
sudo dscacheutil -flushcache > /dev/null 2>&1
sudo killall -HUP mDNSResponder > /dev/null 2>&1

echo "Setting pip folder permissions..."
chmod -R 755 ~/Library/Caches/pip > /dev/null 2>&1

echo "Open Terminal theme so things will stay as usual."
open ~/.config/terminal/Molokai.terminal > /dev/null 2>&1
echo "Job done. Restart your computer and start using your terminal as always."
