#Alias erzeugen ~/.bashrc
##aliases and functions
. ~/.dotfiles/bash/env
. ~/.dotfiles/bash/config
. ~/.dotfiles/bash/aliases

#for special alias path etc...
if [ -f ~/.bashrc_local ]; then
  source ~/.bashrc_local
fi