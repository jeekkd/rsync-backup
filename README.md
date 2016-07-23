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

- Next is creating the schedule the script will run at. [Use the following crontab generator to aid in that](http://crontab-generator.org/)

```
* 19 * * * bash /home/<user name>/scripts/rsync_backup.sh
```

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


Log file example
===

```
rsync backup beginning at Sat Jul 23 14:31:39  2016
2016/07/23 14:31:39 [23079] building file list
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/LICENSE
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/README.md
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/rsync_backup.sh
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/COMMIT_EDITMSG
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/HEAD
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/config
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/description
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/index
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/hooks/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/hooks/applypatch-msg.sample
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/hooks/commit-msg.sample
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/hooks/post-update.sample
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/hooks/pre-applypatch.sample
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/hooks/pre-commit.sample
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/hooks/pre-push.sample
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/hooks/pre-rebase.sample
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/hooks/prepare-commit-msg.sample
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/hooks/update.sample
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/info/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/info/exclude
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/logs/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/logs/HEAD
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/logs/refs/
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/logs/refs/heads/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/logs/refs/heads/master
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/logs/refs/remotes/
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/logs/refs/remotes/origin/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/logs/refs/remotes/origin/master
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/objects/
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/objects/23/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/objects/23/cb790338e191e29205d6f4123882c0583ef8eb
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/objects/52/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/objects/52/c6b256a8f80e6086d663b5ecc0ae6501337784
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/objects/61/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/objects/61/50e0cdf36dc4aa72e48fbfc9dfaf2ffe71fd98
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/objects/ac/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/objects/ac/c443b2fa4b9ea2f23310c58092e3d58b9b90c0
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/objects/b9/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/objects/b9/d2ecffc96e1e1fbf1a00d53d0653c52e594b99
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/objects/c8/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/objects/c8/d8689ab1d9f5cdd10a9dfd1896f11c0b6ec8f8
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/objects/ce/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/objects/ce/bcde00517d95fb89b90b410561cbccaa7978f9
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/objects/f9/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/objects/f9/7b22dfc94de1c8ccf71048ec55fbe17348af28
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/objects/info/
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/objects/pack/
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/refs/
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/refs/heads/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/refs/heads/master
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/refs/remotes/
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/refs/remotes/origin/
2016/07/23 14:31:39 [23079]>f+++++++++ Git/rsync_backup/.git/refs/remotes/origin/master
2016/07/23 14:31:39 [23079] cd+++++++++ Git/rsync_backup/.git/refs/tags/
2016/07/23 14:31:39 [23079]>f.sT...... MyScripts/rsync_backup.sh
2016/07/23 14:31:39 [23079] sent 149752 bytes  received 1602 bytes  total size 4580790776
2016/07/23 14:31:39 [23084] building file list
2016/07/23 14:31:39 [23084] sent 63 bytes  received 17 bytes  total size 0
2016/07/23 14:31:39 [23090] building file list
2016/07/23 14:31:39 [23090] sent 90381 bytes  received 907 bytes  total size 4580790776
2016/07/23 14:31:39 [23095] building file list
2016/07/23 14:31:39 [23095] sent 63 bytes  received 17 bytes  total size 0
mountChoice was:     3
backupDrive was:     /dev/sdb1
backupShare was:     /media/<Your network share>/<Your backup directory>
backupDir was:       /media/<Your backup drive>/<Your backup directory>
The backup was successful and completed without error
```
