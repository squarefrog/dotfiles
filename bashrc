# Source the major default settings shared
# between zsh and bash

if [[ ! -f $HOME/.shellrc ]];then
  echo "$HOME/.shellrc doesn't exist. Run ./manage.sh install again"
else
  source $HOME/.shellrc
fi
