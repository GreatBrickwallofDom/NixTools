#!/bin/bash

#

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [[ $HOSTNAME = *.fanops.net ]]; then
   source ~/.bash_profile
fi

# BEGIN SETUP PATHS
# This method should avoid duplicates if any and add useful paths rubi specific
function addToPATH {
  if [ -d "$1" ]; then
    case ":$PATH:" in
      *":$1:"*) :;; # already there
      *) PATH="$1:$PATH";; # or PATH="$PATH:$1"
    esac
  fi
}

addToPATH /sbin
addToPATH /usr/lib64/qt-3.3/bin
addToPATH /usr/local/bin
addToPATH /usr/bin
addToPATH /usr/local/sbin
addToPATH /usr/sbin
addToPATH /opt/puppetlabs/bin
addToPATH $HOME/.local/bin
addToPATH $HOME/bin

export PATH
# END SETUP PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/dominik/Downloads/google-cloud-sdk/path.bash.inc' ]; then source '/home/dominik/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/dominik/Downloads/google-cloud-sdk/completion.bash.inc' ]; then source '/home/dominik/Downloads/google-cloud-sdk/completion.bash.inc'; fi




# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#Check which platform we are running on
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac
                echo "Using a ${machine}, nerfing Bash  ¯\_(ツ)_/¯"
                ;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
                echo "Unable to determine what [ ${unameOut} ] is..."
esac




# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.
# For example, I see 'Bold Red' as 'orange' on my screen,
# hence the 'Green' 'BRed' 'Red' sequence I often use in my prompt.


# Normal Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

NC="\033[m"               # Color Reset


ALERT="${BWhite}${On_Red} (A)  " # Bold White on red background
WARNING="${Black}${On_Yellow} (W)  "
INFO="${Black}${On_White} (I)  "

