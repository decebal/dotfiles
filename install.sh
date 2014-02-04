#!/bin/sh
DOTFILES=$HOME/.dotfiles

#bash config file
ln -s $DOTFILES/bash/bashrc $HOME/.bashrc

#zsh config file
ln -s $DOTFILES/zsh/zshrc $HOME/.zshrc
ln -s $DOTFILES/zsh/oh-my-zsh/ $HOME/.oh-my-zsh

#vim install
ln -s $DOTFILES/vim/vim-sources $HOME/.vim
ln -s $DOTFILES/vim/vimrc $HOME/.vimrc

#git global configuration
git config --global core.excludesfile $DOTFILES/git/gitignore_global
cat $DOTFILES/git/gitconfig >> $HOME/.gitconfig

#local configuration
ln -h $DOTFILES/local $HOME/.local
touch $HOME/.local/aliases
touch $HOME/.local/functions