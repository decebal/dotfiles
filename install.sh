#!/bin/bash
DOTFILES=$HOME/.dotfiles

echo "select your favorite script interpretor *********  1)bash 2)zsh 3)quit  "
read n
case $n in
	1)
		echo "creating bash links..."
		#bash config file
		ln -sbf $DOTFILES/bash/bashrc $HOME/.bashrc
		;;
	2)
		echo "creating zsh links..."
		#zsh config file
		ln -sbf $DOTFILES/zsh/zshrc $HOME/.zshrc
		ln -sbf $DOTFILES/zsh/oh-my-zsh/ $HOME/.oh-my-zsh
		;;
	*)
		echo "canceled"
		exit
		;;
esac

echo "creating vim links..."
#vim install
ln -sbf $DOTFILES/vim/vim-sources $HOME/.vim
ln -sbf $DOTFILES/vim/vimrc $HOME/.vimrc

echo "setting up git config & aliases ..."
#git global configuration
git config --global core.excludesfile $DOTFILES/git/gitignore_global
cat $DOTFILES/git/gitconfig >> $HOME/.gitconfig

echo "creating local folder..."
#local configuration
ln -sbf $DOTFILES/local $HOME/.local

#create local files
mkdir $DOTFILES/local
touch $DOTFILES/local/aliases
touch $DOTFILES/local/functions

case $n in
	1)
		source $HOME/.bashrc
		;;
	2)
		source $HOME/.zshrc
		;;
esac
