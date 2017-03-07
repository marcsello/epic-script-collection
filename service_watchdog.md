# Service Watchdog
Service Watchdog Bash Script with failure reporting

Designed and tested on Debian 8

## Important!
This script is supposed to run by _cron_ with the frequency of your choice!

## How it works:
Every run this script checks a given list of services (like apach2 mysql etc. ) If some of those are dead, it tries to restart it, if the service fails to restart, it will send a mail to the sysadmin (only one)

## Download:
To download only this single script, use this link:  
https://raw.githubusercontent.com/marcsello/epic-script-collection/master/service_watchdog.sh

## Setup:
After you download the script, put it somewhere on your server, then open it for editing
and change the following lines:

- Enter the service names you want to keep track of:

`SERVICES=( "apache2" "vsftpd" "sshd" "smbd" "nmbd" "mysqld" );`

- Enter the username of the account you usually log in to your server to receive the mails (like `marcsello`) or leave it empty to disable mail sending feature:

`SYSADMIN_NAME=""`

- This is where the logfile stored, you don't really need to change this :

`LOGFILE_PATH="/var/log/service_watchdog.log"`

- And this is where the list stored of processes that are fails to restart (prevents spamming)

`SUPPRESS_ERRORS="/var/service_watchdog.supress"`

Then save your file, and add it to your crontab to run it something like every two hours or so...

## TODO
- smarten reporting
