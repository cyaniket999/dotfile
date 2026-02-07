#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# --- macOS Style Prompt ---
# Colors
RESET='\[\033[0m\]'
CYAN='\[\033[01;36m\]'
BLUE='\[\033[01;34m\]'
RED='\[\033[01;31m\]'
GREEN='\[\033[01;32m\]'
WHITE='\[\033[01;37m\]'

# Function to show a red icon if the last command failed
prompt_status() {
    local EXIT="$?"
    if [ $EXIT -ne 0 ]; then
        echo -e "${RED}✘ ${RESET}"
    else
        echo -e "${GREEN}✔ ${RESET}"
    fi
}

# The actual PS1 line
# 󰊠 (User)  (Path)
export PS1="$(prompt_status)${CYAN}󰊠 \u ${WHITE}in ${BLUE} \w ${RESET}\n${WHITE}󰁕 ${RESET}"

# Alias for colored output
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Maintenance aliases
alias update='yay -Syu'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)' # Removes unused dependencies
alias mirror-update='sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist'