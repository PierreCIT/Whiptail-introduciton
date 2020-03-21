#!/bin/bash

#########################################################
####      Created by Pierre SEITE (21/03/2020)       ####
####   It is an introduction project to whiptail.    ####
####     It has just for vocation to try it out,     ####
####          and keep a trace of it. 				 ####
#########################################################

#Contains all of the functions for the main script

# Will write the message to a file and then read it to show in a textbox
#   echo "Welcome to Bash $BASH_VERSION" > test_textbox"
#                      filename height width
#	whiptail --textbox test_textbox 12 80

function password_check(){
	local keepAsking=0
	local text="Nice to meet you $Name.\nPlease enter the password to continue (hint: 1234):"
	local PASSWORD="T"
	while [ "$PASSWORD" != "$TRUE_PASS" ] && [ $keepAsking = 0 ]
	do
		echo "$text"
		PASSWORD="$(whiptail --passwordbox "$text" 10 78 --title "Password dialog" 3>&1 1>&2 2>&3)"
		
		keepAsking=$?
		if [ $keepAsking = 0 ] && [ "$PASSWORD" = "$TRUE_PASS" ]; then
			return 0
		else
			if [ $keepAsking = 0 ] && [ "$PASSWORD" != "$TRUE_PASS" ] && [ "$wrong" = "" ]; then
				text+="\nWhoops !!! Try again (and look for the hint ;))\n"
			else
				if [[ $keepAsking = 1 ]]; then
					whiptail --title "Good bye !" --msgbox "No problem, come back whenever you want!\nYou must hit OK to continue." 8 78
					return 2
				fi
			fi
		fi
	done
}

function main_menu(){
	local choice="$(TERM=ansi whiptail --title "Menu" --menu "Welcome $Name !\nChose an option:" 25 78 16 \
									"Add Directory" "Add a directory to the current folder." \
									"Show Current" "Show the current directory." \
									"Next Menu" "Go to the next directory." \
									"Progress Bar" "Show the progress bar." \
									"Quit" "List all groups on the system."  3>&1 1>&2 2>&3)"
	local exitStatus=$?
	if [ "$choice" = "" ] || [ "$choice" = "Quit" ]; then
		return 100
	elif [ "$choice" = "Add Directory" ]; then
		return 1
	elif [ "$choice" = "Show Current" ]; then
		return 2
	elif [ "$choice" = "Next Menu" ]; then
		return 3
	elif [ "$choice" = "Progress Bar" ]; then
		return 4
	fi
}

function add_directory(){
	local fileName=$(whiptail --inputbox "Enter the name of the directory to create: " 8 78 test --title "Directory name" 3>&1 1>&2 2>&3)
	mkdir "$fileName"
	result=$?
	if [ "$result" -ne 0 ]; then
		whiptail --title "Error Dialog" --msgbox "/!\\ There has been an error while creating the directory !!!" 8 78
	fi
}

function show_current(){
	data=$(ls -l)
	whiptail --title "Show current dialog" --scrolltext --msgbox "$data" 30 78
}

function next_menu(){
	local choice="$(TERM=ansi whiptail --title "Menu" --menu "Welcome to the second menu $Name !\nChose an option:" 25 78 16 \
									"<-- Back" "Return to the main menu."\
									"Show Current" "Show the current directory." \
									"Quit" "List all groups on the system."  3>&1 1>&2 2>&3)"
	local exitStatus=$?
	if [ "$choice" = "" ] || [ "$choice" = "Quit" ]; then
		return 100
	elif [ "$choice" = "<-- Back" ]; then
		return 1
	elif [ "$choice" = "Show Current" ]; then
		show_current
		return 2
	fi
}

function progress_bar(){
	local msgs=( "Downloading" "Verifying" "Unpacking" "Almost Done" "Done" )

	for i in {1..5}; do
	  sleep 1
	  echo XXX
	  echo $(( i * 20 ))
	  echo ${msgs[i-1]}
	  echo XXX
	done |whiptail --gauge "Please wait while installing" 6 60 0
}

function goodbye_msg(){
	whiptail --title "Good bye !" --msgbox "Thank you for exploring the interface, come back whenever you want!\nYou must hit OK to continue." 8 78
}