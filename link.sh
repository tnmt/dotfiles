#!/bin/sh

DOTFILES_DIR=$PWD

cd $DOTFILES_DIR

for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ]
    then
        unlink $HOME/$dotfile
        ln -Fs "$DOTFILES_DIR/$dotfile" $HOME
    fi
done

if [ ! -d ~/.vimbackup/ ]
then
    mkdir ~/.vimbackup/
fi
