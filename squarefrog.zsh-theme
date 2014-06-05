function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function get_pwd() {
  print -D $PWD
}

function precmd() {
print -rP '
'
}
RPROMPT=' $(git_prompt_info)'
PROMPT='%F{cyan}%m: %F{yellow}$(get_pwd) %f$ '

ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="]"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{green}"

