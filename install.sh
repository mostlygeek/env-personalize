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
