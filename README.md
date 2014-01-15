# Dotfiles

This is going to be a constant work in progress while I get everything set up. Heavily ~~copied~~ _influenced_ by [Ted's custom vim config](https://github.com/tedkulp/vim-config).

## Setup

1. `git clone git://github.com/squarefrog/dotfiles.git`
2. `cd dotfiles`
3. `sh setup.sh`

---
Just need to figure out how to sync packages...


### Command-T

[Command-t](https://github.com/wincent/Command-T) needs manual installation on Mavericks as the default system Ruby version has changed. Thankfully, [Jesper Rasmussen](http://jesperrasmussen.com/2013/11/04/setting-up-command-t-for-macvim-on-os-x-mavericks/) has figured out how to use the old 1.8.7 version of Ruby.

    cd ~/.vim/bundle/command-t/ruby/command-t
    /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby extconf.rb
    make