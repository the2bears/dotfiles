# For dotfiles git
alias dotfig='git --git-dir=/Users/williamswaney/.dotfig --work-tree=/Users/williamswaney'

# For setting the title in the tab.
autoload -Uz add-zsh-hook
add-zsh-hook precmd set-title-precmd
add-zsh-hook preexec set-title-preexec

source ~/.profile 
