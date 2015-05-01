# dotfiles

This repository is a collection of my own personal dotfiles, for setting a new machine up exactly how I like it. Over the years it became more and more annoying to set a new machine up so why not automate the process?

Roughly, the `install.sh` script achieves the following:

- Change shell to ZSH
- Create symlinks to the various dotfiles, backing up old files if they already exist
- Install my zsh theme
- Run `NeoBundleInstall` to install vim packages
- Install [Alcatraz](https://github.com/supermarin/Alcatraz) for Xcode
- Install [Homebrew](http://brew.sh/) with [Cask](http://caskroom.io/) support
- Install brews
- Install [CocoaPods](https://cocoapods.org/) [Ruby gem](https://rubygems.org/)
- Install [Powerline fonts](https://github.com/powerline/fonts/)
- Write a bunch of OS X preference settings

## Installation

Ensure you have installed at least the [command line developer tools](https://developer.apple.com/downloads/index.action). Ideally, you should have Xcode installed.

You are free to clone the repository anywhere you wish.

```bash
$ git clone --recursive https://github.com/squarefrog/dotfiles.git
$ cd dotfiles
$ ./install.sh
```

## Adding custom settings

You may add your own customisations by appending the dotfile name with `.local`.

* `~/.aliases.local`
* `~/.gitconfig.local`
* `~/.gitconfig_global.local`
* `~/.gvimrc.local`
* `~/.profile.local`
* `~/.shellrc.local`
* `~/.tmux.conf.local`
* `~/.vimrc.local`
* `~/.vimrc.bundles.local`
* `~/.zshrc.local`

As an example, your `~/.gitconfig.local` file might look like this:

```
[user]
  name = Frank Ozwald
  email = frank.oz@example.com
```

## Resources
My setup was cherry picked from several other dotfile repositories.
* [dotfiles.github.io](http://dotfiles.github.io/)
* [atomantic](https://github.com/atomantic/dotfiles)
* [Ted Kulp](https://github.com/tedkulp/vim-config)
* [Mathias Bynens](https://github.com/mathiasbynens/dotfiles/)
* [Keithbsmiley](https://github.com/Keithbsmiley/dotfiles)
* [thoughtbot](https://github.com/thoughtbot/dotfiles)
