###
# Configuration ONLY for devwork (the VM I use at work for palladion)
###
if [[ `hostname` == "devwork" ]]; then
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


#from here and below it's for anything other than the virtual machine at work
if [[ `hostname` != "devwork" ]]; then

#make sure we got 256 color term 
export TERM=xterm-256color

#add local bin to the path
if [[ -s "${ZDOTDIR:-$HOME}/.local/bin" ]]; then
  source "${ZDOTDIR:-$HOME}/.local/bin"
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

###
# Configuration only for work laptop (arch)
###
if [[ `hostname` == "archlenovo" ]]; then
#add powerline.zsh for arch 
. /usr/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi

###
# Configuration only for home dev (arch) 
###
if [[ `hostname` == "archdesktop" ]]; then
. /usr/share/zsh/site-contrib/powerline.zsh
fi

# source my aliases
source ~/.zsh_aliases

fi #end of the non-virtual machine at work case
