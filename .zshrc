#Path to your oh-my-zsh configuration.
DOTFILES=$HOME/$DOTFILES
export $DOTFILES
ZSH=$DOTFILES/oh-my-zsh

eval $(ssh-agent)
/usr/bin/ssh-add

#DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true

ZSH_THEME="af-magic"

export LS_OPTIONS='--color=auto'

COMPLETION_WAITING_DOTS="true"

zstyle :omz:plugins:ssh-agent agent-forwarding on

plugins=(git rvm)

# Customize to your needs...
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/

# Change directory on login
if [[ -o login ]]; then
    cd /var/www
fi

source $ZSH/oh-my-zsh.sh

# Alias definitions.
    if [ -f $DOTFILES/.bash_aliases ]; then
    . $DOTFILES/.bash_aliases
    fi

    if [ -f $DOTFILES/.bash_functions ]; then
        . $DOTFILES/.bash_functions
    fi

    if [ -f $DOTFILES/.git_completion.bash ]; then
        . $DOTFILES/.git_completion.bash
    fi

    if [ -f $DOTFILES/.git-flow-completion.bash ]; then
        . $DOTFILES/.git-flow-completion.bash
    fi

    if [ -f $DOTFILES/.symfony2-autocomplete.bash ]; then
        . $DOTFILES/.symfony2-autocomplete.bash
    fi

    if [ -f $DOTFILES/.complete-hosts.sh ]; then
        . $DOTFILES/.complete-hosts.sh
    fi

PATH=$PATH:/usr/local/rvm/bin

source $DOTFILES/git.bashrc
