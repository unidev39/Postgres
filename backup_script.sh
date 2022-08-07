#!/bin/bash

. $HOME/.ra.env
#######################################################################################################################
# File          : backup_script.sh
# Purpose       : To Take a Backup of Relevant Schema of Postgres
# Usage         : ./backup_script.sh
# Created By    : Devesh Kumar Shrivastav
# Created Date  : July 03, 2022
# Revision      : 1.0
#######################################################################################################################
########################################BOF This is part of the backup_script.sh#######################################

# Export the Postgres environment
export PGDATA=/var/lib/pgsql/data

# Collect the Informatios From File
for f in $FILENAME
do
  g_1=`sed -n '1p' $f`
  g_2=`sed -n '2p' $f`
  g_3=`sed -n '3p' $f`
done

# Load the Informations for the relevant varibals
databasename=${g_1}
schemaname=${g_2}
location=${g_3}

# Backup The Relevanat Schema
pg_dump --dbname=${databasename} --schema=${schemaname} > ${location}/${schemaname}_$(date +%Y-%m-%d).psql

# Remove 7 Days Old Backup of The Relevant Schema
find ${location}/ -type f -iname '${schemaname}_*.psql' -mtime +7 -type f -name "${schemaname}_*.psql" -exec rm -f {} \;

exit

######################################EOF This is part of the backup_script.sh##########################################
#########################################################################################################################