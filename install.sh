#!/bin/bash

function setup_nvim(){

}

function setup_tmux(){
    echo "Setting up tmux..."
    filename='.tmux.conf'
    target="$HOME/$filename" 

    if test -e "$target"; then 
        if [[ "$1" == "force" ]]; then
            echo "Forcing update."
            rm -r $target
        else
            echo "Failed to update $target, it already exists. If you really wish to update, force it."
            return
        fi
    fi

    source="`pwd`/tmux/$filename"

    echo "creating file $target"
    echo "and linking to $source"
    cp $source $target
    tmux source $target
}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Detected Linux"
    setup_tmux

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected MacOS"
    setup_tmux "force"
    setup_nvim
else
    echo "Using unsupported OS"
fi
