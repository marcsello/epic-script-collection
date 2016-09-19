#!/bin/bash

# device address in rfkill (default is usually 0)
WIFI_DEV_ID=0
# device alias of the wifi device (wlan0)
WIFI_DEV_ALIAS=wlan0
# seconds to wait after unblocking device
WAIT_FOR_UNBLOCK=16

if [ "$EUID" -ne 0 ]
  then echo "Run as root pls!"
  exit
fi

echo "Checking..."

GATEWAY=$(ip r | grep default | cut -d ' ' -f 3 | head -1)

if [[ $GATEWAY =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then

ping -c 1 -w 1 -q $GATEWAY > /dev/null

if [ $? -eq 0 ]; then
 echo "Network connection alive no messing required"
 exit
fi

fi

HARDBLOCK_STAT=$(rfkill list $WIFI_DEV_ID | grep Hard | cut -d ' ' -f 3)

if [ $HARDBLOCK_STAT = "yes" ]; then
 echo "Wifi module is Hard Blocked! Press the h/w Wi-Fi button to unblock!"
 echo "If the script hangs at this point, you have to kill it"
 
  while [ $HARDBLOCK_STAT = "yes" ]; do
   sleep 1
   HARDBLOCK_STAT=$(rfkill list $WIFI_DEV_ID | grep Hard | cut -d ' ' -f 3)
  done
 
 echo "Arigatou!"
 sleep $WAIT_FOR_UNBLOCK
fi

SOFTBLOCK_STAT=$(rfkill list $WIFI_DEV_ID | grep Soft | cut -d ' ' -f 3)

if [ $SOFTBLOCK_STAT = "yes" ]; then
 rfkill unblock $WIFI_DEV_ID

 echo "Softblock released, is device up now? (Y/N)"

  while read -r -n 1 -s answer; do
	if [[ $answer = [Yy] ]]; then
	 echo "Then iz done"
	 exit
	elif [[ $answer = [Nn] ]]; then
	 break
	fi
  done

fi

ifconfig $WIFI_DEV_ALIAS | grep UP > /dev/null

if [ $? -eq 0 ]; then
 echo "Wifi should up!"
 exit
fi


echo "Trying to wake $WIFI_DEV_ALIAS"

ifconfig $WIFI_DEV_ALIAS up

if [ $? -eq 0 ]; then
 echo "Wifi should be up now!"
 exit
fi

echo "Fail. Retry with full unblock"
rfkill unblock all
ifconfig $WIFI_DEV_ALIAS up

if [ $? -eq 0 ]; then
 echo "It should be up now!"
 echo "If not, then this script can't turn on your wifi"
 echo "Check the preferences, and if drivers installed"
 exit
fi

echo "Im rekt"
