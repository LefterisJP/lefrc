#!/bin/zsh

# this script has to be run from the directory where I keep all the rc files
cp .bashrc ~
cp .zsh_aliases ~
cp .gitconfig ~
cp .hgrc ~
cp .ackrc ~
cp .xinitrc ~
cp .Xresources ~

#copy work only stuff
if [[ `hostname` == "archlenovo" ]]; then
    cp -r work_only/* ~
fi

# Prepare Prezto and ZSH
if [ -d "$HOME/.zprezto" ]; then
  rm -rf "$HOME/.zprezto"
fi
mkdir "$HOME/.zprezto"
cp -r ./prezto/* "$HOME/.zprezto"
zsh ./prezto_new_conf.zsh
cp .zshrc ~

# copy local user configurations
if [ ! -d "$HOME/.config" ]; then
    mkdir "$HOME/.config"
fi
cp -r .config/powerline "$HOME/.config/"


if [ ! -d "$HOME/.i3" ]; then
    mkdir "$HOME/.i3"
fi
if [ ! -d "$HOME/.local" ]; then
    mkdir "$HOME/.local"
fi
if [ ! -d "$HOME/.local/bin" ]; then
    mkdir "$HOME/.local/bin"
fi

# i3 related stuff
cp -r .i3/* ~/.i3/
cp -r .local/bin/* ~/.local/bin/

cp ./conky-i3-bar.sh ~/.local/bin/
if [[ `hostname` == "archlenovo" ]]; then
    cp ./.conkyrc_work ~/.conkyrc
else
    cp ./.conkyrc_home ~/.conkyrc
fi

#after copying the files, generate the i3 config
exec ~/.local/bin/gen-i3-config.sh
