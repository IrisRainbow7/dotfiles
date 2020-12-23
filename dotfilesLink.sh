#!/bin/sh
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.zshrc ~/.zshrc
cat bashrc_add.txt >> ~/.bashrc
git clone https://github.com/tmux-plugins/tmux-battery ~/tmux-battery
source ~/.bashrc
