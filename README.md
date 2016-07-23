Purpose
===

A rsync backup script to be ran scheduled by Cron. It supports logging and backing to both
network share and locally attached drives and can be set in a variety of combinations

How to use
===

- This will make the script readable, writable, and executable to root and your user. 

sudo chmod 770 rsync_backup.sh

- Open the script in your text editor of choice. You need to edit the variables in the highlighted variables section near the top.

gedit rsync_backup.sh

- You will want to make sure you've saved, then we will edit the crontab for the root user

sudo crontab -e

- Next is creating the schedule the script will run at. [Use the following crontab generator to aid in that](http://crontab-generator.org/)

* 19 * * * bash /home/<user name>/scripts/rsync_backup.sh

This means it will run everyday, of every week, of every month, at 7 pm and run the script at the given
path through the BASH shell.

> **Note:** 
> Make sure you've installed the 'rsync' package for your distribution
>
> Assure that the root user is in the 'cron' usergroup:
> usermod -aG cron root
> then verify by:
> id root

Setting the variables
===

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

