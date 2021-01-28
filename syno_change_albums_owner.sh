#!/usr/bin/env bash

old_owner_name=$1
new_owner_name=$2

# backup DB
echo "Backup the DB before touching it"
sudo -u postgres pg_dump -d synofoto > bck_synofoto_$(date +"%Y%m%d-%H%M%S").psql
if [ $? -ne 0 ]; then
  echo "Backup failed - Aborting"
  exit 1
fi

## Connect to pgsql
pg_connect="sudo -u postgres psql -d synofoto -t -c "

## Fet owners IDs
echo "Getting the users respective IDs"
old_owner_id=$(${pg_connect} "select id from user_info where name='$old_owner_name' ;" | sed 's/ //g') > query_result.log
new_owner_id=$(${pg_connect} "select id from user_info where name='$new_owner_name' ;" | sed 's/ //g') >> query_result.log

## Get all the albums
echo "Get all albums belonging to $old_owner_name"
result=$(${pg_connect} "select id,passphrase_share from album where id_user=$old_owner_id ;" | sed 's/ //g') >> query_result.log

## For each album
echo "Modifying all albums one by one"
for line in $result; do
  album_id=$(echo $line | cut -d\| -f1)
  share_id=$(echo $line | cut -d\| -f2)

  ## Update owner on relevent tables
  echo "----- album id $album_id"
  ### normal_album
  echo "- Change owner on normal_album"
  ${pg_connect} "update normal_album set id_user=$new_owner_id where id=$album_id ;" >> query_result.log
  if [ $? -ne 0 ]; then exit 1; fi
  ### many_item_has_many_normal_album
  echo "- Change owner on many_item_has_many_normal_album"
  ${pg_connect} "update many_item_has_many_normal_album set album_id_user=$new_owner_id, item_provider_id_user=$new_owner_id where id_normal_album=$album_id ;" >> query_result.log
  if [ $? -ne 0 ]; then exit 1; fi
  ## share
  echo "- Change owner on share"
  ${pg_connect} "update share set id_user=$new_owner_id where passphrase='$share_id' ;" >> query_result.log
  if [ $? -ne 0 ]; then exit 1; fi
  ## share_permission
  echo "- Change owner on share_permission"
  ${pg_connect} "update share_permission set id_user=$new_owner_id where passphrase_share='$share_id' ;" >> query_result.log
  if [ $? -ne 0 ]; then exit 1; fi
  ### album at the end to be able to redo in case of error
  echo "- Change owner on album"
  ${pg_connect} "update album set id_user=$new_owner_id where id=$album_id ;" >> query_result.log
  if [ $? -ne 0 ]; then exit 1; fi
done

echo " All done ;)"

exit 0
