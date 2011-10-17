#!/bin/bash
set -o nounset
set -e
#FIXME NOTIFY variable fails if which does not find a notify-send or an aosd_cat, commenting line, this will break declutter
_LIBSH_QUIET="no"
#_LIBSH_NOTIFY="`which notify-send` -i /usr/share/notify-osd/icons/gnome/scalable/status/notification-device-usb.svg `basename "$0"`" || `which aosd_cat` -n 20
_LIBSH_NOTIFY="echo"

# #Colors
bold="`tput bold`" 
nobold="`tput sgr0`"
ul="`tput smul`"
noul="`tput rmul`"
red="`tput setaf 1`"
green="`tput setaf 2`"
yellow="`tput setaf 3`"
blue="`tput setaf 4`"
magenta="`tput setaf 5`"
cyan="`tput setaf 6`"
white="`tput setaf 7`"

nocolor="`tput setaf 9`"

#Utility functions
log() 		{ logger -i -t "`basename "$0"`" "$@"; }
logInfo() 	{ log "INFO: $@"; echostderr "${bold}INFO:${nobold} $@"; }
logError()	{ log "ERROR: $@"; echostderr "${red}ERROR:${nocolor} $@"; }
logWarning() 	{ log "WARNING: $@";  echostderr "${green}WARNING:${nocolor} $@"; }
echostderr()	{ echo  -e "$@" 1>&2; } 
#Notify using OSD or notify daemons
notify()	{ [ "$_LIBSH_QUIET" = "yes" ] || $_LIBSH_NOTIFY "$@"; logInfo "$@"; }
#Convert human sizes (10G, 5M or 10K) to bytes
kmg2b()		{ echo "$1" | sed -e 's/\([0-9.]\+\)[Gg]/\1*1073741824/
			              s/\([0-9.]\+\)[Mm]/\1*1048576/
			              s/\([0-9.]\+\)[Kk]/\1*1024/
			              s/\([0-9.]\+\) *\(bytes\|[bB]\)/\1/' | bc -l | xargs printf "%1.0f"; }
#Convert bytes to human sizes (e.g. 10G, 8M, 10K, 5 bytes)
b2kmg()		{ if [ $1 -lt  1024 ]; then echo "$1 bytes";
		  elif [ $1 -lt  1048576 ]; then echo "$1/1024" | bc -l | xargs printf "%1.1fK"; 
	       elif [ $1 -lt 1073741824 ]; then  echo "$1/1048576" | bc -l | xargs printf "%1.1fM";
		  else echo "$1/1073741824" | bc -l | xargs printf "%1.1fG"; fi; }
#Size of directory in bytes
dirsize()	{ du -sk "$ROOT/$1" | cut -f 1 | xargs expr 1024 \* ; }

