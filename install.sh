#!/bin/bash
CONFIG_FOLDER="$HOME/.config"

# Copies nvim folder to nvim config folder
# arg $1 is nvim environment folder ('macos' for MacOS)
# arg $2 indicates if existing folder should be removed before copying or not.
#   If not forcing, updates will not be applied if folder already exists.
function setup_nvim(){
    echo "Setting up nvim..."    
    nvim_folder_common="`pwd`/nvim/common/*"
    nvim_folder_os="`pwd`/nvim/$1"
    if test -e $nvim_folder_os; then
        echo "Found $nvim_folder_os"
        nvim_config_folder="$CONFIG_FOLDER/nvim"
        
        if test -e $nvim_config_folder; then
            echo "Found $nvim_config_folder"
            if [[ "$2" == "force" ]]; then
                echo "Forcing update."
                rm -r $nvim_config_folder 
                cp -r $nvim_folder_os $nvim_config_folder
                eval cp -r $nvim_folder_common $nvim_config_folder
            else
                echo "Failed to update $nvim_config_folder, it already exists. If you really wish to update, force it."
                return
            fi
        else
            echo "Failed to find $nvim_config_folder"
        fi
        echo "Copying nvim config from: $nvim_folder_os to: $nvim_config_folder"
        cp -r $nvim_folder_os $nvim_config_folder
    else
        echo "Failed to find $nvim_folder_os" 
    fi
}

# Copies tmux conf file to the home folder 
# arg $1 indicates if existing folder should be removed before copying or not.
#   If not forcing, updates will not be applied if folder already exists.
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
    setup_nvim "macos" "force"
else
    echo "Using unsupported OS"
fi
