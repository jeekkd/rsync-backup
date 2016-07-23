#!/usr/bin/env bash
# Written by: https://gitlab.com/u/huuteml
# Website: https://daulton.ca
# Purpose: A rsync backup script to be ran scheduled by Cron. It supports logging and backing to both
# network share and locally attached drives and can be set in a variety of combinations
#
# Notice: This script assumes that the network share is already mounted. This is due to variety of different
# types of network storage and the ways in which it can be mounted. A one size fits all solution may not
# work in this scenario.
#
######### VARIABLES #########
# Specify backup directory on the network share. Ex: /media/nfs_backup/fileBackups
backupShare=

# Mount path of the drive to backup to. Ex. /mnt/tmp
defaultMount=

# Specify backup drive. Ex: /dev/sdb3
backupDrive=

# Backup directory on the backup drive. Ex "$defaultMount"/important_files
# Its suggested to follow the example and use the "$defaultMount" variable, and to just add your backup
# directorys name and path afterward like shown
backupDir=

# Rsync to backup drive, network share, or both?
# Enter 1 for backup drive, 2 for just network share, or 3 to use both
mountChoice=

# Enter the source files and directories you wish to sync, remember if its a directory put a slash (/) at the end. Seperate
# each entry with a space and then double quote each entry this way spaces wont effect anything and it makes it easier
# to see where one entry stops and another starts.
# Example:
# sourceArray=("/home/<user name>/School_work/" "/home/<user name>/scripts/")
sourceArray=("")

# Enter the destination directory for the corressponding entry to the source array. So for the first entry that
# Will be the destination where the first entry of sourceArray will be stored to. The same spacing and double
# quoting mentioned above still applies.
# Example:
# destinationArray=("$backupDir/School" "$backupDir/MyScripts/")
destinationArray=("")
#############################

todayDate=$(date)

# rsyncFunction()
# Put rsync portion in a function due to being called multiple times through out the 
# logic structure. Saves repeat code by functionizing it
rsyncFunction() {
	sourceArrayLength=${#sourceArray[@]}
	adjustedLength=$(( sourceArrayLength - 1 ))

	for i in $( eval echo {0..$adjustedLength} ); do
		rsync --log-file=/var/log/rsync_backup.log -urq $(printf '%q\n' "${sourceArray[$i]}") $(printf '%q\n' "${destinationArray[$i]}")
	done
}

# error_log()
# Function to be used in logLogic(). Outputs error related information in the /var/log/backup_error.log
# if logLogic() determines the backup was a failure
error_log() {
echo "$todayDate" >> /var/log/backup_error.log
echo "mountChoice was: 	$mountChoice
backupDrive was: 	$backupDrive
backupShare was: 	$backupShare
backupDir was: 		$backupDir
The backup had an error occur with the exit code of $exitCode" >> /var/log/rsync_backup.log
}

# success_log()
# Function to be used in logLogic(). Outputs success related information in the /var/log/backup_success.log
# if logLogic() determines the backup was a success
success_log() {
echo "$todayDate" >> /var/log/backup_success.log
echo "mountChoice was: 	$mountChoice
backupDrive was: 	$backupDrive
backupShare was: 	$backupShare
backupDir was: 		$backupDir
The backup was successful and completed without error" >> /var/log/rsync_backup.log
}

# logLogic()
# To be failed after the final call of rsyncFunction() in the mountChoice logic to determine based on
# exit code if the backup was a success or failure then calls the appropriate function for either a 
# success or a failure
logLogic() {
	if [ $? -eq 0 ]; then
		success_log
	fi
	if [ $? -gt 0 ]; then
		exitCode=$?
		error_log
	fi
}

echo "rsync backup beginning at $todayDate.." >> /var/log/rsync_backup.log

if [[ $mountChoice == "1" ]]; then
	mountpoint -q "$defaultMount" || mount "$backupDrive" "$defaultMount"
	if [ $? -eq 0 ]; then
		rsyncFunction
		logLogic
	fi
elif [[ $mountChoice == "2" ]]; then
	backupDir="$backupShare"
	rsyncFunction
	logLogic
elif [[ $mountChoice == "3" ]]; then
	mountpoint -q "$defaultMount" || mount "$backupDrive" "$defaultMount"
	if [ $? -eq 0 ]; then
		rsyncFunction
		if [ $? -eq 0 ]; then
			backupDir="$backupShare"
			rsyncFunction
			logLogic
		fi	
	fi
else
	error_log
	exit 1
fi
