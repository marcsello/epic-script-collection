#!/bin/bash

# set service names here
SERVICES=( "apache2" "vsftpd" "sshd" "smbd" "nmbd" "cykabylat" );

# mail about failure will sent to this user;leave empty to disable this feature
SYSADMIN_NAME="marcsello"

# used to store service restart failures
SUPPRESS_ERRORS="/var/service_watchdog.supress"

# log... must rotate somehow
LOGFILE_PATH="/var/log/service_watchdog.log"

# no need to bother this part

# echo "$('date') Service Watchdog run" >> "$LOGFILE_PATH"

if [ ! -f "$SUPPRESS_ERRORS" ]; then
	touch "$SUPPRESS_ERRORS"
fi

MESSAGE_SUFFIX=" fails to restart!"
for service in "${SERVICES[@]}"; do
	pidof "$service" > /dev/null
	if [ "$?" != "0" ]; then #if not running (pidof returns not zero)

		# check if this process failed to restart in the past
		cat "$SUPPRESS_ERRORS" | grep "$service" > /dev/null 2>&1

		if [ "$?" != "0" ]; then # this service is not failed to restart yet
			service "$service" restart > /dev/null 2>&1 # so we try to restart it
			if [ "$?" != "0" ]; then  # failed to restart, report it! and add to suppress list
				REPORT_MSG="$service $MESSAGE_SUFFIX"
				echo "$('date') $REPORT_MSG" >> "$LOGFILE_PATH"
				if [ "$SYSADMIN_NAME" != "" ]; then
					printf "$REPORT_MSG\nPlease do \"rm $SUPPRESS_ERRORS\" after fixing!" | mail mail -s "Service failure" "$SYSADMIN_NAME"
				fi
				echo "$service" >> "$SUPPRESS_ERRORS"
			else # restart was a success
				echo "$('date') $service found dead restarting it was successful!" >> "$LOGFILE_PATH"
			fi

		fi # if it does failed to restart in the past, we leave it alone

	fi
done 
