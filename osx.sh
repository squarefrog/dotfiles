#!/usr/bin/env bash

# A heavily modified version of Mathias Bynens excellent .osx file.
# ~/.osx — http://mths.be/osx
# To find the defaults key, read the following
# https://github.com/mathiasbynens/dotfiles/issues/5#issuecomment-4117712

# include library helpers for colorized echo and require_brew, etc
source ./lib.sh

# Set default shell to zsh
echo $0 | grep zsh > /dev/null 2>&1 | true
running "zsh"
if [[ ${PIPESTATUS[0]} != 0 ]]; then
  puts "setting login shell"
	chsh -s $(which zsh);
else
  puts "already set"
fi
ok

running "prezto"
# check if prezto exists?
if [[ -d $DOTFILES/prezto ]]; then
  puts "updating"
else
  puts "cloning"
fi
git submodule update --init --recursive
ok

pushd ~ > /dev/null 2>&1

bot "Creating symlinks for prezto dotfiles"
linkpreztofolder
linkpreztofile zlogin
linkpreztofile zlogout
linkpreztofile zpreztorc
linkpreztofile zprofile
linkpreztofile zshenv
linkpreztofile zshrc

popd > /dev/null 2>&1

bot "Installing OS X specific preferences. Lets roll..."


###############################################################################
# Setup Xcode
###############################################################################

bot "Setting up Xcode"
running "Tomorrow Night"
THEME_NAME="tomorrow-night-xcode.dvtcolortheme"
XCODETHEMES_DIR="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
if [[ ! -e "$XCODETHEMES_DIR/$THEME_NAME" ]]; then
  puts "installing theme"
  if [[ ! -d "$XCODETHEMES_DIR" ]]; then
    mkdir -p $XCODETHEMES_DIR
  fi
  ln -s "$DOTFILES/themes/$THEME_NAME" "$XCODETHEMES_DIR/$THEME_NAME"
  ok
else
  puts "exists, skipping";ok
fi

running "Alcatraz"
PLUGIN_PATH="${HOME}/Library/Application Support/Developer/Shared/Xcode/Plug-ins/Alcatraz.xcplugin"
if [[ ! -d $PLUGIN_PATH ]]; then
  puts "installing"
  curl -fsSL https://raw.githubusercontent.com/supermarin/Alcatraz/master/Scripts/install.sh | sh > /dev/null 2>&1
  ok
else
  puts "exists, skipping";ok
fi


###############################################################################
# Install homebrew
###############################################################################

bot "Homebrew"
running "homebrew"
brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  puts "installing"
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
  if [[ $? != 0 ]]; then
    error "unable to install homebrew, script $0 abort!"
    exit -1
  fi
else
  puts "updating"
  brew update > /dev/null 2>&1
fi
ok

running "brew-cask"
output=$(brew tap | grep cask)
if [[ $? != 0 ]]; then
  puts "installing"
  require_brew caskroom/cask/brew-cask
else
  puts "updating"
  brew upgrade brew-cask > /dev/null 2>&1
fi
ok

bot "Before installing brew packages, we can upgrade any outdated packages."
read -r -p "run brew upgrade? [y|N] " response
if [[ $response =~ ^(y|yes|Y) ]];then
  # Upgrade any already-installed formulae
  running "upgrade brew packages..."
  brew upgrade -all
  ok
else
  ok "skipped brew package upgrades.";
fi


###############################################################################
# Native Apps (via brew cask)
###############################################################################

require_brew ack
require_brew fasd
require_brew git-flow
require_brew mogenerator
require_brew python
require_brew reattach-to-user-namespace
require_brew teensy_loader_cli
require_brew tmux
require_brew tree
require_brew vim --override-system-vi
require_brew xctool


###############################################################################
# Native Apps (via brew cask)
###############################################################################

#bot "Installing GUI tools via homebrew casks..."
#brew tap caskroom/versions > /dev/null 2>&1

#require_cask adium
#require_cask alfred
#require_cask arduino
#require_cask dropbox
#require_cask flux
#require_cask rowanj-gitx
#require_cask google-chrome
#require_cask iterm2
#require_cask macvim
#require_cask onepassword
#require_cask spotify
#require_cask teensy
#require_cask vlc

running "cleaning up homebrew cache"
# Remove outdated versions from the cellar
brew cleanup > /dev/null 2>&1
brew cask cleanup > /dev/null 2>&1
ok


###############################################################################
bot "Installing Ruby Gems..."
###############################################################################

require_gem cocoapods
require_gem fastlane
require_gem xcpretty

running "gem cleanup"
gem cleanup
ok


###############################################################################
bot "Installing Fonts..."
###############################################################################

installfont 'Inconsolata-Powerline.otf'
installfont 'Inconsolata-dz-Powerline.otf'
installfont 'Meslo-LGS-Powerline.otf'


###############################################################################
# Require sudo password to instal system preferences
###############################################################################

bot "I need your sudo password to install system preferences:"
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


###############################################################################
bot "Configuring General System UI/UX..."
##############################################################################

running "show fast user switching menu as: icon"
defaults write -g userMenuExtraStyle -int 2;ok

running "set standby delay to 24 hours (default is 1 hour)"
sudo pmset -a standbydelay 86400;ok

running "menu bar: disable transparency"
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false;ok

running "menu bar: hide the Time Machine, Volume, and User icons"
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
  defaults write "${domain}" dontAutoLoad -array \
    "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
    "/System/Library/CoreServices/Menu Extras/Volume.menu" \
    "/System/Library/CoreServices/Menu Extras/User.menu"
done
ok

running "always show scrollbars"
# Possible values: `WhenScrolling`, `Automatic` and `Always`
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling";ok

running "expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true;ok

running "expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true;ok

running "save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false;ok

running "automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true;ok

running "disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false;ok

running "set Help Viewer windows to non-floating mode"
defaults write com.apple.helpviewer DevMode -bool true;ok

running "restart automatically if the computer freezes"
sudo systemsetup -setrestartfreeze on;ok

running "disable smart quotes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false;ok

running "disable smart dashes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false;ok

running "configuring sleep settings"
# From https://github.com/rtrouton/rtrouton_scripts/
IS_LAPTOP=`/usr/sbin/system_profiler SPHardwareDataType | grep "Model Identifier" | grep "Book"`
if [[ "$IS_LAPTOP" != "" ]]; then
  sudo pmset -b sleep 15 disksleep 10 displaysleep 5 halfdim 1
  sudo pmset -c sleep 180 disksleep 10 displaysleep 20 halfdim 1
else
  sudo pmset sleep 180 disksleep 10 displaysleep 20 halfdim 1
fi
ok

running "disable feedback when volume changes"
defaults write -g com.apple.sound.beep.feedback -boolean NO;ok


###############################################################################
bot "Configuring App Store"
###############################################################################

running "automatically check for updates"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool YES;ok

running "automatically download updates in the background"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool YES;ok

#running "automatically install purchases from other computers"
#sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall -bool YES;ok

running "automatically install critical updates"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool YES;ok

running "don't automatically restart after updates"
sudo defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdateRestartRequired -bool YES
sudo defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdateRestartRequired -bool NO
ok

running "automatically update apps"
sudo defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdate -bool YES;ok


###############################################################################
#bot "Configuring SSD-specific tweaks"
###############################################################################

#running "disable local Time Machine snapshots"
#sudo tmutil disablelocal;ok

#running "disable hibernation (speeds up entering sleep mode)"
#sudo pmset -a hibernatemode 0;ok

#running "remove the sleep image file to save disk space"
#sudo rm /Private/var/vm/sleepimage;ok

#running "create a zero-byte file instead…"
#sudo touch /Private/var/vm/sleepimage;ok

#running "…and make sure it can’t be rewritten"
#sudo chflags uchg /Private/var/vm/sleepimage;ok

#running "disable the sudden motion sensor as it’s not useful for SSDs"
#sudo pmset -a sms 0;ok


###############################################################################
bot "Trackpad, mouse, keyboard, Bluetooth accessories, and input"
###############################################################################

running "trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1;ok

running "trackpad: map bottom right corner to right-click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true;ok

running "trackpad: three finger drag"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0;ok

running "mouse: Enable middle and right-click"
defaults write com.apple.driver.AppleHIDMouse Button2 -int 2
defaults write com.apple.driver.AppleHIDMouse Button3 -int 3;ok

running "disable “natural” (Lion-style) scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false;ok

running "increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40;ok

running "enable full keyboard access for all controls"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3;ok

running "use scroll gesture with the Ctrl (^) modifier key to zoom"
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144;ok

running "follow the keyboard focus while zoomed in"
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true;ok

running "disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false;ok

running "set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 0;ok

running "set language and text formats (en_GB)"
# Note: if you’re in the US, replace `GBP` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=GBP"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true;ok

running "set the timezone; see 'systemsetup -listtimezones' for other values"
systemsetup -settimezone "Europe/London" > /dev/null;ok

running "disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false;ok


###############################################################################
bot "Configuring the Screen"
###############################################################################

running "require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 5;ok

running "save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop";ok

running "save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png";ok

running "disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true;ok

running "enable subpixel font rendering on non-Apple LCDs"
# Yosemite looks awful with this set to 2, so try 1 instead
defaults write NSGlobalDomain AppleFontSmoothing -int 1;ok


###############################################################################
bot "Configuring Finder"
###############################################################################

running "finder: disable window animations and Get Info animations"
defaults write com.apple.finder DisableAllAnimations -bool true;ok

running "show icons for external hard drives and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
#defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
#defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true;ok

#running "finder: show hidden files by default"
#defaults write com.apple.finder AppleShowAllFiles -bool true;ok

#running "finder: show all filename extensions"
#defaults write NSGlobalDomain AppleShowAllExtensions -bool true;ok

running "finder: show status bar"
defaults write com.apple.finder ShowStatusBar -bool true;ok

running "finder: allow text selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool true;ok

running "when performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf";ok

running "disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false;ok

running "enable spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true;ok

running "avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true;ok

running "disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true;ok

running "use list view in all Finder windows by default"
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv";ok

running "disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false;ok

running "enable AirDrop over Ethernet and on unsupported Macs running Lion"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true;ok

running "show the ~/Library folder"
chflags nohidden ~/Library;ok

running "expand File Info panes: “General”, “Open with”, and “Sharing & Permissions”"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true;ok


###############################################################################
bot "Dock, Dashboard, and hot corners"
###############################################################################

running "set the icon size of Dock items to 48 pixels"
defaults write com.apple.dock tilesize -int 48;ok

running "enable spring loading for all Dock items"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true;ok

running "show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true;ok

running "removing app icons from the Dock"
defaults write com.apple.dock persistent-apps -array "";ok

running "speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.2;ok

running "disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true;ok

running "don’t show Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -bool true;ok

running "don’t automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false;ok

running "automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true;ok

running "make Dock icons of hidden applications translucent"
defaults write com.apple.dock showhidden -bool true;ok

running "add iOS Simulator to Launchpad"
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app" "/Applications/iOS Simulator.app";ok

bot "Configuring Hot Corners"
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

running "top left screen corner → Mission Control"
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0;ok

running "top right screen corner → Desktop"
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0;ok

running "bottom left screen corner → Application Windows"
defaults write com.apple.dock wvous-bl-corner -int 3
defaults write com.apple.dock wvous-bl-modifier -int 0;ok

running "bottom right screen corner → Sleep Display"
defaults write com.apple.dock wvous-br-corner -int 10
defaults write com.apple.dock wvous-br-modifier -int 0;ok


###############################################################################
bot "Configuring Safari & WebKit"
###############################################################################

running "set Safari’s home page to 'about:blank' for faster loading"
defaults write com.apple.Safari HomePage -string "about:blank";ok

running "prevent Safari from opening ‘safe’ files automatically after downloading"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false;ok

running "allow hitting the Backspace key to go to the previous page in history"
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true;ok

running "hide Safari’s bookmarks bar by default"
defaults write com.apple.Safari ShowFavoritesBar -bool false;ok

running "hide Safari’s sidebar in Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false;ok

running "disable Safari’s thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2;ok

running "enable Safari’s debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true;ok

running "make Safari’s search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false;ok

running "remove useless icons from Safari’s bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()";ok

running "enable the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true;ok

running "add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true;ok

running "restore windows from last session"
defaults write com.apple.Safari AlwaysRestoreSessionAtLaunch -bool true;ok

running "new windows open with empty page"
defaults write com.apple.Safari NewWindowBehavior -int 1;ok

running "new tabs open with empty page"
defaults write com.apple.Safari NewTabBehavior -int 1;ok


###############################################################################
bot "Configuring Mail"
###############################################################################

running "disable send and reply animations in Mail.app"
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true;ok

running "copy email addresses as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false;ok

running "add the keyboard shortcut ⌘ + Enter to send an email in Mail.app"
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" -string "@\\U21a9";ok

#running "display emails in threaded mode, sorted by date (oldest at the top)"
#defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
#defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
#defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date";ok

running "disable automatic spell checking"
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled";ok


###############################################################################
bot "Configuring Spotlight"
###############################################################################

running "disable Spotlight indexing for any volume that gets mounted and has not yet been indexed before."
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes";ok

running "change indexing order and disable some file types"
defaults write com.apple.spotlight orderedItems -array \
  '{"enabled" = 1;"name" = "APPLICATIONS";}' \
  '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
  '{"enabled" = 1;"name" = "DIRECTORIES";}' \
  '{"enabled" = 1;"name" = "PDF";}' \
  '{"enabled" = 1;"name" = "FONTS";}' \
  '{"enabled" = 0;"name" = "DOCUMENTS";}' \
  '{"enabled" = 0;"name" = "MESSAGES";}' \
  '{"enabled" = 0;"name" = "CONTACT";}' \
  '{"enabled" = 0;"name" = "EVENT_TODO";}' \
  '{"enabled" = 0;"name" = "IMAGES";}' \
  '{"enabled" = 0;"name" = "BOOKMARKS";}' \
  '{"enabled" = 0;"name" = "MUSIC";}' \
  '{"enabled" = 0;"name" = "MOVIES";}' \
  '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
  '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
  '{"enabled" = 0;"name" = "SOURCE";}';ok

running "load new settings before rebuilding the index"
killall mds > /dev/null 2>&1;ok

running "make sure indexing is enabled for the main volume"
sudo mdutil -i on / > /dev/null;ok

running "allow spotlight for system files"
FILESATTRIBUTE="com_apple_SearchSystemFilesAttribute"
if [[ -z $(defaults read com.apple.finder SlicesRootAttributes | grep $FILESATTRIBUTE) ]]; then
defaults write com.apple.finder SlicesRootAttributes -array-add \
  com_apple_SearchSystemFilesAttribute
fi
ok

#running "rebuild the index from scratch"
#sudo mdutil -E / > /dev/null;ok


###############################################################################
bot "Configuring Terminal & iTerm 2"
###############################################################################

running "only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4;ok

running "use Tomorrow Night theme by default in Terminal.app"
if [[ -z $(defaults read com.apple.Terminal "Window Settings" | grep Tomorrow) ]]; then
  open "${DOTFILES}/themes/TomorrowNight.terminal"
  sleep 1 # Wait a bit to make sure the theme is loaded
fi
defaults write com.apple.terminal "Default Window Settings" -string "TomorrowNight"
defaults write com.apple.terminal "Startup Window Settings" -string "TomorrowNight";ok

running "use Tomorrow Night theme in iTerm"
if [[ -z $(defaults read com.googlecode.iterm2 "Custom Color Presets" | grep Tomorrow) ]]; then
  open "${DOTFILES}/themes/TomorrowNight.itermcolors"
fi
ok

running "don’t display the annoying prompt when quitting iTerm"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false;ok

running "set Meslo LG S 13 for iTerm"
/usr/libexec/PlistBuddy -c 'Set :"New Bookmarks":0:"Normal Font" MesloLGS-RegularForPowerline 13' ~/Library/Preferences/com.googlecode.iterm2.plist
/usr/libexec/PlistBuddy -c 'Set :"New Bookmarks":0:"Non Ascii Font" MesloLGS-RegularForPowerline 13' ~/Library/Preferences/com.googlecode.iterm2.plist
ok


###############################################################################
bot "Configuring Xcode"
###############################################################################

running "open file in new tab when double-clicked"
defaults write com.apple.dt.Xcode IDEEditorCoordinatorTarget_DoubleClick "SeparateTab";ok

running "show line numbers"
defaults write com.apple.dt.Xcode DVTTextShowLineNumbers 1;ok

running "show line guide at 80 characters"
defaults write com.apple.dt.Xcode DVTTextShowPageGuide 1;ok

running "set Xcode theme"
defaults write com.apple.dt.Xcode DVTFontAndColorCurrentTheme "tomorrow-night-xcode.dvtcolortheme";ok


###############################################################################
bot "Configuring Time Machine"
###############################################################################

running "prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true;ok

#running "disable local Time Machine backups"
#hash tmutil &> /dev/null && sudo tmutil disablelocal;ok


###############################################################################
bot "Configuring Activity Monitor"
###############################################################################

running "show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true;ok

running "visualize CPU usage in the Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5;ok

running "show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0;ok

running "sort Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0;ok


###############################################################################
bot "Configuring Address Book, Dashboard, iCal, TextEdit, and Disk Utility"
###############################################################################

running "use plain text mode for new TextEdit documents"
defaults write com.apple.TextEdit RichText -int 0;ok

running "open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4;ok

running "enable the debug menu in Disk Utility"
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true;ok


###############################################################################
bot "Configuring Messages"
###############################################################################

running "disable continuous spell checking"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false;ok


###############################################################################
# Kill affected applications                                                  #
###############################################################################

bot "OK. Some of these changes require a logout/restart to take effect. Killing affected applications (so they can reboot)...."

for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" ; do
  killall "${app}" > /dev/null 2>&1
done
