# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.alias
source ~/.vars
source ~/.secure

eval "$(zoxide init --cmd c zsh)"

PS1='[\u@\h \W]\$ '

export NVM_DIR=~/.config/nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
