#!/bin/bash

# configuration -------------------------------------------------------------------------------------------

# set service names here
SERVICES=( "apache2" "vsftpd" "sshd" "smbd" "nmbd" );

# mail about failure will sent to this user; leave empty to disable this feature
SYSADMIN_NAME=""

# used to store service restart failures
SUPPRESS_ERRORS="/var/service_watchdog.supress"

# log... must rotate somehow
LOGFILE_PATH="/var/log/service_watchdog.log"

# maximum lines of the logfile; old entries will be removed
LOGFILE_MAX_LINES="2000"

# configuration ends here  -------------------------------------------------------------------------------

# prepare

[ ! -f "$SUPPRESS_ERRORS" ] && touch "$SUPPRESS_ERRORS"
[ ! -f "$LOGFILE_PATH" ] && touch "$LOGFILE_PATH"

# actual job

for service in "${SERVICES[@]}"; do

        systemctl status "$service" > /dev/null 2>&1

        if [ "$?" != "0" ]; then # if not running (status returns non-zero)

                # check if this process failed to restart in the past
                cat "$SUPPRESS_ERRORS" | grep "$service" > /dev/null 2>&1

                if [ "$?" != "0" ]; then # this service is not failed to restart yet

                 systemctl start "$service" > /dev/null 2>&1 # so we try to restart it

                 if [ "$?" != "0" ]; then  # failed to restart, report it! and add to suppress list
                        REPORT_MSG="$service fails to restart!"
                        echo "$('date') $REPORT_MSG" >> "$LOGFILE_PATH"
                        if [ "$SYSADMIN_NAME" != "" ]; then
                            echo "$REPORT_MSG" | mail mail -s "Service failure" "$SYSADMIN_NAME"
                        fi
                        echo "$service" >> "$SUPPRESS_ERRORS" # record it
                 else # restart was a success
                        echo "$('date') $service found dead restarting it was successful!" >> "$LOGFILE_PATH"
                 fi

                fi # if it does failed to restart in the past, we leave it alone

        else # it's running now

                cat "$SUPPRESS_ERRORS" | grep "$service" > /dev/null 2>&1

                if [ "$?" == "0" ]; then # it was suppressed before... but now it's running, yay

                 sed -i "/$service/d" "$SUPPRESS_ERRORS"
                 echo "$('date') $service is doing fine, removed from suppress list" >> "$LOGFILE_PATH"

                fi


        fi
done


# rotate logfile

logfile_len=$(cat "$LOGFILE_PATH" | wc -l)

if [ "$logfile_len" -gt "$LOGFILE_MAX_LINES" ]; then

        logfile_tmp=$(tail -n "$LOGFILE_MAX_LINES" "$LOGFILE_PATH") # must store it temporarly, directly piping it back causes an empty file
        echo "${logfile_tmp}" > "$LOGFILE_PATH"

fi
