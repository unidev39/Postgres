#!/bin/bash

##########################################################################################################
# Unidev39 its affiliates. All rights reserved.
# File          : Standalone_Postgres_17_Cumulative_Base_Backup.sh
# Purpose       : To Take a Base Full and Cumulative Incremental Backup on Postgres 17
# Usage         : ./Standalone_Postgres_17_Cumulative_Base_Backup.sh
# Created By    : Devesh Kumar Shrivastav
# Created Date  : January 01, 2025
# Revision      : 1.0
###########################################################################################################
#########BOF This is part of the Standalone_Postgres_17_Cumulative_Base_Backup.sh##########################
##export PATH=$PATH:/usr/lib/postgresql/17/bin
##pg_combinebackup -o /backup/combine /backup/Bck_W02_Full_Jan_2025 /backup/Bck_W02_Inc_09_Jan_2025_1208

# Variables
export lv_backup_dir="/backup"
export lv_full_backup_dir="${lv_backup_dir}/Bck_$(date +W%V)_Full_$(date +'%b_%Y')"
export lv_manifest_dir="${lv_full_backup_dir}/backup_manifest"
export lv_inc_backup_dir="${lv_backup_dir}/Bck_$(date +W%V)_Inc_$(date +'%d_%b_%Y')_$(date +%H%M)"
export lv_manifest_file="${lv_backup_dir}/script/.backup_manifest"

# Function to take base backup logs
fn_log_me() {
pv_msg=$1
pv_msg_mode=$2
[ ${pv_msg_mode}=="" ] && pv_msg_mode="INFO"
echo "$(date +%D_%H%M%S), ${pv_msg_mode}: ${pv_msg}"
}

# Function to take full base backup
fn_full_backup() {

# Create full backup directory if it doesn't exist
[ ! -f "${lv_full_backup_dir}" ] && mkdir -p "${lv_full_backup_dir}"

# Take full base backup with manifest and checksum algorithm
pg_basebackup -D "${lv_full_backup_dir}" -Fp -Xs -P --write-recovery-conf --manifest-checksums=SHA256

# Check if the backup was successful
if [ $? -eq 0 ]; then
    fn_log_me "Full base backup completed successfully."
else
    fn_log_me "Full base backup failed."
    exit 1
fi
}

# Function to take incremental backup
fn_inc_backup() {

# Create incremental backup directory if it doesn't exist
[ ! -f "${lv_inc_backup_dir}" ] && mkdir -p "${lv_inc_backup_dir}"

# Take incremental base backup using existing manifest
pg_basebackup -D "${lv_inc_backup_dir}" -Fp -Xs -P --incremental="${lv_manifest_dir}"
if [ $? -eq 0 ]; then
    fn_log_me "Incremental backup completed successfully."
else
    fn_log_me "Incremental backup failed."
    exit 1
fi
}

# Check if manifest file exists to decide on full or incremental backup
[ ! -f "${lv_manifest_dir}" ] && fn_full_backup || fn_inc_backup
exit
###########################################################################################################
#########EOF This is part of the Standalone_Postgres_17_Cumulative_Base_Backup.sh##########################
