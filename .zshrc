#!/bin/zsh
###
#generic configuration
###

#make sure we got 256 color term
export TERM=xterm-256color

#add ./local/bin to the path
if [[ -s "${ZDOTDIR:-$HOME}/.local/bin" ]]; then
  export PATH="${ZDOTDIR:-$HOME}/.local/bin:$PATH"
fi

#add home/lefteris/bin to the path
if [[ -s "${ZDOTDIR:-$HOME}/bin" ]]; then
  export PATH="${ZDOTDIR:-$HOME}/bin:$PATH"
fi

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

#########################################
# System-dependent configuration - START
#########################################
determine-location
__location_id=$?

if [[ $__location_id -gt 1 ]]; then # both work laptop and its chroot
  if [[ `cat /etc/issue` =~ ".*Debian GNU/Linux.*" ||
              `nmcli conn show --active` =~ ".*Oracle lan.*" ||
              `nmcli conn show --active` =~ "clear" ]]; then
      export http_proxy=http://emea-proxy.uk.oracle.com:80
      export https_proxy=http://emea-proxy.uk.oracle.com:80
      export ftp_proxy=$http_proxy
      export sftp_proxy=$http_proxy
      export ssh_tunnel_port=7652
      # do not go through the proxy for the following
      export no_proxy="localhost,127.0.0.1,127.0.0.0/8,localaddress"
      # create an alias for starting things via tsocks and the socks5 proxy
      alias prx='http_proxy="socks5://localhost:${ssh_tunnel_port}" https_proxy="socks5://localhost:${ssh_tunnel_port}" tsocks'
  else
      unset http_proxy
      unset https_proxy
      git config --global --unset core.proxy
      git config --global --unset http.proxy
  fi
fi

# Configuration for both home dev and work laptop
if [[ $__location_id -eq 1 || $__location_id -eq 2 ]]; then
   source ~/.systemd_user.zsh

   if [[ $__location_id -eq 1 ]]; then # Configuration only for home dev (arch)
       . /usr/share/zsh/site-contrib/powerline.zsh
       # add android tools to the path
       export PATH="${ZDOTDIR:-$HOME}/opt/android/tools:$PATH"
   else # Configuration only for work laptop
       #add powerline.zsh for arch
       . /usr/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
   fi
fi

if [[ $__location_id -eq 3 ]]; then # work chroot only
    #for ssh-keychain (for now only in the developmentB machine)
    /usr/bin/keychain $HOME/.ssh/id_rsa
    source $HOME/.keychain/`hostname`-sh
    #add ccache wrapper to the path
    export PATH="/usr/lib/ccache:$PATH"
    #since for devwork it's a manual powerline install we need to add the bin
    #of powerline to the path too
    export PATH="$HOME/.local/bin:$PATH"
    #add powerline.zsh for devwork
    . ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
    # disabling zsh line editor for tramp connecting to this as remote
    # check here for more info: http://www.gnu.org/software/emacs/manual/html_node/tramp/Frequently-Asked-Questions.html
    [ $TERM = "dumb" ] && unsetopt zle && PS1='$ '
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
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
# make ALT + arrows keys move in words. The key sequence is a bit fucked up but work for my setup
bindkey "\e\e[D" backward-word
bindkey "\e\e[C" forward-word
