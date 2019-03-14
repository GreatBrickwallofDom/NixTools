#!/bin/bash

if [ -x /usr/bin/mint-fortune ]; then
     /usr/bin/mint-fortune
fi


# If not running interactively, don't do anything
[ -z "$PS1" ] && return


#-------------------------------------------------------------
# Greeting, motd etc. ...
#-------------------------------------------------------------

echo -e "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${BCyan}\
- DISPLAY on ${BRed}$DISPLAY${NC}"
uname -a
printf "$Green \n$(cat ~/scripts/tux.asc)\n $NC"
date
if [ -x /usr/games/fortune ]; then
    /usr/games/fortune -s     # Makes our day a bit more fun.... :-)
fi

# Function to run upon exit of shell.
function _exit() {             
    echo -e "${BRed}Hasta la vista, baby${NC}"
}
trap _exit EXIT


# Test ssh connection type:
if [ -n "${SSH_CONNECTION}" ]; then
    CNX=${Green}        # Connected on remote machine, via ssh (good).
elif [[ "${DISPLAY%%:0*}" != "" ]]; then
    CNX=${ALERT}        # Connected on remote machine, not via ssh (bad).
else
    CNX=${BCyan}        # Connected on local machine.
fi

# Test user type:
if [[ ${USER} == "root" ]]; then
    SU=${Red}           # User is root.
elif [[ ${USER} != $(logname) ]]; then
    SU=${BRed}          # User is not login user.
else
    SU=${BCyan}         # User is normal (well ... most of us are).
fi

if [[ $machine != "Mac" ]]; then
	NCPU=$(grep -c 'processor' /proc/cpuinfo)    # Number of CPUs
	SLOAD=$(( 100*${NCPU} ))        # Small load
	MLOAD=$(( 200*${NCPU} ))        # Medium load
	XLOAD=$(( 400*${NCPU} ))        # Xlarge load
fi

# Returns system load as percentage, i.e., '40' rather than '0.40)'.
function load() {
    # System load of the current host.
    if [[ $machine == "Mac" ]]; then
        local SYSLOAD=$(uptime | cut -d":" -f4- | sed s/,//g | cut -f 2 -d " " - | tr -d '.')
        #local SYSLOAD=${SYSLOAD%?}
        echo $SYSLOAD
    else
        local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.')
        echo $((10*$SYSLOAD))  # Convert to decimal.
    fi
}

# Returns a color indicating system load.
function load_color() {
    local SYSLOAD=$(load)
    if [ ${SYSLOAD} -gt ${XLOAD} ]; then
        echo -en ${ALERT}
    elif [ ${SYSLOAD} -gt ${MLOAD} ]; then
        echo -en ${Red}
    elif [ ${SYSLOAD} -gt ${SLOAD} ]; then
        echo -en ${BRed}
    else
        echo -en ${Green}
    fi
}

# Returns a color according to free disk space in $PWD.
function disk_color() {
    if [ ! -w "${PWD}" ] ; then
        echo -en ${Red}
        # No 'write' privilege in the current directory.
    elif [ -s "${PWD}" ] ; then
        local used=$(command df -P "$PWD" |
                   awk 'END {print $5} {sub(/%/,"")}')
        if [ ${used} -gt 95 ]; then
            echo -en ${ALERT}           # Disk almost full (>95%).
        elif [ ${used} -gt 90 ]; then
            echo -en ${BRed}            # Free disk space almost gone.
        else
            echo -en ${Green}           # Free disk space is ok.
        fi
    else
        echo -en ${Cyan}
        # Current directory is size '0' (like /proc, /sys etc).
    fi
}
