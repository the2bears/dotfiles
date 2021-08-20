# For dotfiles git
alias dotfig='git --git-dir=/Users/williamswaney/.dotfig --work-tree=/Users/williamswaney'

# Set title of terminal. For tabs. Sets to PWD but not full path.
function set-title-precmd() {
    printf "\e]2;%s\a" " ${PWD##*/}"
}

function set-title-preexec() {
    printf "\e]2;%s\a" "$1"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd set-title-precmd
add-zsh-hook preexec set-title-preexec

source ~/.profile 
