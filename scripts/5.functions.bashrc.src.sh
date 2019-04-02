#!/bin/bash


#-------------------------------------------------------------
# File & strings related functions:
#-------------------------------------------------------------

function swap() { # Swap 2 filenames around, if they exist (from Uzi's bashrc).
    local TMPFILE=tmp.$$

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

function extract() {     # Handy Extract Program
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# Creates an archive (*.tar.gz) from given directory.
function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }

# Create a ZIP archive of a file or folder.
function makezip() { zip -r "${1%%/}.zip" "$1" ; }

# Create a stupid archive of many layers
function stupidzip() {
  tar cvzf "${1%%/}.tar.gz"  "${1%%/}/";
  stupidzip1="${1%%/}.tar.gz"
  zip -r "${stupidzip1}.zip" "$stupidzip1";
  stupidzip1="${stupidzip1}.zip"
  p7zip "$stupidzip1";
  stupidzip1="${stupidzip1}.7z"
  tar cvjf "${stupidzip1%%/}.tar.bz2"  "${stupidzip1%%/}/";
  printf "\nRemoving\n ${1%%/}.tar.gz \n ${1%%/}.tar.gz.zip.7z"
  rm -f "${1%%/}.tar.gz" && rm -f "${1%%/}.tar.gz.zip.7z"
  printf "\n\n$1 --> $stupidzip1 \n"
}

# Make your directories and files access rights sane.
function sanitize() { chmod -R u=rwX,g=rX,o= "$@" ;}


#-------------------------------------------------------------
# Process/system related functions:
#-------------------------------------------------------------


function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }


#Needs a check causes huge error in VSCode 
#function killps()   # kill by process name
#{
#    local pid pname sig="-TERM"   # default signal
#    if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
#        echo "Usage: killps [-SIGNAL] pattern"
#        return;
#    fi
#    if [ $# = 2 ]; then sig=$1 ; fi
#    for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} ); do  ##This line fails check in vscode look into
#        pname=$(my_ps | awk '$1~var { print $5 }' var=$pid )
#        if ask "Kill process $pid <$pname> with signal $sig?"
#            then kill $sig $pid
#        fi
#    done
#}

function mydf() {        # Pretty-print of 'df' output. Inspired by 'dfc' utility.
    for fs ; do

        if [ ! -d $fs ]
        then
          echo -e $fs" :No such file or directory" ; continue
        fi

        local info=( $(command df -P $fs | awk 'END{ print $2,$3,$5 }') )
        local free=( $(command df -Pkh $fs | awk 'END{ print $4 }') )
        local nbstars=$(( 20 * ${info[1]} / ${info[0]} ))
        local out="["
        for ((j=0;j<20;j++)); do
            if [ ${j} -lt ${nbstars} ]; then
               out=$out"*"
            else
               out=$out"-"
            fi
        done
        out=${info[2]}" "$out"] ("$free" free on "$fs")"
        echo -e $out
    done
}


function my_ip() { # Get IP adress on ethernet.
    MY_IP=$(/sbin/ifconfig enp0s31f6 | awk '/inet/ { print $2 } ' |
      sed -e s/addr://)
    echo eth0:${MY_IP:-"Not connected"}
    MY_IPW=$(/sbin/ifconfig wlp4s0 | awk '/inet/ { print $2 } ' |
      sed -e s/addr://)
    echo wlan0:${MY_IPW:-"Not connected"}
}

#function my_ipw() # Get IP adress on wifi.
# {
#    MY_IP=$(/sbin/ifconfig wlp4s0 | awk '/inet/ { print $2 } ' |
#      sed -e s/addr://)
#    echo ${MY_IP:-"Not connected"}
#}

function ii() {  # Get current host related info.
    echo -e "\nYou are logged on ${BRed}$HOST"
    echo -e "\n${BRed}Additionnal information:$NC " ; uname -a
    echo -e "\n${BRed}Users logged on:$NC " ; w -hs |
             cut -d " " -f1 | sort | uniq
    echo -e "\n${BRed}Current date :$NC " ; date
    echo -e "\n${BRed}Machine stats :$NC " ; uptime
    echo -e "\n${BRed}Memory stats :$NC " ; free
    echo -e "\n${BRed}Diskspace :$NC " ; mydf / $HOME
    echo -e "\n${BRed}Local IP Address :$NC" ; my_ip
    echo -e "\n${BRed}Open connections :$NC "; netstat -pan --inet;
    echo
}

#-------------------------------------------------------------
# Misc utilities:
#-------------------------------------------------------------

function repeat() {       # Repeat n times command.
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}

# Better ssh, copy bashrc to homedir and use as temp bashrc delete when done
# accepts short names for rubi fqdns 
function s() {
  if [[ $1 =~ f[a-z]{3}-[a-z]{3}[0-9]{4}\.[a-z]{3}[0-9]{1}$ ]]; then
    local targetHost="$1.fanops.net"
  else
    local targetHost="$1"
  fi
  printf "\n${INFO}Setting up the environment, please hold on.${NC}\n"
  local BrcTmpName=$(openssl rand -hex 16).bashrc_tmp
  rsync -avPz --no-motd ~/.bashrc $targetHost:~/.$BrcTmpName
  rsync -avPz --no-motd ~/scripts $targetHost:~/.
  clear
  printf "\n${INFO}Openeing SSH session to $targetHost ${NC}\n" 
  ssh -t $targetHost "bash --rcfile ~/.$BrcTmpName ; rm ~/.$BrcTmpName"
}

if [[ $machine != "Mac" ]]; then
	function aptclean() {    # clean out old packages
	    sudo apt-get update
	    sudo apt-get autoremove
	    sudo apt-get autoclean
	}

	function aptup() {       # run apt update and clean unused packages
	    echo "Running 'apt-get update'" && sleep 2 && \
	    sudo apt-get update && \
	    echo "Cleaning unused packages" && sleep 2 && \
	    aptclean
	    echo "Running 'apt-get upgrade'" && sleep 2 && \
	    sudo apt-get upgrade && \
	    echo "Running DIST-UPGRADE" && sleep 2 && \
	    sudo apt-get dist-upgrade
	}
fi

# Calculator; use it by typing calc followed by your equation  [ calc 8*22/4 ]
calc() {
    if [ $# -eq 0 ]
	then
		echo error: input an equation
	else
		awk "BEGIN{ print $* }" ;
    fi
}

# Clear caches and sync the buffer
if [[ $machine != "Mac" ]]; then
	ccache() {
	    su -c "sync && echo 1 >'/proc/sys/vm/drop_caches' && printf '\n%s\n' 'Ram-cache and Swap Cleared'" root
	}
fi

# Search all pidgin chat logs for string
function chatfind() {
  if [ $# -eq 0 ]
  then
    printf 'Usage:  chatfind [SEARCH STRING] [OPTIONAL EGREP ARGS] \n'
  else
    printf "Searching all pidgin chat logs for < $1 > .... \n"
    find ~/.purple/logs/ -name "*" -type f -exec egrep -i -H --color ${@:2} "$1" {} \;
  fi
}

# Search all gitrepos for string
function gitfind() {
  if [ $# -eq 0 ]
  then
    printf 'Usage:  gitfind [SEARCH STRING] [OPTIONAL EGREP ARGS] \n'
  else
    printf "Searching all GitRepos for < $1 > .... \n"
    find ~/GitRepos/ -name "*" -type f -exec egrep -i -H --color ${@:2} "$1" {} \;
  fi
}

# Gen a random passwd with the specified number of characters. Usage:   genpasswd 5
function genpasswd() {
	local l=$1
	[ "$l" == "" ] && l=20
	if [[ $machine != "Mac" ]]; then
		tr -dc 0-z\#-\&! < /dev/urandom | head -c ${l} && printf "\n"
	else
		#macos handles tr differently use openssl instead
		let l2=$l*4
        #LC_CTYPE=C tr -dc [0-z\#-\&!][^/\\] < /dev/urandom | head -c${l} && printf "\n"
		openssl rand -base64 ${l2} | tr -dc 0-z\#-\&! | head -c${l}; echo
	fi
}

######
# Arsenal functions rubi
######
#arsenal nodes search
function ans() {
	if [[ $# < 1 ]]; then
		printf "Usage:\n ~$ ans <name> <field>\n Field is optional only if you want more info, wrap in "" for extraneous regex\n\n"
	else
		#~/scripts/arsenal-wrapper.sh -n $1 $(if [[ $2 != "" ]]; then echo "-f $2"; fi)
		#if only name is provided control will enter here
		if [[ $2 == "" ]]; then
			printf "Searching arsenal for host \"$1\"\n\n"
			arsenal nodes search name="$1"
		else
			printf "Searching arsenal for host \"$1\" and field \"$2\"\n\n"
			arsenal nodes search name="$1" --fields "$2"
		fi
	fi
}

#arsenal nodes update (takes an action and updates a host field)
function anu() {
	if [[ $# < 3 ]]; then
		printf "Usage:\n ~$ anu <name> <field> <new-value> \n\n"
	else
		#~/scripts/arsenal-wrapper.sh -n $1 -f $2 -u $3
		if [ $1 == "" ] || [ $2 == "" ] || [ $3 == "" ]; then
			printf "\nSomethings missing.... \n Name: $1 \n Field: $2 \n Update: $3 \n"
		else
			arsenal nodes search name="$1" --fields "$2"
			printf "\nUpdating $2 to $3 on host $1 \n"
			arsenal nodes search name="$1" --"$2" "$3"
		fi
	fi
}

#arsenal group search
function ags() {
	if [[ $# < 1 ]]; then
		printf "Usage:\n ~$ ags <grp-name> <field>\n\n ex. \n  ~$ ags frp_ade owner"
	else
		#~/scripts/arsenal-wrapper.sh -n $1 -f $2 -g
		arsenal node_groups search name="$1" -f "$2"
	fi
}


######
# Cobbler functions rubi
######
#cobbler system report
function csr () {
  if [[ $# < 1 ]]; then
		printf "Usage:\n ~$ csr <name>"
	else
		#if only name is provided control will enter here
    printf "Searching arsenal for host \"$1\"\n\n"
    sudo cobbler system report --name="$1"
	fi
}


##############################################
# End of custom scripts and bash preferences
##############################################

#Shit to mess with ryan
#alias ls='lsrand'
function lsrand(){
        rand1=$(shuf -i1-6 -n1)
        rand2=$(shuf -i1-8 -n1)
        if [ $rand1 -eq 1 ]
        then
                /bin/ls "$@"
                sed "${rand2}q;d" ~/.bash_history
                if [ $rand2 -eq 1 ]
                then
                  printf "This is why we cant have nice things, Ryan!\n"
                fi
        else
                /bin/ls "$@"
        fi
}
