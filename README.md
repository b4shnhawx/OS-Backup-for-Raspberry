# OS-Backup-for-Raspbery
### Description
This script help you to know in which disk you can make a backup of your Raspbian OS.

### The problem
I usually use Piclone to back up my Raspbian operating system. When we run this program, the source disk is obvious (`/dev/mmcblk0`), but the target disk is not so when you have two other disks connected to your Raspberry.

<p align="center">
  <img width="437" height="174" src="https://github.com/davidahid/OS-Backup-for-Raspbery/blob/master/images/problem.png">
</p>

To make sure, I had to run lsblk to see what name had my destination disk. Obviusly, it's not a difficult task, but where is the fun if we can automate this task??

### Configuration
We need to know first the disk size and UUID of our destination disk. To know it just we need to disconnect all of our disks, less the destination disk, and type the next commands:
```sh
cat /tmp/lsblk_tmp_file | grep disk | tr -s " " | cut -f4 -d" " | tr " " "\t"
```
```sh
blkid | cut -d " " -f3 | grep UUID
```

When we have this two data, we just copy it in the configuration lines of the script [piclone_lsblk.sh](https://github.com/davidahid/OS-Backup-for-Raspbery/blob/master/scripts/piclone_lsblk.sh).
```sh
#------------------------------------------------ Configuration ------------------------------------------------

#Create a variable which gonna have the destinatios disk size.
#We put the size since it is the simplest method to identify two disks with lsblk, since the rest of 
#values can vary.
#IMPORTANT
#If we have more than one disk with the same size, we need to be carefull and make sure which is the 
#correct disk.
backup_size="14.9G"

#Also we may need to insert the UUID of the destination disk (this ID is exclusive for every disk). 
#In this way we can difference between two disk of same sizes. Although the script could only work 
#with this ID, it is better to set two values to make sure the disk is correct...
backup_uuid="25765c7c-5d3f-488a-85bc-bcb66bfa7c78"
```
Also we need to configure the path where the piclone_lsblk.sh will be executed in the script [piclone_lsblk_exe.sh](https://github.com/davidahid/OS-Backup-for-Raspbery/blob/master/scripts/piclone_lsblk_exe.sh) and in the [Piclone.desktop](https://github.com/davidahid/OS-Backup-for-Raspbery/blob/master/scripts/Piclone.desktop) file.
```sh
xfce4-terminal -H --geometry=+0+0 -e '/home/user/our_path' &
```
```sh
Exec=bash /home/user/our_path
```

### Example
Finally when we execute the [Piclone.desktop](https://github.com/davidahid/OS-Backup-for-Raspbery/blob/master/scripts/Piclone.desktop), the scripts will behave as the image.
<p align="center">
  <img width="350" height="200" src="https://github.com/davidahid/OS-Backup-for-Raspbery/blob/master/images/scheme.png">
</p>

Something like this will appear. The disk shown in green it corresponds to the destination disk, the source disk will not have color, and the rest of the disks will appear in red.
<p align="center">
  <img width="1090" height="330" src="https://github.com/davidahid/OS-Backup-for-Raspbery/blob/master/images/example.png">
</p>
