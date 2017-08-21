# ls
alias la="ls -ahl"

# git
alias gs="git status"
alias gaa="git add --all"
alias gap="git add -p"
alias gd="git diff"
alias gdc="git diff --cached"
alias gc="git commit -v"

# git flow
alias gffs='git flow feature start'
alias gfff='git flow feature finish'

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
alias ...="cd ../.."
alias ....="cd ../../.."

# Update ALL the things
alias update='sudo softwareupdate -ia; brew update; brew upgrade; brew cleanup; gem update;'
