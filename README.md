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
5. Run the script : bash ./syno_photos.sh old_username new_username
