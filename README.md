# dotfiles

## Getting started

Before installing, you'll almost certainly want to Fork this Repository and customise it to fit your needs.

## Installation in OS X

Ensure you have installed at least the [command line developer tools](https://developer.apple.com/downloads/index.action). Ideally, you should have Xcode installed.

You are free to clone the repository anywhere you wish.

```
git clone git://github.com/squarefrog/dotfiles.git && cd dotfiles/osx
./bootstrap.sh COMPUTER_NAME
```

## Adding custom settings

You may add your own customisations by appending the dotfile name with `.local`.

* `~/.gitconfig.local`
* `~/.vimrc.bundles.local`

As an example, your `~/.gitconfig.local` file might look like this:

```
[user]
  name = Paul Williamson
  email = squarefrog@gmail.com
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

## Resources
My setup was cherry picked from several other dotfile repositories.
* [Ted Kulp](https://github.com/tedkulp/vim-config)
* [Mathias Bynens](https://github.com/mathiasbynens/dotfiles/)
* [Keithbsmiley](https://github.com/Keithbsmiley/dotfiles)
* [dotfiles.github.io](http://dotfiles.github.io/)
* [thoughtbot](https://github.com/thoughtbot/dotfiles)
