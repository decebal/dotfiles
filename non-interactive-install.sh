#!/bin/bash
DOTFILES=$HOME/.dotfiles

ln -sf $DOTFILES/zsh/zshrc $HOME/.zshrc
ln -sf $DOTFILES/zsh/oh-my-zsh/ $HOME/.oh-my-zsh

#vim install
mv $HOME/.vim $HOME/.vim_old 2>/dev/null
mv $HOME/.vimrc $HOME/.vimrc_old 2>/dev/null
ln -sf $DOTFILES/vim/vim-sources $HOME/.vim
ln -sf $DOTFILES/vim/vimrc $HOME/.vimrc
ln -sf $DOTFILES/vim/gvimrc $HOME/.gvimrc

#git global configuration
#@TODO these files should be merged smoothly 
#applying with priority what comes from the repo
cat $DOTFILES/git/gitconfig >> $HOME/.gitconfig
git config --global core.excludesfile $DOTFILES/git/gitignore_global


#create local files
mkdir $DOTFILES/local
touch $DOTFILES/local/aliases
touch $DOTFILES/local/functions
touch $DOTFILES/local/paths

#local configuration
ln -sf $DOTFILES/local $HOME/.local

