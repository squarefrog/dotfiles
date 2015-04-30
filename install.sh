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

bot "Hi. I'm going to setup your system for you. But first, I need to configure this project based on your info so you don't check in files to GitHub as Paul Williamson from here on out :)"

#fullname=`osascript -e "long user name of (system info)"`

#lastname=`dscl . -read /Users/$(whoami) | grep LastName | sed "s/LastName: //"`
#firstname=`dscl . -read /Users/$(whoami) | grep FirstName | sed "s/FirstName: //"`
#email=`dscl . -read /Users/$(whoami)  | grep EMailAddress | sed "s/EMailAddress: //"`

#if [[ ! "$firstname" ]];then
  #response='n'
#else
  #echo -e "I see that your full name is $COL_YELLOW$firstname $lastname$COL_RESET"
  #read -r -p "Is this correct? [Y|n] " response
#fi

#if [[ $response =~ ^(no|n|N) ]];then
	#read -r -p "What is your first name? " firstname
	#read -r -p "What is your last name? " lastname
#fi
#fullname="$firstname $lastname"

#bot "Great $fullname, "

#if [[ ! $email ]];then
  #response='n'
#else
  #echo -e "The best I can make out, your email address is $COL_YELLOW$email$COL_RESET"
  #read -r -p "Is this correct? [Y|n] " response
#fi

#if [[ $response =~ ^(no|n|N) ]];then
	#read -r -p "What is your email? " email
#fi

#read -r -p "What is your github.com username? " githubuser

#running "replacing items in .gitconfig with your info ($COL_YELLOW$fullname, $email, $githubuser$COL_RESET)"

#test if gnu-sed or osx sed

#sed -i 's/Adam Eivy/'$firstname' '$lastname'/' .gitconfig > /dev/null 2>&1 | true
#if [[ ${PIPESTATUS[0]} != 0 ]]; then
  #echo
  #running "looks like you are using OSX sed rather than gnu-sed, accommodating"
  #sed -i '' 's/Adam Eivy/'$firstname' '$lastname'/' .gitconfig;
  #sed -i '' 's/adam.eivy@disney.com/'$email'/' .gitconfig;
  #sed -i '' 's/atomantic/'$githubuser'/' .gitconfig;
  #sed -i '' 's/antic/'$(whoami)'/g' .zshrc;ok
#else
  #echo
  #bot "looks like you are already using gnu-sed. woot!"
  #sed -i 's/adam.eivy@disney.com/'$email'/' .gitconfig;
  #sed -i 's/atomantic/'$githubuser'/' .gitconfig;
  #sed -i 's/antic/'$(whoami)'/g' .zshrc;ok
#fi

echo $0 | grep zsh > /dev/null 2>&1 | true
if [[ ${PIPESTATUS[0]} != 0 ]]; then
	running "changing your login shell to zsh"
	chsh -s $(which zsh);ok
else
	bot "looks like you are already using zsh. woot!"
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

bot "creating symlinks for project dotfiles..."
symlinkifne .aliases
symlinkifne .bashrc
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
  bot "installing awesome zsh theme..."
  mkdir -p $DOTFILES/oh-my-zsh/custom/themes
  ln -s $DOTFILES/themes/squarefrog.zsh-theme $ZSHTHEME
else
  bot "zsh theme already linked"
fi

if [[ -d "$HOME/.vim/bundle/neobundle.vim" ]]; then
  bot "updating vim packages..."
  cd $HOME/.vim/bundle/neobundle.vim
  git pull origin master > /dev/null 2>&1
  cd $DOTFILES
  vim -c "NeoBundleInstall!" -c "qa!"
else
  bot "installing neobundle.vim..."
  if [ ! -d "$HOME/.vim/bundle" ]; then
    mkdir -p $HOME/.vim/bundle
  fi
  git clone https://github.com/Shougo/neobundle.vim.git $HOME/.vim/bundle/neobundle.vim > /dev/null 2>&1
  vim -c "NeoBundleInstall!" -c "qa!"
fi

PLUGIN_PATH="${HOME}/Library/Application Support/Developer/Shared/Xcode/Plug-ins/Alcatraz.xcplugin"
if [[ ! -d $PLUGIN_PATH ]]; then
  bot "installing Alcatraz..."
  curl -fsSL https://raw.githubusercontent.com/supermarin/Alcatraz/master/Scripts/install.sh | sh > /dev/null 2>&1
else
  bot "Alcatraz already installed"
fi

popd > /dev/null 2>&1

#./osx.sh

bot "Woot! All done."
