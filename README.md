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
>
> usermod -aG cron root
>
> then verify by:
>
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
rsync backup beginning at Sun Jul 31 14:08:45 CDT 2016
2016/07/31 14:08:45 [7407] building file list
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/LICENSE
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/README.md
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/build_kernel.sh
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/COMMIT_EDITMSG
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/HEAD
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/config
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/description
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/index
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/hooks/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/hooks/applypatch-msg.sample
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/hooks/commit-msg.sample
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/hooks/post-update.sample
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/hooks/pre-applypatch.sample
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/hooks/pre-commit.sample
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/hooks/pre-push.sample
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/hooks/pre-rebase.sample
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/hooks/prepare-commit-msg.sample
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/hooks/update.sample
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/info/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/info/exclude
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/logs/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/logs/HEAD
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/logs/refs/
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/logs/refs/heads/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/logs/refs/heads/master
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/logs/refs/remotes/
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/logs/refs/remotes/origin/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/logs/refs/remotes/origin/master
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/04/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/objects/04/8e7eb2703ad8d738a40d3ffc850d7e0fc36af9
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/1e/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/objects/1e/cf8eb94c19f9fe28dd8b7ceb1bd1d18aeeb8b8
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/23/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/objects/23/cb790338e191e29205d6f4123882c0583ef8eb
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/27/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/objects/27/58a1229cc749ff1d2059947ee3a48ad99cc6d1
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/36/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/objects/36/d9d45d2f1d12b31cb47dc6b35084c6a9d81bcd
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/47/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/objects/47/aad072fd814e9e21d69ae14e71a797746cbd37
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/48/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/objects/48/b64bb0223c7755c3ce619422fe4aeecacd8013
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/68/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/objects/68/07164987419755a904012b5d0825dd1024a318
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/6b/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/objects/6b/7bca9f3fde969fb50b4eb3bdab6fac660cd002
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/6c/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/objects/6c/48cc74ba790f1344fe8066f97078703e2343cb
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/8a/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/objects/8a/14fc8d67abc2c4ea19c74a241a7446daa1778f
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/98/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/objects/98/6850040ea5d72f92f87159bcc7cb5cf4a90f4c
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/b5/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/objects/b5/4380385f943d47e3ffd7a46620c9a1c1a30f2f
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/objects/b5/f12ddcfd8b294c0b36deaaf30be2aa2d8309fd
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/bb/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/objects/bb/6e7a06aa2e57e1133e98c1320a514989ba2ce8
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/d5/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/objects/d5/08b6cf43fcd783ed04eb95a2a4145e1efa86d2
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/info/
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/objects/pack/
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/refs/
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/refs/heads/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/refs/heads/master
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/refs/remotes/
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/refs/remotes/origin/
2016/07/31 14:08:45 [7407] >f+++++++++ Git/build_gentoo_kernel/.git/refs/remotes/origin/master
2016/07/31 14:08:45 [7407] cd+++++++++ Git/build_gentoo_kernel/.git/refs/tags/
2016/07/31 14:08:45 [7407] sent 401858 bytes  received 4918 bytes  total size 4273380847
2016/07/31 14:08:45 [7412] building file list
2016/07/31 14:08:45 [7412] sent 182 bytes  received 17 bytes  total size 2567334
2016/07/31 14:08:45 [7418] building file list
2016/07/31 14:08:45 [7418] sent 92657 bytes  received 926 bytes  total size 4273380847
2016/07/31 14:08:45 [7423] building file list
2016/07/31 14:08:45 [7423] sent 182 bytes  received 17 bytes  total size 2567334
mountChoice was: 		3
backupDrive was: 		/dev/sdb1
Drive backup exit code:	0
backupShare was: 		/media/<Your network share>/<Your backup directory>
Share backup exit code:	0
backupDir was: 			/media/<Your backup drive>/<Your backup directory>
The backup was successful and completed without error
```
