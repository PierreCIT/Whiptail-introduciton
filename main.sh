#!/bin/bash

#########################################################
####      Created by Pierre SEITE (21/03/2020)       ####
####   It is an introduction project to whiptail.    ####
####     It has just for vocation to try it out,     ####
####          and keep a trace of it. 				 ####
#########################################################

# Just displays the infobox and leave
#TERM=ansi whiptail --title "Example Dialog" --infobox "This is an example of an info box" 8 78

# On this one you must it ok to continue
#whiptail --title "Example Dialog" --msgbox "This is an example of a message box. You must hit OK to continue." 8 78

## Source functions from functions.sh script
source ./functions.sh
## Source the 'style' for the interface
source ./colors.sh

##Value initialization
TRUE_PASS="1234"
PASSWORD=""

if (whiptail --title "Info Dialog" --yesno "You will enter short script made to learn how shell interfaces work.\nDo you want to continue ?" 8 78); then
    whiptail --title "Answer Dialog" --msgbox "Then let's dive into it. (You previously slected '$?').\nYou must hit OK to continue and go to the credentials screen." 8 78

    Name=$(whiptail --inputbox "What is your name ?" 8 78 No_Name --title "Name" 3>&1 1>&2 2>&3)
	                                                                        # A trick to swap stdout and stderr.
	# We can pack this inside if, but it seems really long for some 80-col terminal users.
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
	   	password_check
		exitstatus=$?
		if [ $exitstatus = 0 ]; then
			menu_loop=0
			while [ $menu_loop = 0 ]
			do
				main_menu
				userChoice=$?
				if [ $userChoice = 100 ]; then
					goodbye_msg
					menu_loop=1
				elif [ $userChoice = 1 ]; then
					add_directory
				elif [ $userChoice = 2 ]; then
					show_current
				elif [ $userChoice = 3 ]; then
					echo "next Menu option"
					next_menu
					secondMenuChoice=$?
					if [ $secondMenuChoice = 100 ]; then
						goodbye_msg
						menu_loop=1
					fi
				elif [ $userChoice = 4 ]; then
					progress_bar
				fi
			done
		fi
	else
	    whiptail --title "Good bye !" --msgbox "Too intrusive to ask your name ?\nWe can understand but then the next part of this extraodinary interface is not for you...\n\nCome back when you are ready, we'll still be there ;)" 12 78
	fi
else
    whiptail --title "Good bye !" --msgbox "No problem, come back whenever you want!\n(You previously slected '$?').\nYou must hit OK to continue." 10 78
fi