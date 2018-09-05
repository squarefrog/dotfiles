# Source all config files
for config (~/.zsh/*.zsh); do
  source $config
done

source "$HOME/.zsh/functions/xcode.zsh"

# Reload keybindings as the vi prompt override seems to reset history search
# https://github.com/zsh-users/zsh-history-substring-search/issues/70
source "$HOME/.zsh/keybindings.zsh"

# Setup rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi

