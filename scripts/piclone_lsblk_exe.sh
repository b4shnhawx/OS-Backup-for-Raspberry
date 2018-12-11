#!/bin/bash

#This will execute the script that shows us the disks (.Piclone_lsblk.sh). The command open a new terminal with the output of the script.
xfce4-terminal -H --geometry=+0+0 -e 'bash /home/pi/Scripts/piclone_lsblk.sh' &
