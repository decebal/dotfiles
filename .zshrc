#Path to your oh-my-zsh configuration.
export DOTFILES=$HOME/dotfiles
DOTFILES=$HOME/dotfiles
ZSH=$DOTFILES/oh-my-zsh

eval $(ssh-agent)
/usr/bin/ssh-add

DISABLE_UPDATE_PROMPT=true
#DISABLE_AUTO_UPDATE=true
POWERLINE_RIGHT_A="mixed"
POWERLINE_DATE_FORMAT="%D{%d-%m}"
POWERLINE_SHOW_GIT_ON_RIGHT="true"
POWERLINE_DETECT_SSH="true"

#ZSH_THEME="bira"
ZSH_THEME="powerline"

export LS_OPTIONS='--color=auto'

COMPLETION_WAITING_DOTS="true"

zstyle :omz:plugins:ssh-agent agent-forwarding on

plugins=(git gitfast rvm virtualenv composer custom-aliases dircycle ssh-agent sublime symfony2 wd )
fpath=($DOTFILES/zsh-completions/src $fpath)

# Customize to your needs...
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/

# Change directory on login
if [[ -o login ]]; then
    cd /var/www
fi

source $ZSH/oh-my-zsh.sh

# Alias definitions.
    if [ -f $DOTFILES/.aliases ]; then
    . $DOTFILES/.aliases
    fi

    if [ -f $DOTFILES/.functions ]; then
        . $DOTFILES/.functions
    fi

#    if [ -f $DOTFILES/.symfony2-autocomplete.bash ]; then
#        . $DOTFILES/.symfony2-autocomplete.bash
#    fi

#    if [ -f $DOTFILES/.complete-hosts.sh ]; then
#        . $DOTFILES/.complete-hosts.sh
#    fi

PATH=$PATH:/usr/local/rvm/bin

umask 0000


export TERM="xterm-256color"
