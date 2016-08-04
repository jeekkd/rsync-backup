Purpose
===

A rsync backup script to be ran scheduled by Cron. It supports logging and backing up to both
network share and locally attached storage which can be set in a variety of combinations

How to use
===

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
> id root

Setting the variables
===

Specify backup directory on the network share. Ex: /media/nfs_backup/fileBackups

    backupShare=/media/<Enter share here>/important_files/

Mount path of the drive to backup to. Ex. /mnt/tmp

    defaultMount=/media/<Drive mount path>

Specify backup drive. Ex: /dev/sdb3

    backupDrive=/dev/sdc1

Backup directory on the backup drive. Ex "$defaultMount"/important_files
Its suggested to follow the example and use the "$defaultMount" variable, and to just add your backup
directorys name and path afterward like shown

    backupDir="$defaultMount"/<backup directory>

Rsync to backup drive, network share, or both?
Enter 1 for backup drive, 2 for just network share, or 3 to use both
    mountChoice=<Enter your choice>

Do you want to synchronize your network share to your hardware? Y/N
This option is available because the local drive is likely to be backed up to regularly while
the computer may not always be connected to the network share. So this way backups can be kept in
sync so to save redoing or cleaning.
    syncBackups=Y

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


Log file example
===

```
rsync backup beginning at Thu Aug  4 13:32:01 CDT 2016
2016/08/04 13:32:01 [21176] building file list
2016/08/04 13:32:01 [21176] >f..T...... MyScripts/rsync_backup.sh
2016/08/04 13:32:01 [21176] sent 99256 bytes  received 1000 bytes  total size 4310030400
2016/08/04 13:32:01 [21181] building file list
2016/08/04 13:32:01 [21181] sent 212 bytes  received 17 bytes  total size 2599691
2016/08/04 13:32:01 [21187] building file list
2016/08/04 13:32:01 [21187] sent 97346 bytes  received 975 bytes  total size 4310030400
2016/08/04 13:32:01 [21192] building file list
2016/08/04 13:32:01 [21192] sent 212 bytes  received 17 bytes  total size 2599691
mountChoice was: 		3
backupDrive was: 		/dev/sdc1
Drive backup exit code:	0
backupShare was:        /media/<Your network share>/<Your backup directory>
Share backup exit code: 0
backupDir was:          /media/<Your backup drive>/<Your backup directory>
syncBackups was selected as Y - Sync was from /media/data/important_files/ to /media/daultons_nfs/important_files/
The sync was successful - exit code was 0
The backup was successful and completed without error

```
