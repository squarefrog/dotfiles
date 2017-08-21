for config (~/.zsh/*.zsh) source $config

# Show Vi status in prompt
bindkey -v
VIM_PROMPT="❯"
PROMPT='%(?.%F{magenta}.%F{red})${VIM_PROMPT}%f '

prompt_pure_update_vim_prompt() {
    zle || {
        print "error: pure_update_vim_prompt must be called when zle is active"
        return 1
    }
    VIM_PROMPT=${${KEYMAP/vicmd/❮}/(main|viins)/❯}
    zle .reset-prompt
}

function zle-line-init zle-keymap-select {
    prompt_pure_update_vim_prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Reload keybindings as the above seems to reset history search
# https://github.com/zsh-users/zsh-history-substring-search/issues/70
source "$HOME/.zsh/keybindings.zsh"
