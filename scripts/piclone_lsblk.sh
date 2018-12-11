#!/bin/bash

#IMPORTANT
#This script its very concrete. A little change on it can vary the full behaviour of this script and show you a different disk in
#which you want to make the backup.  Remember that we want to work with disks, and one error can suppose the lost of data.

#----------------------------------------------------------- Configuration -----------------------------------------------------------

#Create a variable which gonna have the destinatios disk size. #We put the size since it is the simplest method to identify two disks
#with lsblk, since the rest of values can vary.
#IMPORTANT
#If we have more than one disk with the same size, we need to be carefull and make sure which is the #correct disk.
backup_size="14.9G"

#Also we may need to insert the UUID of the destination disk (this ID is exclusive for every disk). #In this way we can difference
#between two disk of same sizes. Although the script could only work with this ID, it is better to set two values to make sure the
#disk is correct...
backup_uuid="25765c7c-5d3f-488a-85bc-bcb66bfa7c78"

#-------------------------------------------------------------- Script ---------------------------------------------------------------

#Search the ID of the disk and we save it in the blkid_backup_uuid variable. In this way, if theres no ID available (the destination
#disk its not connected), the variable will be empty.
blkid_backup_uuid=`sudo blkid | grep -o $backup_uuid | uniq`

#Save te output of the command lsblk in the temporary path of the raspberry (/temp)
lsblk > /tmp/lsblk_tmp_file

#Counts and saves in the variable the number of lines that have the file lsblk_tmp_file
linesnumber=`sudo cat /tmp/lsblk_tmp_file | grep disk | wc -l`

#Create a bucle that repeats as many times as lines have the temporary file
for line in $(seq 1 $linesnumber);
do
	#Saves the name of the last disk found
	namedisk=`sudo cat /tmp/lsblk_tmp_file | grep disk | head -n $line | tail -n 1 | tr -s " " | cut -f1 -d" " | tr " " "\t"`
	#Saves the size of the last disk found
	sizedisk=`sudo cat /tmp/lsblk_tmp_file | grep disk | head -n $line | tail -n 1 | tr -s " " | cut -f4 -d" " | tr " " "\t"`
	#Saves the type of the last disk found
	typedisk=`sudo cat /tmp/lsblk_tmp_file | grep disk | head -n $line | tail -n 1 | tr -s " " | cut -f6 -d" " | tr " " "\t"`
	#Saves the mount point of the last disk found
	mountdisk=`sudo cat /tmp/lsblk_tmp_file | grep part | head -n $line | tail -n 1 | tr -s " " | cut -f7-8 -d" " | tr " " "\t"`

	#If the name disk is equal to sd* (sda, sdb, sdc, etc), the size is equal to 14.9G (depends of the variable) and the UUID is
	#equal to the variable uuid...
	if [[ $namedisk == sd* && $backup_uuid = $blkid_backup_uuid && $sizedisk = $backup_size ]];
	then
		#...print the name (underlined in green [42m and with white letters [30m), size, type and the mount point of the
		#destination disk. Here is where we gonna make the backup.
		echo -e  "\e[42m\e[30m"$namedisk"\e[0m\e[0m" "\t" $sizedisk "\t\t" $typedisk "\t" $mountdisk

	#If the name of the disk its another sd* (sda, sdb, sdc, etc) that doesnt coincided withe the first condition (name,
	#uuid and size)...
	elif [[ $namedisk == sd* ]];
	then
		#...print the name (underlined in red [41m and with white letters [30m), size, type and the mount point of the
		#destination disk. This are the disks that we dont touch. IN THIS DEVICES WE CAN'T MAKE THE BACKUP.
		echo -e "\e[41m\e[30m"$namedisk"\e[0m\e[0m" "\t" $sizedisk "\t" $typedisk "\t" "\e[41m\e[30m"$mountdisk"\e[0m\e[0m"

	#If the name disk is equal to mmcblk0 (where is the OS located)...
	elif [[ $namedisk = "mmcblk0" ]];
	then
		#...print the name, size, type and mount point of the disk where are located the OS files.
		echo -e $namedisk "" $sizedisk "\t\t" $typedisk "\t" $mountdisk

	#And if no condition is met, it means that there are other disk connected...
	else
		#...print the name, sizez type amd mount point of the disk.
		echo -e $namedisk "\t" $sizedisk "\t" $typedisk "\t" $mountdisk

	fi

#Finish the loop and move on to the next disk in the lsblk. If there is no more, the script ends.
done
