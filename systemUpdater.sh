#!/bin/bash

#	AstroPi3 KStars/INDI Ubuntu-Mate System Updater Script
#﻿  Copyright (C) 2018 Robert Lancaster <rlancaste@gmail.com>
#	This script is free software; you can redistribute it and/or
#	modify it under the terms of the GNU General Public
#	License as published by the Free Software Foundation; either
#	version 2 of the License, or (at your option) any later version.

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
if [ "$(whoami)" != "root" ]; then
	echo "Please run this script with sudo due to the fact that it must do a number of sudo tasks.  Exiting now."
	exit 1
fi
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Welcome to the AstroPi3 KStars/INDI Ubuntu-Mate System Updater"
echo "This script will update your SBC to all the latest software and the AstroPi3 Scripts to the latest version"
echo "Please note, if there were any AstroPi3 setup script changes, you will probably want to run the setup script for your install again after running this script."

read -p "Do you wish to run this script? (y/n)" runscript
if [ "$runscript" != "y" ]
then
	echo "Quitting the script as you requested."
	exit
fi 

## check if DPKG database is locked
dpkg -i /dev/zero 2>/dev/null
if [ "$?" -eq 2 ]
then
    echo "dpkg is currently locked, meaning another program is either checking for updates or is currently updating the system."
    echo "Please wait for a few minutes or quit the other process and run this script again.  Exiting now."
    read -p "Hit [Enter] to end the script" closing
    exit
fi

# Updates the computer to the latest packages.
echo "Updating installed packages"
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

# Updates indiweb to the latest version
sudo -H pip install indiweb --upgrade

# Updates the AstroPi3 Script to the latest version.
echo "Updating AstroPi3 Scripts"
cd $DIR
rm "$DIR/setupAstro64.sh"
rm "$DIR/setupAstroPi3.sh"
rm "$DIR/setupAstro64with32bitKStars.sh"
rm "$DIR/udevRuleScript.sh"
rm "$DIR/astrometryIndexInstaller.sh"
rm "$DIR/systemUpdater.sh"
rm "$DIR/backupOrRestore.sh"
git pull
git reset --hard
chmod +x "$DIR/setupAstro64.sh"
chmod +x "$DIR/setupAstroPi3.sh"
chmod +x "$DIR/setupAstro64with32bitKStars.sh"
chmod +x "$DIR/udevRuleScript.sh"
chmod +x "$DIR/astrometryIndexInstaller.sh"
chmod +x "$DIR/systemUpdater.sh"
chmod +x "$DIR/backupOrRestore.sh"
sudo chown $SUDO_USER *

echo "Your requested updates are complete."

read -p "Hit [Enter] to end the script" closing

