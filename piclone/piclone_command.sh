#!/bin/bash

#Saves the directory where is located the script.
dir="$(cd "$(dirname "$0")" && pwd)"

#Executes at the same time the scripts needed to work.
bash $dir/.Piclone_lsblk_exe.sh
bash $dir/.Piclone_piclone.sh
