#!/bin/bash

# config:

DEFAULT_PORT=":1"
GEOMETRY="1024x600"

# don't bother the script from this point

# reading argument

if [ "$1" = "-h" ] || [ "$1" = "--help"  ]; then
 # help text
 echo "Usage: "
 echo "$0 [-h|--help] [:port]"
 echo "Port format must be something like this: \":0\""
 echo "If Port is not specified, $DEFAULT_PORT will be used"
 exit 0
elif [[ "$1" =~ ^:[0-9]+ ]]; then
 # the arugment is a valid port
 echo "Using port $1"
 PORT="$1"
else
 # I don't really care any other argument
 echo "No display port given, using $DEFAULT_PORT!"
 PORT="$DEFAULT_PORT"
fi

PIDFILE_LOC=$HOME'/.vnc/'$HOSTNAME''$PORT'.pid'

# show menu
PS3='What do you want? '
options=("Start VNC" "Stop VNC" "Check State" "Nothing")
select OPT in "${options[@]}"
do
    case $OPT in
        "${options[0]}")
            echo "Starting VNC..."
                        vncserver "$PORT" -geometry "$GEOMETRY" -depth 24
                break
            ;;
        "${options[1]}")
            echo "Stopping VNC..."
                        vncserver -kill "$PORT"
                break
            ;;
        "${options[2]}")
            [ -f "$PIDFILE_LOC" ] && echo "VNC Server Running" || echo "VNC Server Down"
            ;;
                "${options[3]}")
            echo "kthxbai"
                break
            ;;
        *) echo "invalid option";;
    esac
done
