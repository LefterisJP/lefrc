#!/bin/zsh
###
#generic configuration
###

#make sure we got 256 color term
export TERM=xterm-256color

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Source my zsh functions
if [ -f ~/.zsh_functions ]; then
    source ~/.zsh_functions
else
    print "Could not find the zsh_functions file"
    return 1
fi

# export GNUPG_TTY
export GPG_TTY=$(tty)

# quick/dirty fix for grep's GREP OPTIONS warning. Normal fix would
# be to alter the location in prezto where it is set
alias grep="/usr/bin/grep $GREP_OPTIONS"
unset GREP_OPTIONS

# set path
source ~/.lefpathsetter

# - set ethereum tests path -
export ETHEREUM_TEST_PATH=/home/lefteris/ew/tests/
# - set Npm node path -
# export NODE_PATH=/usr/lib/node_modules
export NODE_PATH=~/.npm-global/bin
# Add npm global dir to path
export PATH=~/.npm-global/bin:$PATH
# Add ruby gems to the path
export PATH=~/.gem/ruby/2.6.0/bin:$PATH

# - enable zsh history -

# maximum number of lines that are kept in a session
HISTSIZE=1000
# maximum number of lines that are kept in the history file
SAVEHIST=1000
HISTFILE=~/.zhistory

# source my aliases
source ~/.zsh_aliases

# if we got keychain installed add our ssh key there
if hash keychain 2>/dev/null; then
    eval $(keychain --eval --agents ssh -Q --quiet id_rsa)
fi

# user systemd services
source ~/.systemd_user.zsh
# use powerline
if [[ -f /usr/share/zsh/site-contrib/powerline.zsh ]]; then
    source /usr/share/zsh/site-contrib/powerline.zsh
elif [[ -f /usr/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source /usr/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
elif [[ -f /usr/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source /usr/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh
elif [[ -f /usr/lib/python3.5/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source /usr/lib/python3.5/site-packages/powerline/bindings/zsh/powerline.zsh
elif [[ -f /usr/share/powerline/bindings/zsh/powerline.zsh ]]; then
    source /usr/share/powerline/bindings/zsh/powerline.zsh
fi


# Python virtualenv wrapper
if [[ -f /usr/bin/virtualenvwrapper.sh ]]; then
    export WORKON_HOME=~/.virtualenvs
    source /usr/bin/virtualenvwrapper.sh
    VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
fi



#########################################
# silly stuff --                  START
#########################################
if [[ -s "/usr/bin/fortune" && -s "/usr/bin/ponysay" ]]; then
   fortune -a | ponythink
fi
#########################################
# silly stuff --                  END
#########################################

#########################################
# System-dependent configuration - START
#########################################
determine-location
__location_id=$?

# Configuration for both home dev and work laptop
if [[ $__location_id -eq 1 || $__location_id -eq 2 ]]; then

   if [[ $__location_id -eq 1 ]]; then # Configuration only for home dev (arch)
       # add android tools to the path
       export PATH="/opt/android-sdk/tools:$PATH"
   else # Configuration only for work laptop
   fi
fi
#########################################
# System-dependent configuration - END
#########################################

###
# Issue : commands being echoed back after each typing. As I explain in
# this blog post: http://blog.refu.co/?p=1277
# zsh due to prezto configuration was trying to set the terminal window
# title. *ansi-term* does not know how to handle that and as such echoes
# the command back to the buffer. Solution is to simply configure this setting
# to not work when from inside emacs
###
if [[ -n ${EMACS} ]]; then
    zstyle ':prezto:module:terminal' auto-title 'no'
fi

export ALTERNATE_EDITOR=""
export EDITOR=ecn.zsh

#########################################
#           ZSH KEYBINDINGS
#
# Some of the info taken from the zsh wiki
# http://zshwiki.org/home/zle/bindkeys
#########################################
autoload zkbd
function zkbd_file() {
    [[ -f ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && printf '%s' ~/".zkbd/${TERM}-${VENDOR}-${OSTYPE}" && return 0
    [[ -f ~/.zkbd/${TERM}-${DISPLAY}          ]] && printf '%s' ~/".zkbd/${TERM}-${DISPLAY}"          && return 0
    return 1
}

[[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
keyfile=$(zkbd_file)
ret=$?
if [[ ${ret} -ne 0 ]]; then
    zkbd
    keyfile=$(zkbd_file)
    ret=$?
fi
if [[ ${ret} -eq 0 ]] ; then
    source "${keyfile}"
else
    printf 'Failed to setup keys using zkbd.\n'
fi
unfunction zkbd_file; unset keyfile ret

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
# make sure that insert does not enable overwrite mode. We use insert as the i3-wm key
bindkey  "${key[Insert]}"  emacs-backward-word
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
# make ALT + arrows keys move in words. The key sequence is a bit fucked up but work for my setup
bindkey "\e\e[D" backward-word
bindkey "\e\e[C" forward-word

#########################################
# zsh redirect output to new file so that
# things like below can work again
#
# ls -l >> NEWFILE.txt
#########################################
setopt clobber

# Taken from https://gist.github.com/schmir/4ceefb8d7d27a4b230fd760fd4ab4cc7

# When Tab is pressed on an empty(!) command line, the contents of the
# directory are printed (`ls`) instead of a menu list of all
# executables:

function my-hg-report() {
    tip=$(hg tip 2> /dev/null) || return
    echo
    hg --config pager.pager= status
    echo
    hg --config pager.pager= log --limit 5 --style compact
}

function my-git-report() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "------------------------------------------------------------"
    git status
    echo "------------------------------------------------------------"
    git log --pretty=tformat:"%ae    %ci%C(bold)%d%Creset%n%h: %s%n" -3 --color |cat
    echo
}

function complete-or-list() {
    if [[ $#BUFFER == 0 ]]; then
        echo
        ls -F
        my-git-report || my-hg-report
        zle reset-prompt
    else
        zle expand-or-complete
    fi
}
zle -N complete-or-list
bindkey '^I' complete-or-list

## Taken from https://github.com/nvm-sh/nvm#automatically-call-nvm-use
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
