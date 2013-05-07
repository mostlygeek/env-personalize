#!/bin/sh

cd $HOME

echo "Update Bash Aliases (Core)"
echo "---------------------------"

# Core aliases are sync'd up to this script
# localized and customized aliases will still go into 
# the usual ~/.bash_aliases

cat << "EOF" > $HOME/.bash_aliases_core
alias a='clear; cat ~/.bash_aliases'
alias ea='vi ~/.bash_aliases; echo "Refreshing..."; source ~/.bash_aliases'
alias r='source ~/.bash_aliases'

# Update environment settings
alias update-env='curl https://raw.github.com/mostlygeek/env-personalize/master/install.sh | sh'

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

source $HOME/.bash_aliases_core

for file in "~/.bash_aliases" "~/.bash_aliases_core"
do
    if [ $(grep "source $file" $HOME/.bash_profile | wc -l) -eq 0 ]; then
        echo "Adding sourcing of $file"
        echo "---------------------------------------"

        cat << EOF >> $HOME/.bash_profile
if [ -e $file ]; then
    source $file
fi
EOF
    fi
done

if [ $(grep "EDITOR=vim" $HOME/.bash_profile | wc -l) -eq 0 ]; then
    echo "EDITOR=vim" >> $HOME/.bash_profile
    echo "export EDITOR" >> $HOME/.bash_profile
fi
if [ $(grep "VISUAL=vim" $HOME/.bash_profile | wc -l) -eq 0 ]; then
    echo "VISUAL=vim" >> $HOME/.bash_profile
    echo "export VISUAL" >> $HOME/.bash_profile
fi

if [ ! -e $HOME/.tmux.conf ]; then
    cat << "EOF" > $HOME/.tmux.conf
# NOTE!! 
#
# to reload tmux w/out restarting, enter command mode and
#
# :source-file $HOME/.tmux.conf
#
 
unbind C-b
set -g prefix C-a

# Allow C-A a to send C-A to application like tmux/screen over ssh
bind a send-prefix

# no need to use the prefix, just use Ctrl+S
bind-key -n C-s send-prefix
 
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
EOF
fi

if [ ! -z "$(uname -a | grep Darwin)" ]; then 
    if [ -z "$(grep "reattach-to-user-namespace" $HOME/.tmux.conf)" ]; then
        echo "Installing OSX TMUX pbcopy hacks"
        echo "--------------------------------"

        cat << "EOF" >> $HOME/.tmux.conf
# fix for broken pbcopy in tmux
# see: http://superuser.com/questions/231130/unable-to-use-pbcopy-while-in-tmux-session
set-option -g default-command "reattach-to-user-namespace -l bash"
EOF
    fi
fi

# 
# Install VIM
#
if [ ! -e $HOME/.vim/backup ]; then
    mkdir -p $HOME/.vim/backup
fi

if [ ! -e $HOME/.vim/bundle ]; then
    mkdir -p $HOME/.vim/bundle
fi

if [ ! -e $HOME/.vim/tmp ]; then
    mkdir -p $HOME/.vim/tmp
fi
echo "Replacing $HOME/.vimrc"
echo "----------------------"
curl -s https://raw.github.com/mostlygeek/vim-personalize/master/vimrc -o $HOME/.vimrc

if [ ! -e $HOME/.vim/bundle/vundle ]; then
    echo "Installing Vundle"
    echo "-----------------"
    git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle

    # auto-fetch the bundle
    # this can blow up the whole install ... so leave it last (hacky)
    vim +BundleInstall +qall
fi
