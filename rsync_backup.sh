#!/usr/bin/env bash
# Written by: https://gitlab.com/u/huuteml
# Website: https://daulton.ca
# Purpose: A rsync backup script to be ran scheduled by Cron. It supports logging and backing up to both
# network share and locally attached storage which can be set in a variety of combinations
#
# Notice: This script assumes that the network share is already mounted. This is due to variety of different
# types of network storage and the ways in which it can be mounted. A one size fits all solution may not
# work in this scenario.
#
######### VARIABLES #########
# Specify backup directory on the network share. Ex: /media/nfs_backup/fileBackups
backupShare=

# Mount path of the drive to backup to. Ex. /mnt/backups
defaultMount=

# Specify backup drive Ex: /dev/sdb3
# This will be used for mounting the specified drive if is not already mounted at the above directory
backupDrive=

# Backup directory on the backup drive. Ex "$defaultMount"/important_files
# Its suggested to follow the example and use the "$defaultMount" variable, and to just add your backup
# directorys name and path afterward like shown
backupDir="$defaultMount"/

# Rsync to backup drive, network share, or both?
# Enter 1 for backup drive, 2 for just network share, or 3 to use both. Entering anything else will
# result in an error and the script exiting.
mountChoice=

# Do you want to synchronize your network share to your local backup drive? Y/N
# This option is available because the local drive is likely to be backed up to regularly while
# the device may not always be connected to the network share. So this way backups can be kept in
# sync so to save redoing or cleaning.
syncBackups=

# Enter the source files and directories you wish to sync, remember if its a directory put a slash (/) at 
# the end. Seperate each entry with a space and then double quote each entry. 
#
# Example:
# sourceArray=("/home/<user name>/Important_files/" "/home/<user name>/scripts/" "/home/<user name>/School_work/")
sourceArray=("")

# Enter the destination directory for the corressponding entry to the source array. So for the first entry 
# that will be the destination where the first entry of sourceArray will be stored to. The same spacing and 
# double quoting mentioned above still applies.
# Example:
# destinationArray=("/" "/MyScripts/" "/School_work")
# This would mean that the first entry should be copied into the root of backupDir and/or backupShare. The
# second entry will go to a folder in the root of the destination called MyScripts.
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
		rsync --log-file=/var/log/rsync_backup.log -urqz $(printf '%q\n' "${sourceArray[$i]}") $(printf '%q\n' "$backupDir""${destinationArray[$i]}")
	done
}

# makeLog()
# Function to output log related information in the /var/log/rsync_backup.log
makeLog() {
	if [[ $mountChoice == "1" ]]; then
		exitCodeShare=NA
		backupShare=NA
	fi

	if [[ $mountChoice == "2" ]]; then
		exitCodeDisk=NA
		backupDrive=NA
	fi
		
	echo "mountChoice was: 		$mountChoice" >> /var/log/rsync_backup.log
	echo "backupDrive was: 		$backupDrive" >> /var/log/rsync_backup.log
	echo "Drive backup exit code:		$exitCodeDisk" >> /var/log/rsync_backup.log
	echo "backupShare was: 		$backupShare" >> /var/log/rsync_backup.log
	echo "Share backup exit code:		$exitCodeShare" >> /var/log/rsync_backup.log

	if [[ $mountChoice == "3" ]]; then
		echo "backupDir was: 			$origBackupDir" >> /var/log/rsync_backup.log
	else
		echo "backupDir was: 			$backupDir" >> /var/log/rsync_backup.log
	fi

	if [[ $syncBackups == "Y" ]] || [[ $syncBackups == "y" ]]; then
		echo "syncBackups was selected as $syncBackups - Sync was from $origBackupDir to $backupShare" >> /var/log/rsync_backup.log	
		if [[ $exitCodeSync == "0" ]]; then
			echo "The sync was successful - exit code was $exitCodeSync" >> /var/log/rsync_backup.log
		else
			echo "Warning: The sync had an error occur with the exit code of $exitCodeSync" >> /var/log/rsync_backup.log
		fi
	fi

	if [[ $exitCodeShare == "0" ]]; then
		echo "The backup to $backupShare was successful and completed without error" >> /var/log/rsync_backup.log
	elif [[ $exitCodeShare == "NA" && $mountChoice == "1" ]]; then
		echo "Note: Backing up to only local hard disk since mountChoice is 1" >> /var/log/rsync_backup.log
	else
		echo "Warning: The backup to $backupShare had an error occur with a non-zero exit code." >> /var/log/rsync_backup.log
	fi

	if [[ $exitCodeDisk == "0" ]]; then
		echo "The backup to $backupDrive mounted at $defaultMount was successful and completed without error" >> /var/log/rsync_backup.log
	elif [[ $exitCodeDisk == "NA" && $mountChoice == "2" ]]; then
		echo "Note: Backing up to only network share since mountChoice is 2" >> /var/log/rsync_backup.log
	else
		echo "Warning: The backup to $backupDrive mounted at $defaultMount had an error occur with a non-zero exit code." >> /var/log/rsync_backup.log
	fi
}

echo "rsync backup beginning at $todayDate" >> /var/log/rsync_backup.log

if [ $mountChoice -lt 1 ] || [ $mountChoice -gt 3 ] ; then
	echo "Error: exiting due to out of range mountChoice - please enter 1 to 3" >> /var/log/rsync_backup.log
	exit 1
fi

if [[ $mountChoice == "1" ]]; then
	mountpoint -q "$defaultMount" || mount "$backupDrive" "$defaultMount"
	if [ $? -eq 0 ]; then
		rsyncFunction
		exitCodeDisk=$?
		makeLog
	fi
elif [[ $mountChoice == "2" ]]; then
	backupDir="$backupShare"
	rsyncFunction
	exitCodeShare=$?
	makeLog
elif [[ $mountChoice == "3" ]]; then
	mountpoint -q "$defaultMount" || mount "$backupDrive" "$defaultMount"
	if [ $? -eq 0 ]; then
		rsyncFunction
		exitCodeDisk=$?
		if [ $exitCodeDisk -eq 0 ]; then
			origBackupDir="$backupDir"
			backupDir="$backupShare"
			rsyncFunction
			exitCodeShare=$?
			if [[ $syncBackups == "Y" ]] || [[ $syncBackups == "y" ]]; then
				rsync -qarzu "$origBackupDir" "$backupShare"
				exitCodeSync=$?
			fi
			makeLog
		fi	
	fi
fi
