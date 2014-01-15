#!/bin/sh
cd ../..
ln -s $DOTFILES/vimrc/vimrc .vimrc
ln -s $DOTFILES/vimrc/gvimrc .gvimrc

#pathogen needed path
ln -s $DOTFILES/vimrc .vim

# xmledit
cd $DOTFILES/vimrc/bundle/xmledit/ftplugin/
ln -s xml.vim html.vim
ln -s xml.vim xhtml.vim

