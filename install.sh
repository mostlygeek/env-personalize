#!/bin/sh

cd $HOME

echo "Update Bash Aliases (Core)"
echo "---------------------------"

# Core aliases are sync'd up to this script
# localized and customized aliases will still go into
# the usual ~/.bash_aliases

cat << "EOF" > $HOME/.bash_aliases_core
#
# These are the CORE bash aliases. DO NOT CHANGE THIS FILE
# IT WILL BE OVER-WRITTEN WHEN env-personalize IS RUN AGAIN.
#
alias a='clear; cat ~/.bash_aliases'
alias ea='vi ~/.bash_aliases; echo "Refreshing..."; source ~/.bash_aliases'
alias r='source ~/.bash_aliases'

# Update environment settings
alias update-env='curl https://raw.github.com/mostlygeek/env-personalize/master/install.sh | sh'

# Git
alias gs="git status"
alias gb="git branch"
alias gb="git push"
alias gcleanup="git clean -fdx ."
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

echo "Updating ~/.tmux.conf"
echo "---------------------"
cat << "EOF" > $HOME/.tmux.conf
# NOTE!!
#
# This file is automatically generated from https://github.com/mostlygeek/env-personalize
# make changes there.
#
# Reload tmux w/out restarting, enter command mode and
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


## set status bar color
set -g status-bg blue
set -g status-fg white
set-option -g allow-rename off
#set-window-option -g window-status-current-bg red

#
## make it easier to split window
unbind %
bind | split-window -h
bind - split-window -v
#
## set default colors
set -g default-terminal "screen-256color"
#
## bind ctrl+k (no prefix required) to clear scrollback
bind -n C-k clear-history
#
## Set vi mode
## http://blog.sanctum.geek.nz/vi-mode-in-tmux/
set-window-option -g mode-keys vi
#
# Ref: http://jasonwryan.com/blog/2012/06/07/copy-and-paste-in-tmux/
# Make it more like vim to copy / paste text into the buffer, using
# v (select), y (yank) and p (paste) text
#
unbind p
bind p paste-buffer
bind-key -T vi-copy 'v' send -X begin-selection
bind-key -T vi-copy 'y' send -X copy-selection

# Enable mouse scrolling
set -g mouse on
EOF

# personalize git
git config --global user.name "Benson Wong"

# does this really prevent spam?
git config --global user.email "mostlygeek+git@gmail.com"

# push current branch to upstream only. Avoids nastiness of git push -f
git config --global push.default current

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
curl -s https://raw.githubusercontent.com/mostlygeek/vim-personalize/master/vimrc -o $HOME/.vimrc

if [ ! -e $HOME/.vim/autoload/plug.vim ]; then

    if [ ! -e $HOME/.vim/autoload ]; then
        mkdir -p ~/.vim/autoload
    fi

    echo "Installing vim-plug"
    echo "-----------------"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # auto-fetch the bundle
    # this can blow up the whole install ... so leave it last (hacky)
    vim +PlugInstall
fi
