#!/bin/sh

# 
# Install VIM
#
if [ ! -e $HOME/.vim/backup ]; then
    mkdir -p $HOME/.vim/backup
fi

if [ ! -e $HOME/.vim/tmp ]; then
    mkdir -p $HOME/.vim/tmp
fi

# just replace it every time
curl https://raw.github.com/mostlygeek/vim-personalize/master/vimrc -o $HOME/.vimrc

if [ ! -e $HOME/.vim/bundle/vundle ]; then
    echo "Installing Vundle"
    echo "-----------------"
    git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle

    # auto-fetch the bundle
    vim +BundleInstall +qall
fi


if [ ! -e $HOME/.bash_aliases ]; then
    echo Install Bash Aliases
    echo --------------------

    cat << "EOF" > $HOME/.bash_aliases
alias a='clear; cat ~/.bash_aliases'
alias ea='vi ~/.bash_aliases; echo "Refreshing..."; source ~/.bash_aliases'
alias r='source ~/.bash_aliases'

# httpie: https://github.com/jkbr/httpie
alias http='/usr/local/share/python/http'

# Git 
alias gs="git status"
alias gb="git branch"
alias gb="git push"
alias gcleanup="git clean -fdx ."

# http://www.huyng.com/archives/quick-bash-tip-directory-bookmarks/492/
# Bash Directory Bookmarks
alias m1='alias g1="cd `pwd`"; mdump'
alias m2='alias g2="cd `pwd`"; mdump'
alias m3='alias g3="cd `pwd`"; mdump'
alias m4='alias g4="cd `pwd`"; mdump'
alias m5='alias g5="cd `pwd`"; mdump'
alias m6='alias g6="cd `pwd`"; mdump'
alias m7='alias g7="cd `pwd`"; mdump'
alias m8='alias g8="cd `pwd`"; mdump'
alias m9='alias g9="cd `pwd`"; mdump'
alias mdump='alias|grep -e "alias g[0-9]"|grep -v "alias m" > ~/.bookmarks'
alias aa='alias | grep -e "alias g[0-9]"|grep -v "alias m"|sed "s/alias //"'
touch ~/.bookmarks
source ~/.bookmarks
EOF
fi

source $HOME/.bash_aliases

if [ ! -e $HOME/.tmux.conf ]; then

    cat << "EOF" > $HOME/.tmux.conf
# NOTE!! 
#
# to reload tmux w/out restarting, enter command mode and
#
# :source-file $HOME/.tmux.conf
#

# fix for broken pbcopy in tmux
# see: http://superuser.com/questions/231130/unable-to-use-pbcopy-while-in-tmux-session
set-option -g default-command "reattach-to-user-namespace -l bash"
 
unbind C-b
set -g prefix C-a

# Allow C-A a to send C-A to application like tmux/screen over ssh
bind a send-prefix

# no need to use the prefix, just use Ctrl+B
bind-key -n C-b send-prefix
 
# allow mouse navigation (on mac) between panes
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D
 
# set status bar color
set -g status-bg blue
set -g status-fg white
set-window-option -g window-status-current-bg red

# make it easier to split window
unbind %
bind | split-window -h
bind - split-window -v
 
# set default colors
set -g default-terminal "screen-256color"

# Set vi mode
# http://blog.sanctum.geek.nz/vi-mode-in-tmux/
set-window-option -g mode-keys vi

# Enable mouse scrolling
set -g mode-mouse on
#set -g mouse-resize-pane on
set -g mouse-select-pane on
#set -g mouse-select-window on

# easier copy / pasting
# src: http://stackoverflow.com/a/12634260
bind y run-shell "reattach-to-user-namespace -l zsh -c 'tmux show-buffer | pbcopy'"
EOF
