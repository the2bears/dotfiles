# For dotfiles git
alias dotfig='git --git-dir=/Users/williamswaney/.dotfig --work-tree=/Users/williamswaney'

# For colors in ls
alias ll='ls -Alh'
alias ls='lsd --group-dirs first'

alias cleark='printf "\033[2J\033[3J\033[1;1H"'


# For emacs --daemon
# alias emacs='emacsclient -c'
# if [[ "$(ps -ef | grep emacs | grep daemon | wc -l)" -le 0 ]] &&
#    [[ "$(launchctl list | grep gnu.emacs.daemon | wc -l)" -le 0 ]]
# then
#     echo "Loading emacs --daemon to launchctl"
#     launchctl load -w ~/Library/LaunchAgents/gnu.emacs.daemon.plist
# else
#     echo "Not loading emacs --daemon to launchctl. Already running."
#  fi

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

neofetch

if [[ "$TERM" == "dumb" ]]
then
    echo "Dumb terminal, no Starship."
    alias less=cat
    alias more=cat
else
    # starship prompt
    eval "$(starship init zsh)"
fi    

PATH=~/bin:$PATH

