# dotfiles

## Installation in OS X

Ensure you have installed at least the [command line developer tools](https://developer.apple.com/downloads/index.action). Ideally, you should have Xcode installed.

You are free to clone the repository anywhere you wish.

```
git clone git://github.com/squarefrog/dotfiles.git && cd dotfiles/osx
./bootstrap.sh COMPUTER_NAME
```

## Adding custom settings

If an `extra` file exists, it will be symlinked along with all the other files. This is an ideal place for any commands that should not be checked in. For example, your `extra` file could contain your git credentials.

```
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
GIT_AUTHOR_NAME="John Smith"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="john.smith@example.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

## OS X defaults

A multitude of OS X preferences can be installed by calling the defaults bash script:

```sh
cd osx
./.osx
```

## Install Homebrew formulae

You can use a Brewfile to set up any required [Homebrew](http://brew.sh/) formulae:

```sh
brew bundle $DOTFILES/osx/Brewfile
```

## Install native apps with `brew cask`

You could also install native apps with [`brew cask`](https://github.com/caskroom/homebrew-cask):

```sh
brew bundle $DOTFILES/osx/Caskfile
```

