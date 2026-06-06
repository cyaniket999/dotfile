# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# This line controls exactly how your terminal prompt looks
PS1='[\u@\h \W]\$ '

# Maintenance aliases
alias update='yay -Syu'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)' # Removes unused dependencies
alias mirror-update='sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist'
