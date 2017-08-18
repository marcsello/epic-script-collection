#!/bin/bash

# THIS SCRIPT IS ONLY FOR LXDE!

# config

WALLPAPERS_FOLDER="/home/marcsello/wallpapers"
CHANGE_INTERVAL="10m" # m indicates minutes, you can use h, s or d (for days) as well
# keep in mind: counting starts from the startup of LXDE, not from the last change

# end of config

LASTPAPER=""
NEWPAPER=""

while sleep "$CHANGE_INTERVAL"; do

	pidof pcmanfm || exit 1 # exit if pcmanfm not running

	if xscreensaver-command -time | grep "non-blanked"; then # don't change when the screen is locked

		while [ "$LASTPAPER" == "$NEWPAPER" ]; do # do not set the same wallpaper twice

			NEWPAPER=$(find "$WALLPAPERS_FOLDER" -regex ".*\.\(jpg\|gif\|png\|jpeg\)" -type f | shuf -n1)

		done

		# set the new wallpaper

		pcmanfm -w "$NEWPAPER"
		LASTPAPER="$NEWPAPER"

	fi

done > /dev/null
