#!/bin/zsh
source ~/.zsh_functions

systemd-service-assert-enabled org-sync-onoff --user
systemd-service-assert-enabled emacs --user


