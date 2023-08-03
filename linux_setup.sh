#!/bin/bash

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#    __       __  .__   __.  __    __  ___   ___ 
#   |  |     |  | |  \ |  | |  |  |  | \  \ /  / 
#   |  |     |  | |   \|  | |  |  |  |  \  V  /  
#   |  |     |  | |  . `  | |  |  |  |   >   <   
#   |  `----.|  | |  |\   | |  `--'  |  /  .  \  
#   |_______||__| |__| \__|  \______/  /__/ \__\ 
#                                             
#
#     _______. _______ .___________. __    __  .______   
#    /       ||   ____||           ||  |  |  | |   _  \  
#   |   (----`|  |__   `---|  |----`|  |  |  | |  |_)  | 
#    \   \    |   __|      |  |     |  |  |  | |   ___/  
#.----)   |   |  |____     |  |     |  `--'  | |  |      
#|_______/    |_______|    |__|      \______/  | _|      
#                                                        
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#-------- -------- -------- -------- -------- --------
#   Script Name   | linux_setup.sh 
#
#   Author        | Ryan Woodward
#   Date          | 09-2-2023
#   Email         | Ryanjwoodward@outlook.com
#
#   Description   | This script streamlines the setup 
#                 | of Linux machines for personal
#                 | use and projects.
#-------- -------- -------- -------- -------- --------

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#This function is used to update the package manager, package lists,
# and the package databases.
function update_package_manager() {
    echo -e "Updating package manager databases...\n"

    # Update pacman package lists
    if ! sudo pacman -Sy; then
        echo -e "Failed to update pacman package lists. Exiting..."
        exit 1
    fi

    # Update pacman system packages
    if ! sudo pacman -Syu; then
        echo -e "Failed to update pacman system packages. Exiting..."
        exit 1
    fi

    # Update pamac package lists
    if ! sudo pamac update; then
        echo -e "Failed to update pamac package lists. Exiting..."
        exit 1
    fi

    echo -e "Package manager databases updated successfully.\n"
}

#This function is called meerly to setup the snap store
# and to enable the usage of class snaps
function setup_snapstore(){
	#Install the Snapd Package
	sudo pacman -S snapd

	#Enable the systemd unit for the snapd socket
	sudo systemctl enable --now snapd.socket
	
	#Create a symbolic link to enable classic snap support
	sudo ln -s /var/lib/snapd/snap /snap

	#Restart the snapd service
	sudo systemctl restart snapd

	echo -e "\n\nGenerally the machine should be rebooted to make sure Snapstore is setup properly\n"
}

#This function contains all the commands to install applications on manjaro
#some are handled through the snap store others are handled via AUR
function install_applications(){
	#Install VS Code
	echo -e "Installing vscode...\n"
	sudo snap install code --classic

	#Install OBS Studio
	echo -e "Installing OBS...\n"
	sudo snap install obs-studio

	#Install KolourPaint
	echo -e "Installing KolourPaint...\n"
	sudo snap install kolourpaint	
	
	#Install NMAP
	echo -e "Installing NMAP...\n"
	sudo pacman -S nmap || { echo -e "Failed to install NMAP\n";}

	#Install Git Kraken
	echo -e "Installing GitKraken...\n"
	sudo snap install gitkraken --classic

	#Install Vim
	echo -e "Installing Vim...\n"
	sudo pacman -S vim || { echo -e "Failed to Install Vim\n";}

	#Install Google Chrome
	echo -e "Installing Google Chrome...\n"
	sudo pamac build google-chrome || { echo -e "Failed to Install Chrome\n";}

	#Install VLC
	echo -e "Installing VLC Media Player...\n"
	sudo snap install vlc

	#Install Balena Etcher
	echo -e "The command to install Balena Etcher is incorrect\n This will require a revision\n"
	#echo -e "Installing Balena Etcher...\n"
	#sudo pacman -S etcher || { echo -e "Failed to Install Balena Etcher\n";}

	#Install Virtual Box
	echo -e "Installing Virtual Box... but you should try VirtManager...\n"
	sudo pacman -S virtualbox || { echo -e "Failed to Install Virtual Box\n";}

	#Install Obsidian
	echo -e "Installing Obsidian...\n"
	sudo snap install obsidian --classic

	#Install Brackets
	echo -e "Installing Brackets...\n"
	sudo snap install brackets --classic
}

#This function is the primary execution of the script
#From here all the setup functions and commands are called
# and executed
function linux_setup(){

    update_package_manager

	setup_snapstore

	install_applications
}

function exit_linux_setup(){
    echo -e "EXITING SCRIPT....   \n Auf Wiedersehen!"
    exit 1
}

#This Function is simply used to validate the user's input.
#
# 'y' is the selection to proceed with the execution of the setup script
# 'n' return a witty remark
# '*' anythiung but  y will force the script to terminate
function user_input_error_check(){
    local input="$1"

    case "$input" in
        y)
            echo -e "Beginning Setup of Linux Machine...\n"
            linux_setup
        ;;
        
        n)
            echo -e "Then why on earth would you run me in the first place?\n"
            exit_linux_setup
        ;;

        *)
            echo -e "Fehler: Invalid Input\n"
            exit_linux_setup
        ;; 
    esac
}

#Print a message greeting the user
echo  -e "**** Welcome to Linux Setup Script ****\n"

#Read the user's selection input
read -p "Would you like to run the Setup? (y/n): " user_selection

#call the error check function and pass the user input as an argument
user_input_error_check "$user_selection"







#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# AUTHOR:
#.______     ____    ____  ___      .__   __.    ____    __    ____  ______     ______    _______  ____    __    ____  ___      .______       _______  
#|   _  \    \   \  /   / /   \     |  \ |  |    \   \  /  \  /   / /  __  \   /  __  \  |       \ \   \  /  \  /   / /   \     |   _  \     |       \ 
#|  |_)  |    \   \/   / /  ^  \    |   \|  |     \   \/    \/   / |  |  |  | |  |  |  | |  .--.  | \   \/    \/   / /  ^  \    |  |_)  |    |  .--.  |
#|      /      \_    _/ /  /_\  \   |  . `  |      \            /  |  |  |  | |  |  |  | |  |  |  |  \            / /  /_\  \   |      /     |  |  |  |
#|  |\  \----.   |  |  /  _____  \  |  |\   |       \    /\    /   |  `--'  | |  `--'  | |  '--'  |   \    /\    / /  _____  \  |  |\  \----.|  '--'  |
#| _| `._____|   |__| /__/     \__\ |__| \__|        \__/  \__/     \______/   \______/  |_______/     \__/  \__/ /__/     \__\ | _| `._____||_______/ 
#                                                                                                                                                      
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
