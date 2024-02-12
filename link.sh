#!/bin/bash

WINHOME=`cmd.exe /c 'echo %HOMEDRIVE%%HOMEPATH%' 2>/dev/null`
WINHOME=`wslpath $WINHOME | sed -e 's/\r//g'`
ln -s $WINHOME ~/WinHome

ln -s ~/dotfiles/.tmux.conf ~/
ln -s ~/dotfiles/.profile ~/
ln -s ~/dotfiles/.vimrc ~/
ln -s ~/dotfiles/.vim ~/
ln -s ~/dotfiles/.bashrc ~/
ln -s ~/dotfiles/.gitconfig ~/
ln -s ~/dotfiles/config.fish ~/.config/fish/
ln -s ~/dotfiles/.mybashrc ~/.mybashrc
ln -s ~/dotfiles/mybin ~/bin

mkdir -p ~/.ssh
ln -s ~/WinHome/Documents/bin/wsl2-ssh-pageant.exe ~/.ssh/