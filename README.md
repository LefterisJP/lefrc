# Installation guide of my system

Here I will write stuff that I tend to forget and remember (and have to struggle again)
every time I reinstall my system

## Things to move

### keepass data

Use dropbox to move the keeppass DB itself and a usb key to get the master key.

### Gpg keys

Export gpg keys from the old system and import to new

https://www.phildev.net/pgp/gpg_moving_keys.html

## Packages to install

### Networking

networkmanager
nmcli
network-manager-applet
networkmanager-openvn   -> and get the vpn conf

### Utilities

- inetutils -> for hostname which is used by all location determining scripts

### Backlight control

- acpi
- clight (from yay)

### Audio

- pulseaudio
- pavucontrol

### Terminal emulator

- rxvt-unicode

maybe .... xterm too?

Also xclip and follow https://nixmeal.wordpress.com/2012/07/24/copypaste-text-in-urxvt-rxvt-unicode-using-keyboard/
to copy paste with ctrl shift v urxvt

