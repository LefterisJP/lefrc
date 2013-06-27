#
# ~/.bashrc
#

if [ $HOSTNAME == "devwork" ]; then
#for ssh-keychain (for now only in the development machine)
/usr/bin/keychain $HOME/.ssh/id_rsa
source $HOME/.keychain/${HOSTNAME}-sh
#add ccache wrapper to the path
export PATH="/usr/lib/ccache:$PATH"
fi

# to get __git_ps1, as explained here: http://stackoverflow.com/questions/15384025/bash-git-ps1-command-not-found
source ~/.bash_git
# get bash aliases
source ~/.bash_aliases

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


PS1='[\u@\h \W]\$ '

# Adding android tools to the path
PATH=$PATH:~/opt/android/tools
#also add an alias for the emulator command as it is in its current state
alias anemu='emulator -sysdir ~/opt/android/system-images/android-17/x86/ -avd Test_Device'

# I originally got the PS1 customization script from http://mediadoneright.com/content/ultimate-git-ps1-bash-prompt
# which I later edited to take into account mercurial repositories and more
 
# Reset
Color_Off="\[\033[0m\]"       # Text Reset

# Regular Colors
Black="\[\033[0;30m\]"        # Black
Red="\[\033[0;31m\]"          # Red
Green="\[\033[0;32m\]"        # Green
Yellow="\[\033[0;33m\]"       # Yellow
Blue="\[\033[0;34m\]"         # Blue
Purple="\[\033[0;35m\]"       # Purple
Cyan="\[\033[0;36m\]"         # Cyan
White="\[\033[0;37m\]"        # White

# Bold
BBlack="\[\033[1;30m\]"       # Black
BRed="\[\033[1;31m\]"         # Red
BGreen="\[\033[1;32m\]"       # Green
BYellow="\[\033[1;33m\]"      # Yellow
BBlue="\[\033[1;34m\]"        # Blue
BPurple="\[\033[1;35m\]"      # Purple
BCyan="\[\033[1;36m\]"        # Cyan
BWhite="\[\033[1;37m\]"       # White

# Underline
UBlack="\[\033[4;30m\]"       # Black
URed="\[\033[4;31m\]"         # Red
UGreen="\[\033[4;32m\]"       # Green
UYellow="\[\033[4;33m\]"      # Yellow
UBlue="\[\033[4;34m\]"        # Blue
UPurple="\[\033[4;35m\]"      # Purple
UCyan="\[\033[4;36m\]"        # Cyan
UWhite="\[\033[4;37m\]"       # White

# Background
On_Black="\[\033[40m\]"       # Black
On_Red="\[\033[41m\]"         # Red
On_Green="\[\033[42m\]"       # Green
On_Yellow="\[\033[43m\]"      # Yellow
On_Blue="\[\033[44m\]"        # Blue
On_Purple="\[\033[45m\]"      # Purple
On_Cyan="\[\033[46m\]"        # Cyan
On_White="\[\033[47m\]"       # White

# High Intensty
IBlack="\[\033[0;90m\]"       # Black
IRed="\[\033[0;91m\]"         # Red
IGreen="\[\033[0;92m\]"       # Green
IYellow="\[\033[0;93m\]"      # Yellow
IBlue="\[\033[0;94m\]"        # Blue
IPurple="\[\033[0;95m\]"      # Purple
ICyan="\[\033[0;96m\]"        # Cyan
IWhite="\[\033[0;97m\]"       # White

# Bold High Intensty
BIBlack="\[\033[1;90m\]"      # Black
BIRed="\[\033[1;91m\]"        # Red
BIGreen="\[\033[1;92m\]"      # Green
BIYellow="\[\033[1;93m\]"     # Yellow
BIBlue="\[\033[1;94m\]"       # Blue
BIPurple="\[\033[1;95m\]"     # Purple
BICyan="\[\033[1;96m\]"       # Cyan
BIWhite="\[\033[1;97m\]"      # White

# High Intensty backgrounds
On_IBlack="\[\033[0;100m\]"   # Black
On_IRed="\[\033[0;101m\]"     # Red
On_IGreen="\[\033[0;102m\]"   # Green
On_IYellow="\[\033[0;103m\]"  # Yellow
On_IBlue="\[\033[0;104m\]"    # Blue
On_IPurple="\[\033[10;95m\]"  # Purple
On_ICyan="\[\033[0;106m\]"    # Cyan
On_IWhite="\[\033[0;107m\]"   # White

# Various variables you might want for your PS1 prompt instead
Time12h="\T"
Time12a="\@"
PathShort="\w"
PathFull="\W"
NewLine="\n"
Jobs="\j"
user="\u"
host="\h"

#checks the directory for existence or not of a repository 
check_dir() {
echo '$(\
git branch &>/dev/null;\
if [  $? -eq 0 ]; then \
  #if we have a GIT repository
  echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
  if [  "$?" -eq "0" ]; then \
    # Clean repository - nothing to commit
    echo "'$Green'"$(__git_ps1 " (%s)"); \
  else \
    # There are changes to the working tree
    echo "'$IRed'"$(__git_ps1 " {%s}"); \
  fi) '$BYellow$PathShort$Color_Off'\$ "; \
else \
  # NOT A git Repo
  echo "$(hg branch &>/dev/null;\
  if [  $? -eq 0 ]; then\
    # If we have a MERCURIAL repository
    echo "$( \
     if [ `hg status | wc -l` -ne "0" ]; then \
        # If the Mercurial repository has changes
        echo "'$IRed'" "("$(hg branch)")";\
     else \
        # If the Mercurial repository has no changes
        echo "'$Green'" "("$(hg branch)")";\
    fi) '$BYellow$PathShort$Color_Off'\$ "; \
  else \
      # NOT A REPOSITORY 
      echo " '$Yellow$PathShort$Color_Off'\$ "; \
  fi)"
fi)'

}

export PS1=$IWhitek$user@$host$Color_Off$(check_dir)
