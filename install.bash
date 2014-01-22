#!/bin/bash
DOTFILES=$HOME/dotfiles

#git global configuration
git config --global core.excludesfile $DOTFILES/.gitignore_global
cat $DOTFILES/.gitconfig >> $HOME/.gitconfig

#zsh config file
ln -s $DOTFILES/.zshrc $HOME/.zshrc
ln -s $DOTFILES/oh-my-zsh/ $HOME/.oh-my-zsh

#vim install
ln -s $DOTFILES/vim-sources $HOME/.vim
ln -s $DOTFILES/.vimrc $HOME/.vimrc

