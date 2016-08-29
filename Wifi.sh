#!/bin/bash

#
# 01/06/2013
# This script attempts to semi-automate the wifi connection process from the command line.
# It is intended to be used on a headless machine without the requirement of typing several commands for a connection.
# The script stores previous connection credentials in PLAINTEXT as *.wpa files in the executed directory and in /etc/wpasupplicant.conf.  These .wpa files are used to connect to several different ap using  previously stored info.
# Probably a good idea to stop and other network managing software while running this script, also in testing wpa_supplicant does a pretty good job of re-connecting a disassociated link automatically.
#
# Mainly created from a combination of scripts taken from theses two sources:
# http://www.backtrack-linux.org/forums/archive/index.php/t-3367.html
# AND
# http://www.linuxquestions.org/questions/linux-general-1/wifi-connect-script-tested-in-ubuntu-772646/
#
# Copy, Distribute and Modify Freely.
#


INT=$1

if [ -z "$1" ]; then
	printf "Usage: $0 [interface]\n"
	exit
fi

if [ "$(id -u)" != "0" ]; then
	printf "This script must be run as root\n" 1>&2
	exit
fi

#
# Search for previous saved config files
#
function read_saved {
	#
	# Search for previous wpa configuration files.
	#

	#
	# Save and change IFS so spaces in file names are not interpreted as separate lines in the array
	#
	OLDIFS=$IFS
	IFS=$'\n'

	#
	# Read all file names into an array ref:http://www.cyberciti.biz/tips/handling-filenames-with-spaces-in-bash.html
	# " -printf '%f\n' " removes path info from outputs ref:http://serverfault.com/questions/354403/remove-path-from-find-command-output
	#
	SAVED_LIST=($(find . -type f -name "*.wpa" -printf '%f\n'))

	#
	# restore ifs
	#
	IFS=$OLDIFS


	#
	# Tests for number of saved wifi connections, if none exit
	#
	if [ -z "${SAVED_LIST[0]}" ]; then
		printf "There are no previous saved wifi connections\n\n"
		#
		# Create new connection
		#
		conf_create
	fi

	#
	#PS3 Sets the prompt for the select statement below
	#
	PS3="Choose a previously saved wifi connection or 's' to skip: "

#
#Select one of the previous saved configurations to connect with or quit
#
select ITEM in "${SAVED_LIST[@]}"; do
	#
	# Quit if selected number does not exist or alpha in entered
	#
	if [ -z "$ITEM" ] ; then
			printf "Skipping\n"
			conf_create
	fi

	printf "$ITEM is selected\n"
	cat "$ITEM">/etc/wpa_supplicant.conf | xargs
	connect "$ITEM"
done
}

function conf_create (){
	#
	# Scans for wifi connections & isolates wifi AP name
	#
	eval LIST=( $(sudo iwlist $INT scan 2>/dev/null | awk -F":" '/ESSID/{print $2}') )

	#
	#PS3 Sets the prompt for the select statement below
	#
	PS3="Choose wifi connection or 'q' to quit: "

	#
	# Tests for number of wifi connections, exits if none
	#
		if [ -z "${LIST[0]}" ]; then
			printf "No available wifi connection using $INT\n"
			exit
		fi

	#
	# Select from a LIST of scanned connections
	#
	select ITEM in "${LIST[@]}"; do
	ifconfig $INT | grep inet

		#
		# Quit if selected number does not exist or alpha in entered
		#
		if [ -z "$ITEM" ] ; then
				printf "Exiting\n"
				exit
		fi

		#
		# Get user input for passphrase no need to escape spaces
		#
		printf "Enter the passphrase for $ITEM?\n"
		read "PASSPHRASE"

		#
		# Append the ITEM variable (ESSID) to .wpa to make a filename for saved configs
		#
		FILENAME=$ITEM".wpa"

		#
		# Run wpa_passphrase to generate a file for wpa_supplicant to use, store it locally and in etc/wpa_supplicant.conf 
		#
		printf "Running wpa_passphrase\n"
		wpa_passphrase "$ITEM" "$PASSPHRASE" > "$FILENAME" | xargs
		cat "$FILENAME">/etc/wpa_supplicant.conf | xargs
		printf "Creating new configuration using $ITEM\n"

		#
		# Jump to connect function, pass on the ESSID variable for connection
		#
		connect $ITEM
	done
}

function connect (){
	printf "Connecting using file $*\n"

	#
	# Capture incoming argument
	#
	ESSID=$*

	#
	# Kill previous instances of wpa_supplicant to stop other instances wpa_supplicant fighting several different AP's
	# Kill based on ref: http://thegeekstuff.com/2011/10/grep-or-and-not-operators/ and  http://stackoverflow.com/questions/3510673/find-and-kill-a-process-in-one-line-using-bash-and-regex
	# Release dhcp ip's and bring down the interface
	#
	kill $(ps aux | grep -E '[w]pa_supplicant.*\'$INT'' |  awk '{print $2}') | xargs
	dhclient $INT -r
	ifconfig $INT down

	#
	# Assign new credentials to interface
	#
	iwconfig $INT mode managed essid "$ESSID"
	printf "Configured interface $INT; ESSID is $ESSID\n"
	ifconfig $INT up
	printf "Interface $INT is up\n"
	wpa_supplicant -B -Dwext -i$INT -c/etc/wpa_supplicant.conf 2>/dev/null | xargs
	printf "wpa_supplicant running, sleeping for 15...\n"

	#
	# Wait to connect before asking for a ip address
	#
	sleep 15
	printf "Running dhclient\n"
	dhclient $INT

	#
	# Show current ip for interface
	#
	ifconfig $INT | grep inet
exit
}

#
# Start here
#
read_saved

exit
