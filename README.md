Purpose
===

A rsync backup script to be ran scheduled by cron. It supports logging, desktop notifications, and
backups up to both a network share or locally attached storage which can be set in a variety of combinations.

Required packages
===

Base requirements:
- rsync
- Bash

How to use
===

- Lets get the source

```
git clone https://github.com/jeekkd/rsync-backup.git && cd rsync-backup
```

- This will make the script readable, writable, and executable to root and your user. 

```
sudo chmod 770 rsync_backup.sh
```

- Open the script in your text editor of choice. You need to edit the variables in the highlighted variables section near the top.

```
gedit rsync_backup.sh
```

- You will want to make sure you've saved, then we will edit the crontab for the root user

```
sudo crontab -e
```

- Next is creating the schedule the script will run at. [Use the following crontab generator to help with that](http://crontab-generator.org/)

```
* 19 * * * bash /home/<user name>/scripts/rsync_backup.sh
```

This means it will run everyday, of every week, of every month, at 7 pm and run the script at the given
path through the BASH shell.

> **Note:** 
> 
> 1. Make sure you've installed the 'rsync' package for your distribution
>
> 2. Assure that the root user is in the 'cron' usergroup:
>
> usermod -aG cron root
>
> Then verify by:
>
> groups root

Setting the variables
===

Specify backup directory on the network share. Ex: /media/nfs_backup/fileBackups

```
backupShare=/media/<Enter share here>
```

Mount path of the drive to backup to. Ex. /mnt/tmp

```
defaultMount=/media/<Drive mount path>
```

Specify backup drive. Ex: /dev/sdb3

```
backupDrive=/dev/<Your backup drive here>
```

Backup directory on the backup drive. Ex "$defaultMount"/important_files
Its suggested to follow the example and use the "$defaultMount" variable, and to just add your backup
directorys name and path afterward like shown

```
backupDir="$defaultMount"/<backup directory>
```

Rsync to backup drive, network share, or both?
Enter 1 for backup drive, 2 for just network share, or 3 to use both

```
mountChoice=<Enter your choice>
```

Do you want to synchronize your network share to your hardware? Y/N
This option is available because the local drive is likely to be backed up to regularly while
the computer may not always be connected to the network share. So this way backups can be kept in
sync so to save redoing or cleaning.

```
syncBackups=<Enter your choice>
```

Make sure to double quote each entry and then space it. Directories should end in a forward slash (/). So it will look like so:

    sourceArray=("/home/<name>/Documents/" "/home/<name>/scripts/")

Then the destinationArray holds the path to the destination for the corresponding entry in the sourceArray. So you're specifying where you want your Documents to go an example. It will look like so:

    destinationArray=("$backupDir/Documents" "$backupDir/scripts")

Right now $backupDir might not make much sense but it is the variable that contains the drive mount path and
backup directory name. This isn't required for you to use, just in the future if you ever change the location
of your backup it will save a lot of effort later on.

The reason it is done this way in an intentional design decision to enable you to choose multiple files and
directories to backup with ease. This is an easy way to implement that without making it a pain for the user
to use.

Enable notifications via libnotify? Y/N
```
notificationsEnabled=<Enter your choice>
```

Enter the username of the user to send notifications to
```
notificationsTo=<Your username here if notificationsEnabled is set to Y>
```

Log file example
===

```
rsync backup beginning at Tue Oct 11 22:43:37 CDT 2016
2016/12/26 16:31:48 [5159] cd+++++++++ .local/share/webkitgtk/
2016/12/26 16:31:48 [5159] cd+++++++++ .local/share/webkitgtk/databases/
2016/12/26 16:31:48 [5159] cd+++++++++ .local/share/webkitgtk/databases/indexeddb/
2016/12/26 16:31:48 [5159] cd+++++++++ .local/share/webkitgtk/localstorage/
2016/12/26 16:31:48 [5159] >f+++++++++ .local/share/webkitgtk/localstorage/StorageTracker.db
2016/12/26 16:31:48 [5159] >f+++++++++ .local/share/webkitgtk/localstorage/https_www.youtube.com_0.localstorage
2016/12/26 16:31:48 [5159] cd+++++++++ .local/share/yakuake/
2016/12/26 16:31:48 [5159] >f+++++++++ .local/share/yakuake/Profile 1.profile
2016/12/26 16:31:48 [5159] >f+++++++++ .local/share/yakuake/Profile 2.profile
2016/12/26 16:31:48 [5159] >f+++++++++ .local/share/yakuake/Profile 3.profile
2016/12/26 16:31:48 [5159] >f+++++++++ .local/share/yakuake/Profile 4.profile
2016/12/26 16:31:48 [5159] sent 8138724 bytes  received 6871 bytes  total size 21601880
Backup completed at:            Mon Dec 26 16:31:48 CST 2016
mountChoice was:                1
backupDrive was:                /dev/sdb1
Drive backup exit code:         0
backupShare was:                NA
Share backup exit code:         NA
backupDir was:                  /media/data/important_files/
Note: Backing up to only local hard disk since mountChoice is 1
The backup to /dev/sdb1 mounted at /media/data was successful and completed without error

```
