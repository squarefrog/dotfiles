#!/usr/bin/env bash

###########################
# This script installs the dotfiles and runs all other system configuration scripts
# @author Adam Eivy
###########################


# include my library helpers for colorized echo and require_brew, etc
source ./lib.sh

# make a backup directory for overwritten dotfiles
if [[ ! -e ~/.dotfiles_backup ]]; then
    mkdir ~/.dotfiles_backup
fi

bot "Hello! Let's rock!"

echo $0 | grep zsh > /dev/null 2>&1 | true
if [[ ${PIPESTATUS[0]} != 0 ]]; then
	running "changing your login shell to zsh"
	chsh -s $(which zsh);ok
else
	bot "Looks like you are already using zsh. woot!"
fi

pushd ~ > /dev/null 2>&1

function symlinkifne {
    running "$1"

    if [[ -e $1 ]]; then
        # file exists
        if [[ -L $1 ]]; then
            # it's already a simlink (could have come from this project)
            echo -en '\tsimlink exists, skipped\t';ok
            return
        fi
        # backup file does not exist yet
        if [[ ! -e ~/.dotfiles_backup/$1 ]];then
            mv $1 ~/.dotfiles_backup/
            echo -en 'backed up saved...';
        fi
    fi
    # create the link
    ln -s ~/git/dotfiles/$1 $1
    echo -en 'linked';ok
}

bot "Creating symlinks for project dotfiles..."
symlinkifne .aliases
symlinkifne .bashrc
symlinkifne .gemrc
symlinkifne .gitconfig
symlinkifne .gitignore_global
symlinkifne .gvimrc
symlinkifne .profile
symlinkifne .shellrc
symlinkifne .tmux.conf
symlinkifne .vimrc
symlinkifne .vimrc.bundles
symlinkifne .xvimrc
symlinkifne .zshrc

if [[ -f $HOME/.shellrc ]];then
  source "$HOME/.shellrc"
else
  warn ".shellrc file doesn't exist :("
fi

ZSHTHEME="$DOTFILES/oh-my-zsh/custom/themes/squarefrog.zsh-theme"
if [[ ! -e $ZSHTHEME ]]; then
  bot "Installing awesome zsh theme..."
  mkdir -p $DOTFILES/oh-my-zsh/custom/themes
  ln -s $DOTFILES/themes/squarefrog.zsh-theme $ZSHTHEME
else
  bot "Zsh theme already linked"
fi

THEME_NAME="tomorrow-night-xcode.dvtcolortheme"
XCODETHEMES_DIR="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
if [[ ! -e "$XCODETHEMES_DIR/$THEME_NAME" ]]; then
  bot "Installing Tomorrow Night Xcode theme..."
  if [[ ! -d "$XCODETHEMES_DIR" ]]; then
    mkdir -p $XCODETHEMES_DIR
  fi
  ln -s "$DOTFILES/themes/$THEME_NAME" "$XCODETHEMES_DIR/$THEME_NAME"
else
  bot "Xcode theme already installed"
fi

if [[ -d "$HOME/.vim/bundle/neobundle.vim" ]]; then
  bot "Updating vim packages..."
  cd $HOME/.vim/bundle/neobundle.vim
  git pull origin master > /dev/null 2>&1
  cd $DOTFILES
  vim -c "NeoBundleInstall!" -c "qa!"
else
  bot "Installing neobundle.vim..."
  if [ ! -d "$HOME/.vim/bundle" ]; then
    mkdir -p $HOME/.vim/bundle
  fi
  git clone https://github.com/Shougo/neobundle.vim.git $HOME/.vim/bundle/neobundle.vim > /dev/null 2>&1
  vim -c "NeoBundleInstall!" -c "qa!"
fi

PLUGIN_PATH="${HOME}/Library/Application Support/Developer/Shared/Xcode/Plug-ins/Alcatraz.xcplugin"
if [[ ! -d $PLUGIN_PATH ]]; then
  bot "Installing Alcatraz..."
  curl -fsSL https://raw.githubusercontent.com/supermarin/Alcatraz/master/Scripts/install.sh | sh > /dev/null 2>&1
else
  bot "Alcatraz already installed"
fi

popd > /dev/null 2>&1

./osx.sh

bot "Woot! All done."
