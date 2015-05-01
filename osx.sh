#!/usr/bin/env bash

# A heavily modified version of Mathias Bynens excellent .osx file.
# ~/.osx — http://mths.be/osx
# To find the defaults key, read the following
# https://github.com/mathiasbynens/dotfiles/issues/5#issuecomment-4117712

# include library helpers for colorized echo and require_brew, etc
source ./lib.sh

bot "I need your sudo password to install defaults:"
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

bot "OK, lets roll..."


###############################################################################
# Install homebrew
###############################################################################

running "checking homebrew install"
brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  action "installing homebrew"
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
  if [[ $? != 0 ]]; then
    error "unable to install homebrew, script $0 abort!"
    exit -1
  fi
fi
ok

running "checking brew-cask install"
output=$(brew tap | grep cask)
if [[ $? != 0 ]]; then
  action "installing brew-cask"
  require_brew caskroom/cask/brew-cask
fi
ok

# Make sure we are using the latest Homebrew
running "updating homebrew"
brew update 2>&1 > /dev/null
ok

bot "Before installing brew packages, we can upgrade any outdated packages."
read -r -p "run brew upgrade? [y|N] " response
if [[ $response =~ ^(y|yes|Y) ]];then
  # Upgrade any already-installed formulae
  action "upgrade brew packages..."
  brew upgrade -all
  ok "brews updated..."
else
  ok "skipped brew package upgrades.";
fi


###############################################################################
# Native Apps (via brew cask)
###############################################################################

bot "Installing homebrew command-line tools"

require_brew gnu-sed --with-default-names
require_brew mogenerator
require_brew python
require_brew reattach-to-user-namespace
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
#require_cask gitx-rowanj
#require_cask google-chrome
#require_cask iterm2
#require_cask macvim
#require_cask onepassword
#require_cask spotify
#require_cask teensy
#require_cask vlc

bot "Alright, cleaning up homebrew cache..."
# Remove outdated versions from the cellar
brew cleanup > /dev/null 2>&1
bot "All clean"


###############################################################################
bot "Installing Ruby Gems..."
###############################################################################

require_gem cocoapods


###############################################################################
bot "Installing Fonts..."
###############################################################################

FONTS_DIR="$HOME/Library/Fonts"
INCONSOLATA_LOC="$FONTS_DIR/Inconsolata-Powerline.otf"
if [[ ! -e $INCONSOLATA ]]; then
  running "installing Inconsolata for Powerline"
  if [[ ! -d "$FONTS_DIR" ]]; then
    mkdir -p $FONTS_DIR
  fi
  ln -s $DOTFILES/fonts/Inconsolata-Powerline.otf $INCONSOLATA_LOC;ok
else
  bot "Inconsolata for Powerline already installed"
fi

INCONSOLATADZ_LOC="$FONTS_DIR/Inconsolata-dz-Powerline.otf"
if [[ ! -e $INCONSOLATA ]]; then
  running "installing Inconsolata-dz for Powerline"
  ln -s $DOTFILES/fonts/Inconsolata-dz-Powerline.otf $INCONSOLATADZ_LOC;ok
else
  bot "Inconsolata for Powerline-dz already installed"
fi


###############################################################################
bot "Configuring General System UI/UX..."
##############################################################################

running "Show fast user switching menu as: icon"
defaults write -g userMenuExtraStyle -int 2;ok

running "Set standby delay to 24 hours (default is 1 hour)"
sudo pmset -a standbydelay 86400;ok

running "Menu bar: disable transparency"
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false;ok

running "Menu bar: hide the Time Machine, Volume, and User icons"
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
  defaults write "${domain}" dontAutoLoad -array \
    "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
    "/System/Library/CoreServices/Menu Extras/Volume.menu" \
    "/System/Library/CoreServices/Menu Extras/User.menu"
done
ok

running "Always show scrollbars"
# Possible values: `WhenScrolling`, `Automatic` and `Always`
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling";ok

running "Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true;ok

running "Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true;ok

running "Save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false;ok

running "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true;ok

running "Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false;ok

running "Set Help Viewer windows to non-floating mode"
defaults write com.apple.helpviewer DevMode -bool true;ok

running "Restart automatically if the computer freezes"
sudo systemsetup -setrestartfreeze on;ok

running "Disable smart quotes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false;ok

running "Disable smart dashes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false;ok

running "Configuring sleep settings"
# From https://github.com/rtrouton/rtrouton_scripts/
IS_LAPTOP=`/usr/sbin/system_profiler SPHardwareDataType | grep "Model Identifier" | grep "Book"`
if [[ "$IS_LAPTOP" != "" ]]; then
  sudo pmset -b sleep 15 disksleep 10 displaysleep 5 halfdim 1
  sudo pmset -c sleep 180 disksleep 10 displaysleep 20 halfdim 1
else
  sudo pmset sleep 180 disksleep 10 displaysleep 20 halfdim 1
fi
ok

running "Disable feedback when volume changes"
defaults write -g com.apple.sound.beep.feedback -boolean NO;ok


###############################################################################
bot "Configuring App Store"
###############################################################################

running "Automatically check for updates"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool YES;ok

running "Automatically download updates in the background"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool YES;ok

running "Automatically install purchases from other computers"
#sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall -bool YES;ok

running "Automatically install critical updates"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool YES;ok

running "Don't automatically restart after updates"
sudo defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdateRestartRequired -bool YES;ok
sudo defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdateRestartRequired -bool NO;ok

running "Automatically update apps"
sudo defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdate -bool YES;ok


###############################################################################
#bot "Configuring SSD-specific tweaks"
###############################################################################

#running "Disable local Time Machine snapshots"
#sudo tmutil disablelocal;ok

#running "Disable hibernation (speeds up entering sleep mode)"
#sudo pmset -a hibernatemode 0;ok

#running "Remove the sleep image file to save disk space"
#sudo rm /Private/var/vm/sleepimage;ok

#running "Create a zero-byte file instead…"
#sudo touch /Private/var/vm/sleepimage;ok

#running "…and make sure it can’t be rewritten"
#sudo chflags uchg /Private/var/vm/sleepimage;ok

#running "Disable the sudden motion sensor as it’s not useful for SSDs"
#sudo pmset -a sms 0;ok


###############################################################################
bot "Trackpad, mouse, keyboard, Bluetooth accessories, and input"
###############################################################################

running "Trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1;ok

running "Trackpad: map bottom right corner to right-click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true;ok

running "Trackpad: three finger drag"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0;ok

running "Mouse: Enable middle and right-click"
defaults write com.apple.driver.AppleHIDMouse Button2 -int 2
defaults write com.apple.driver.AppleHIDMouse Button3 -int 3;ok

running "Disable “natural” (Lion-style) scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false;ok

running "Increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40;ok

running "Enable full keyboard access for all controls"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3;ok

running "Use scroll gesture with the Ctrl (^) modifier key to zoom"
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144;ok

running "Follow the keyboard focus while zoomed in"
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true;ok

running "Disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false;ok

running "Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 0;ok

running "Set language and text formats (en_GB)"
# Note: if you’re in the US, replace `GBP` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=GBP"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true;ok

running "Set the timezone; see 'systemsetup -listtimezones' for other values"
systemsetup -settimezone "Europe/London" > /dev/null;ok

running "Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false;ok


###############################################################################
bot "Configuring the Screen"
###############################################################################

running "Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 5;ok

running "Save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop";ok

running "Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png";ok

running "Disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true;ok

running "Enable subpixel font rendering on non-Apple LCDs"
# Yosemite looks awful with this set to 2, so try 1 instead
defaults write NSGlobalDomain AppleFontSmoothing -int 1;ok


###############################################################################
bot "Configuring Finder"
###############################################################################

running "Finder: disable window animations and Get Info animations"
defaults write com.apple.finder DisableAllAnimations -bool true;ok

running "Show icons for external hard drives and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
#defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
#defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true;ok

#running "Finder: show hidden files by default"
#defaults write com.apple.finder AppleShowAllFiles -bool true;ok

#running "Finder: show all filename extensions"
#defaults write NSGlobalDomain AppleShowAllExtensions -bool true;ok

running "Finder: show status bar"
defaults write com.apple.finder ShowStatusBar -bool true;ok

running "Finder: allow text selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool true;ok

running "When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf";ok

running "Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false;ok

running "Enable spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true;ok

running "Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true;ok

running "Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true;ok

running "Use list view in all Finder windows by default"
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv";ok

running "Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false;ok

running "Enable AirDrop over Ethernet and on unsupported Macs running Lion"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true;ok

running "Show the ~/Library folder"
chflags nohidden ~/Library;ok

running "Expand the following File Info panes: “General”, “Open with”, and “Sharing & Permissions”"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true;ok


###############################################################################
bot "Dock, Dashboard, and hot corners"
###############################################################################

running "Set the icon size of Dock items to 48 pixels"
defaults write com.apple.dock tilesize -int 48;ok

running "Enable spring loading for all Dock items"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true;ok

running "Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true;ok

running "Removing app icons from the Dock"
defaults write com.apple.dock persistent-apps -array "";ok

running "Speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.2;ok

running "Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true;ok

running "Don’t show Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -bool true;ok

running "Don’t automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false;ok

running "Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true;ok

running "Make Dock icons of hidden applications translucent"
defaults write com.apple.dock showhidden -bool true;ok

running "Add iOS Simulator to Launchpad"
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

running "Top left screen corner → Mission Control"
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0;ok

running "Top right screen corner → Desktop"
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0;ok

running "Bottom left screen corner → Application Windows"
defaults write com.apple.dock wvous-bl-corner -int 3
defaults write com.apple.dock wvous-bl-modifier -int 0;ok

running "Bottom right screen corner → Sleep Display"
defaults write com.apple.dock wvous-br-corner -int 10
defaults write com.apple.dock wvous-br-modifier -int 0;ok


###############################################################################
bot "Configuring Safari & WebKit"
###############################################################################

running "Set Safari’s home page to 'about:blank' for faster loading"
defaults write com.apple.Safari HomePage -string "about:blank";ok

running "Prevent Safari from opening ‘safe’ files automatically after downloading"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false;ok

running "Allow hitting the Backspace key to go to the previous page in history"
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true;ok

running "Hide Safari’s bookmarks bar by default"
defaults write com.apple.Safari ShowFavoritesBar -bool false;ok

running "Hide Safari’s sidebar in Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false;ok

running "Disable Safari’s thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2;ok

running "Enable Safari’s debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true;ok

running "Make Safari’s search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false;ok

running "Remove useless icons from Safari’s bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()";ok

running "Enable the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true;ok

running "Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true;ok


###############################################################################
bot "Configuring Mail"
###############################################################################

running "Disable send and reply animations in Mail.app"
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true;ok

running "Copy email addresses as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false;ok

running "Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app"
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" -string "@\\U21a9";ok

#running "Display emails in threaded mode, sorted by date (oldest at the top)"
#defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
#defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
#defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date";ok

running "Disable automatic spell checking"
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled";ok


###############################################################################
bot "Configuring Spotlight"
###############################################################################

running "Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed before."
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes";ok

running "Change indexing order and disable some file types"
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

running "Load new settings before rebuilding the index"
killall mds > /dev/null 2>&1;ok

running "Make sure indexing is enabled for the main volume"
sudo mdutil -i on / > /dev/null;ok

running "Allow spotlight for system files"
defaults write com.apple.finder SlicesRootAttributes -array-add \
  kMDItemFSInvisible \
  com_apple_SearchSystemFilesAttribute;ok

#running "Rebuild the index from scratch"
#sudo mdutil -E / > /dev/null;ok


###############################################################################
bot "Configuring Terminal & iTerm 2"
###############################################################################

running "Only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4;ok

running "Use Tomorrow Night theme by default in Terminal.app"
open "${DOTFILES}/themes/TomorrowNight.terminal"
sleep 1 # Wait a bit to make sure the theme is loaded
defaults write com.apple.terminal "Default Window Settings" -string "TomorrowNight"
defaults write com.apple.terminal "Startup Window Settings" -string "TomorrowNight";ok

running "Use Tomorrow Night theme in iTerm"
open "${DOTFILES}/themes/TomorrowNight.itermcolors";ok

running "Don’t display the annoying prompt when quitting iTerm"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false;ok


###############################################################################
bot "Configuring Xcode"
###############################################################################

running "Open file in new tab when double-clicked"
defaults write com.apple.dt.Xcode IDEEditorCoordinatorTarget_DoubleClick "SeparateTab";ok

running "Show line numbers"
defaults write com.apple.dt.Xcode DVTTextShowLineNumbers 1;ok

running "Show line guide at 80 characters"
defaults write com.apple.dt.Xcode DVTTextShowPageGuide 1;ok

running "Set Xcode theme"
defaults write com.apple.dt.Xcode DVTFontAndColorCurrentTheme "tomorrow-night-xcode.dvtcolortheme";ok


###############################################################################
bot "Configuring Time Machine"
###############################################################################

running "Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true;ok

#running "Disable local Time Machine backups"
#hash tmutil &> /dev/null && sudo tmutil disablelocal;ok


###############################################################################
bot "Configuring Activity Monitor"
###############################################################################

running "Show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true;ok

running "Visualize CPU usage in the Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5;ok

running "Show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0;ok

running "Sort Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0;ok


###############################################################################
bot "Configuring Address Book, Dashboard, iCal, TextEdit, and Disk Utility"
###############################################################################

running "Use plain text mode for new TextEdit documents"
defaults write com.apple.TextEdit RichText -int 0;ok

running "Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4;ok

running "Enable the debug menu in Disk Utility"
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true;ok


###############################################################################
bot "Configuring Messages"
###############################################################################

running "Disable continuous spell checking"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false;ok


###############################################################################
# Kill affected applications                                                  #
###############################################################################

bot "OK. No. Note that some of these changes require a logout/restart to take effect. Killing affected applications (so they can reboot)...."

for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" \ "Terminal" ; do
  killall "${app}" > /dev/null 2>&1
done
