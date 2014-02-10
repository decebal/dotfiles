bash | zsh command line-help
=================

### command line made cozy

Clone this repo to your home:
```
~/.dotfiles
```

If this is not your new director than you need to change bash/bashrc lines:
```
export DOTFILES=$HOME/.dotfiles
DOTFILES=$HOME/.dotfiles
```

or your zsh/zshrc similar lines depending on your choosing.

 ##Recommened install flow:
 1. Clone repo

    ` git clone --recursive https://github.com/decebal/dotfiles ~/.dotfiles `
 2. run install script

    ` cd ~/.dotfiles && ./install.sh `
 3. install git flow 
    - use package manager : git-flow
    - without root access: `mkdir -p ~/bin; cd ~/bin; export INSTALL_PREFIX=~/bin; wget --no-check-certificate -q -O - https://raw.github.com/nvie/gitflow/develop/contrib/gitflow-installer.sh | bash`
