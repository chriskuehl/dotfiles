# figure out what OS we're on
source ~/.shell-detect

unset HISTFILE
HISTSIZE=1000
SAVEHIST=1000

setopt appendhistory extendedglob notify ignore_eof
unsetopt autocd nomatch
bindkey -v
autoload -U colors && colors

autoload -U compinit promptinit
compinit
promptinit

if [[ $EUID -ne 0 ]]; then
	PROMPT_COLOR=green # if root
else
	PROMPT_COLOR=red
fi

PROMPT="%{$fg_bold[$PROMPT_COLOR]%}%n@%m%{$reset_color%}:%{$fg_bold[blue]%}%~%{$reset_color%}# "

source ~/.shell-includes
