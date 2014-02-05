#!/bin/sh
DOTFILES=$HOME/.dotfiles

#bash config file
ln -sbf $DOTFILES/bash/bashrc $HOME/.bashrc

#zsh config file
ln -sbf $DOTFILES/zsh/zshrc $HOME/.zshrc
ln -sbf $DOTFILES/zsh/oh-my-zsh/ $HOME/.oh-my-zsh

#vim install
ln -sbf $DOTFILES/vim/vim-sources $HOME/.vim
ln -sbf $DOTFILES/vim/vimrc $HOME/.vimrc

#git global configuration
git config --global core.excludesfile $DOTFILES/git/gitignore_global
cat $DOTFILES/git/gitconfig >> $HOME/.gitconfig

#local configuration
ln -sbf $DOTFILES/local $HOME/.local
touch $DOTFILES/local/aliases
touch $DOTFILES/local/functions
