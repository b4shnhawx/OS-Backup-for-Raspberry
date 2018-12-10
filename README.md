# OS-Backup-for-Raspbery
### Description
This script help you to know in which disk you can make a backup of your Raspbian OS.

### My problem
I usually use Piclone to make a backup of my Raspbian OS. When we execute this program, the source disk is clear (/dev/mmcblk0), but the destination disk not so.

<p align="center">
  <img width="437" height="174" src="https://github.com/davidahid/OS-Backup-for-Raspbery/blob/master/problem.png">
</p>

To make sure, I had to run lsblk to see what name had my destination disk. Obviusly, it's not a difficult task, but where is the fun if we can automate this task?
