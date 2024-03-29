# yt-dlp is a lot faster than youtube-dl
alias youtube-dl="yt-dlp"

alias be='bundle exec'
alias pi='bundle exec pod install'

# ls
alias la='ls -ahl'

# docker-compose
alias dc='docker-compose'

# git
alias gs='git status'
alias gaa='git add --all'
alias gap='git add -p'
alias gd='git diff'
alias gdc='git diff --cached'
alias gc='git commit -v'
alias gco='git checkout'
alias gcop='git checkout -p'
alias gp='git pull --recurse-submodules'
alias gb='git checkout -b'
alias parent_branch='git show-branch | sed "s/].*//" | grep "\*" | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed "s/^.*\[//"'

# git flow
alias gffs='git flow feature start'
alias gfff='git flow feature finish'

# easier branch switching
alias master='git checkout master'
alias main='git checkout main'
alias develop='git checkout develop'

# fasd
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection

# Force tmux to use 256 colours
alias tmux='tmux -2'

# Easy recursion
alias ...='cd ../..'
alias ....='cd ../../..'

# Update docker compose containers
alias dcu='docker-compose stop && docker-compose pull --parallel && docker-compose up -d'

# Update ALL the things
alias update='sudo softwareupdate -ia; brew update; brew upgrade; brew cleanup; gem update;'

# Swift development
alias lint='swiftlint'
alias st='swift test'
alias nukesim='xcrun simctl --set testing shutdown all && xcrun simctl --set testing erase all'

alias clean_branches="zsh $DOTFILES/scripts/clean-branches.zsh"
alias clean_branches_manual="zsh $DOTFILES/scripts/clean-branches-manual.zsh"

alias parent_branch='git show-branch | sed "s/].*//" | grep "\*" | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed "s/^.*\[//"'

alias xcg='mint run xcodegen generate'
