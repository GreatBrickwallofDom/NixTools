#!/bin/bash

######################################################################################################
# Custom bashrc commands.
# Some modifications needed   ¯\_(ツ)_/¯
# Cherry picked from http://www.tldp.org/LDP/abs/html/sample-bashrc.html
######################################################################################################

#============================================================
#
#  ALIASES AND FUNCTIONS
#
#  Arguably, some functions defined here are quite big.
#  If you want to make this file smaller, these functions can
#+ be converted into scripts and removed from here.
#
#============================================================

#-------------------------------------------------------------
# Personnal Aliases
#-------------------------------------------------------------

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# -> Prevents accidentally clobbering files.
alias mkdir='mkdir -p'

alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'

# Pretty-print of some PATH variables:
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'


alias du='du -kh'    # Makes a more readable output.
alias df='df -kTh'

alias grep='grep -i'    # always use case insensitive grep

alias hcf='shutdown -h now'    # Halt and catch fire

alias shred='shred -n 1 --zero -vvv'     # call shred with zero option to hide shredding by default

alias vncviewer='vncviewer -encoding tight -bgr233 -compresslevel 9 -quality 2 -depth 8'    #Run vncviewer with high compression by default

## Games
alias spaceinvaders='ninvaders'
alias moonbuggy='moon-buggy'
alias tetris='bastet'
alias snake='nsnake'
alias pacman='myman'
alias games='echo spaceinvaders, moonbuggy, tetris, snake, pacman'

#-------------------------------------------------------------
# Work related aliases/functions
#-------------------------------------------------------------

#Google Cloud aliases
alias gcp='gcloud compute'
alias gcpsp='gcloud config set project'
alias gcpsh='gcloud compute ssh'
alias gcpsc='gcloud compute scp'

alias conp='~/scripts/connect.sh'    # run open connection to a pod (will list pods if none specified)

#Testssl from https://github.com/drwetter/testssl.sh/releases
alias testssl='~/scripts/testssl/testssl.sh'


#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls).
#-------------------------------------------------------------
# Add colors for filetype and  human-readable sizes by default on 'ls':

alias l='ls -CF'
if [[ $machine != "Mac" ]]; then
	alias ls='ls -larth --color'
else
	alias ls='ls -larth'
fi
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.
alias lsv='/bin/ls -lart --color'  # Verbose ls, will list files without truncating file size

# The ubiquitous 'll': directories first, with alphanumeric sorting:
if [[ $machine != "Mac" ]]; then
	alias ll="ls -lv --group-directories-first"
else
	alias ll="ls -lv"
fi
alias lm='ll |more'        #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...

#-------------------------------------------------------------
# Tailoring 'less'
#-------------------------------------------------------------

alias more='less'
export PAGER=less
export LESSCHARSET='latin1'
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
                # Use this if lesspipe.sh exists.
export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#-------------------------------------------------------------
# Spelling typos - highly personnal and keyboard-dependent :-)
#-------------------------------------------------------------

alias xs='cd'
alias vf='cd'
alias moer='more'
alias moew='more'
alias kk='ll'
alias histroy='history'
