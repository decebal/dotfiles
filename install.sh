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
mv $HOME/.vim $HOME/.vim_old 2>/dev/null
mv $HOME/.vimrc $HOME/.vimrc_old 2>/dev/null
ln -sbf $DOTFILES/vim/vim-sources $HOME/.vim
ln -sbf $DOTFILES/vim/vimrc $HOME/.vimrc
ln -sbf $DOTFILES/vim/gvimrc $HOME/.gvimrc

echo "setting up git config & aliases ..."
#git global configuration
#@TODO these files should be merged smoothly 
#applying with priority what comes from the repo
cat $DOTFILES/git/gitconfig >> $HOME/.gitconfig
git config --global core.excludesfile $DOTFILES/git/gitignore_global

#echo "creating local folder..."
#local configuration
#ln -sbf $DOTFILES/local $HOME/.local

#create local files
#mkdir $DOTFILES/local
#touch $DOTFILES/local/aliases
#touch $DOTFILES/local/functions
#touch $DOTFILES/local/paths

#install maker
echo "Do you want cli bookmaker installed ? "
read mak
case $mak in 
    "y")
        ./install.py
		;;
	*)
		echo "canceled"
		;;
esac

echo "Do you want pomodoro installed ? "
read mak
case $mak in 
    "y")
        cd common/pomodoro
        make
		;;
	*)
		echo "canceled"
		;;
esac

cd ~

echo "Restart your shell for modifications to take place"
