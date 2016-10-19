#!/bin/zsh

# this script has to be run from the directory where I keep all the rc files
cp .bashrc ~
cp .zsh_aliases ~
cp .zsh_functions ~
cp .systemd_user.zsh ~
cp .gitconfig ~
cp .hgrc ~
cp .ackrc ~
cp .xinitrc ~
cp .xprofile ~
cp .Xresources ~
cp .Xdefaults ~
cp .Xmodmap ~
cp .tmux.conf ~
cp .offlineimaprc ~
cp .lefpathsetter ~
cp keyboard_config.xkb ~/.Xkeymap
cp ssh_config ~/.ssh/config

# Prepare Prezto and ZSH
if [ -d "$HOME/.zprezto" ]; then
  rm -rf "$HOME/.zprezto"
fi
mkdir "$HOME/.zprezto"
cp -r ./prezto/* "$HOME/.zprezto"
zsh ./prezto_new_conf.zsh
cp .zshrc ~

# copy gpg config
if [ ! -d "$HOME/.gnupg" ]; then
    mkdir "$HOME/.gnupg"
fi
cp gpg-agent.conf "$HOME/.gnupg/"
cp gpg.conf "$HOME/.gnupg/"

# copy local user configurations
if [ ! -d "$HOME/.config" ]; then
    mkdir "$HOME/.config"
fi

# In newer version of powerline you must not copy this config
# cp -r .config/powerline "$HOME/.config/"
cp -r .config/systemd "$HOME/.config/"

if [ ! -d "$HOME/.config/dunst" ]; then
    mkdir "$HOME/.config/dunst"
fi
cp dunstrc /home/lefteris/.config/dunst/dunstrc


if [ ! -d "$HOME/.i3" ]; then
    mkdir "$HOME/.i3"
fi
if [ ! -d "$HOME/.local" ]; then
    mkdir "$HOME/.local"
fi
if [ ! -d "$HOME/.local/bin" ]; then
    mkdir "$HOME/.local/bin"
fi

# copy i3 configs folder
cp -r .i3/* ~/.i3/
# copy some utils
cp -r .local/bin/* ~/.local/bin/

if [[ `hostname` == "robaczek" ]]; then
    cp ./.conkyrc_work ~/.conkyrc
    cp .xbindkeysrc_laptop ~/.xbindkeysrc
else
    cp ./.conkyrc_home ~/.conkyrc
    cp .xbindkeysrc_home ~/.xbindkeysrc
fi

#after copying the files, generate the i3 config
exec ~/.local/bin/gen-i3-config.sh
