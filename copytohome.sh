# this script has to be run from the directory where I keep all the rc files
cp .bashrc ~
cp .zsh_aliases ~
cp .gitconfig ~
cp .zshrc ~
cp .hgrc ~
cp .ackrc ~
cp .xinitrc ~
cp .Xresources ~

cp ./i3homeconfig.template ~/.i3/home_config.template
cp ./i3workconfig.template ~/.i3/worklenovo_config.template
cp ./i3config_epilogue.template ~/.i3/config_epilogue.template
cp ./i3config.template ~/.i3/config.template
cp ./i3afterconfig.sh ~/.local/bin/
cp ./gen-i3-config.sh ~/.local/bin/

cp ./conky-i3-bar.sh ~/.local/bin/
if [ $HOSTNAME == "archlenovo" ]; then
    cp ./.conkyrc_work ~/.conkyrc
fi
cp ./.conkyrc_home ~/.conkyrc

cp ./i3exit.sh ~/.local/bin/i3exit.sh


#after copying the files, generate the i3 config
exec ~/.local/bin/gen-i3-config.sh
