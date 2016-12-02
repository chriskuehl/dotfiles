# figure out what OS we're on
source ~/.shell-detect

unset HISTFILE
HISTSIZE=1000
SAVEHIST=1000

setopt appendhistory extendedglob notify
unsetopt autocd nomatch
bindkey -v
autoload -U colors && colors

autoload -U compinit promptinit
compinit
promptinit

if [[ $EUID -ne 0 ]]; then
	PROMPT_COLOR=green
	PROMPT_SYMBOL="$"
else # if root
	PROMPT_COLOR=red
	PROMPT_SYMBOL="#"
fi

PROMPT="%(?..$fg[yellow][%?] )%{$fg_bold[$PROMPT_COLOR]%}%n@%m%{$reset_color%}:%{$fg_bold[blue]%}%~%{$reset_color%}$PROMPT_SYMBOL "

export PATH=~/bin:~/.bin:/usr/sbin:/sbin/:/usr/local/sbin:$PATH

export TERM=xterm-256color
source ~/.shell-includes
