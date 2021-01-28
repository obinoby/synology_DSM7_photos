# synology_DSM7_photos

Your Synology NAS must be upgraded to DSM 7 beta before use.
The script only works with the new Synology Photos app.

## Disclaimer
This script happend to work for me on my Synology NAS. Use it at your own risks.  
I am running a DS1520+ on DSM 7.0-41222

## Purpose
When upgrading from Synology Moments to Synology Photos all albums that were before under the Shared Space are given to the admin user and shared with other users.
But if you do not use the admin user you loose the ability to share those albums becose you must own them for that.
This script loops over all albums owned by a user to change the ownership to an other user.

## How to
1. Put the script on your Synology NAS
2. Log in your Synology NAS through SSH
3. Elevate to root with : sudo su
4. Go to the script directory : cd /path/to/the/script
5. Run the script : bash ./syno_change_albums_owner.sh old_username new_username

## What it does
- First thing it take a backup of the DB and put it in the current directory
- It finds the user ID for each of the old and the new user
- It finds every albums that belong to the old user
- It loops on each of those albums to change the user-id on :
-- normal_album
-- many_item_has_many_normal_album
-- share
-- share_permission
-- album

It changes the album table at the end because it is the table used to find the albums. By doing so I make sure to be able to re-run on the same set of albums if it fails.

## Know bugs
- On few albums we can not change the permissions anymore
