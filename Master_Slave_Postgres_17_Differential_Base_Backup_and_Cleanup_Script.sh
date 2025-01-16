#!/bin/bash

##########################################################################################################
# Unidev39 its affiliates. All rights reserved.
# File          : Master_Slave_Postgres_Base_Backup_and_Cleanup_Script.sh
# Purpose       : To Take a Base Full and Incremental Backup with Cleanup on Postgres 17
# Usage         : ./Master_Slave_Postgres_Base_Backup_and_Cleanup_Script.sh
# Created By    : Devesh Kumar Shrivastav
# Created Date  : January 16, 2025
# Revision      : 2.0
###########################################################################################################
###############BOF This is part of the Master_Slave_Postgres_Base_Backup_and_Cleanup_Script.sh#############
##pg_combinebackup -o /backup/combine /backup/Bck_W03_Full_Jan_2025 $(ls -d /backup/Bck_W03_Inc* | sort)

# Variables
export lv_backup_dir="/backup"
export lv_full_backup_dir="${lv_backup_dir}/Bck_$(date +W%V)_Full_$(date +'%b_%Y')"
export lv_manifest_dir="${lv_full_backup_dir}/backup_manifest"
export lv_inc_backup_dir="${lv_backup_dir}/Bck_$(date +W%V)_Inc_$(date +'%d_%b_%Y')_$(date +%H%M)"
export lv_manifest_file="/data/postgres/17/script/.backup_manifest"
export lv_replication_user="replica_user"
export lv_archive_dir="/log/postgres/17"
export lv_log_file="${lv_backup_dir}/backup_logs/backup_and_cleanup_$(date +'%Y%m%d').log"

# Function to log messages
fn_log_message() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - ${message}" | tee -a "${lv_log_file}"
}

# Log Segregation
fn_log_message "########### Starting Base backup and Clenup. $(date +'%Y-%m-%d %H:%M:%S') #############"

# Function to perform full backup
fn_full_backup() {
    fn_log_message "Starting full base backup."

    # Create full backup directory if it doesn't exist
    [ ! -f "${lv_full_backup_dir}" ] && mkdir -p "${lv_full_backup_dir}"

    # Take full base backup with manifest and checksum algorithm
    pg_basebackup -D "${lv_full_backup_dir}" -Fp -Xs -P -U "${lv_replication_user}" --write-recovery-conf --manifest-checksums=SHA256

    if [ $? -eq 0 ]; then
        fn_log_message "Full base backup completed successfully."
        echo ${lv_manifest_dir} > ${lv_manifest_file}
        # Perform WAL cleanup after the full backup
        fn_wal_cleanup
    else
        fn_log_message "Full base backup failed."
        exit 1
    fi
}

# Function to perform incremental backup
fn_inc_backup() {
    fn_log_message "Starting incremental base backup."

    # Create incremental backup directory if it doesn't exist
    [ ! -f "${lv_inc_backup_dir}" ] && mkdir -p "${lv_inc_backup_dir}"
    export lv_inc_manifest_dir=$(cat ${lv_manifest_file})

    # Take incremental base backup using existing manifest
    pg_basebackup -D "${lv_inc_backup_dir}" -Fp -Xs -P -U "${lv_replication_user}" --incremental="${lv_inc_manifest_dir}"

    if [ $? -eq 0 ]; then
        fn_log_message "Incremental backup completed successfully."
        echo "$lv_inc_backup_dir/backup_manifest" > ${lv_manifest_file}
        # Perform WAL cleanup after the incremental backup
        fn_wal_cleanup
    else
        fn_log_message "Incremental backup failed."
        exit 1
    fi
}

# Function to clean up old WAL files
fn_wal_cleanup() {
    fn_log_message "Starting WAL cleanup process."

    ### Ensure the log directory exists
    mkdir -p "$(dirname "$lv_log_file")"

    # Determine which backup directory to use (full or incremental)
    if [ -f "${lv_inc_backup_dir}/backup_manifest" ]; then
        pv_backup_dir="${lv_inc_backup_dir}"
    elif [ -f "${lv_full_backup_dir}/backup_manifest" ]; then
        pv_backup_dir="${lv_full_backup_dir}"
    else
        fn_log_message "Error: No valid backup manifest found (full or incremental)."
        exit 1
    fi

    # Extract the WAL file to keep from the backup label
    pv_old_archive_dir="${lv_archive_dir}/old_archive_$(date +'%Y%m%d_%H')"
    pv_keep_wal_file=$(grep "START WAL LOCATION" "${pv_backup_dir}/backup_label" | awk -F'[(|)]' '{print $2}' | awk '{print $2}' | awk -F'/' '{print $1}')
        if [ -z "$pv_keep_wal_file" ]; then
            fn_log_message "Error: Could not determine the starting WAL file from the backup_label in ${pv_backup_dir}."
            exit 1
        fi

    # Output for the starting WAL location
    fn_log_message "WAL file comparison starting:"
    fn_log_message "Keep WAL file starts from: $pv_keep_wal_file"

    # Create old archive directory if it doesn't exist
    mkdir -p "$pv_old_archive_dir"

    # Use find to list all files in the archive directory (recursively)
    fn_log_message "Listing all files in $lv_archive_dir:"
    find "$lv_archive_dir" -type f | while read wal_file; do
        base_name=$(basename "$wal_file")

        # Output for each file found
        fn_log_message "Checking file: $base_name"

        # Check if the file is a valid WAL file or a .backup file
        if [[ "$base_name" =~ ^[0-9A-F]{24}$ || "$base_name" =~ ^[0-9A-F]{24}\.000000[0-9A-F]+\.backup$ ]]; then
            fn_log_message "This is a valid WAL or .backup file."

            # If it's a .backup file, remove the .backup suffix for comparison
            if [[ "$base_name" =~ \.backup$ ]]; then
                base_name="${base_name%.backup}"
            fi

            # Comparison result
            fn_log_message "Comparing: $base_name with $pv_keep_wal_file"
            if [[ "$base_name" < "$pv_keep_wal_file" ]]; then
                fn_log_message "Moving file: $wal_file to $pv_old_archive_dir"
                # Uncomment this to actually move the files:
                mv "$wal_file" "$pv_old_archive_dir/"
            else
                fn_log_message "Keeping file: $wal_file"
            fi
        else
            fn_log_message "Skipping non-WAL file: $wal_file"
        fi
    done

    # Compress the old WAL directory
    pv_compressed_file="$pv_old_archive_dir.tar.gz"
    fn_log_message "Compressing old WAL directory: $pv_old_archive_dir"
    tar -czf "$pv_compressed_file" -C "$lv_archive_dir" "$(basename "$pv_old_archive_dir")"
    if [ $? -eq 0 ]; then
        rm -rf "$pv_old_archive_dir"
        fn_log_message "WAL cleanup complete. Compressed file: $pv_compressed_file"
    else
        fn_log_message "Error: Failed to compress the directory: $pv_old_archive_dir"
        exit 1
    fi
}

# Check if manifest file exists to decide on full or incremental backup
[ ! -f "${lv_manifest_dir}" ] && fn_full_backup || fn_inc_backup
exit
###########################################################################################################
###############EOF This is part of the Master_Slave_Postgres_Base_Backup_and_Cleanup_Script.sh#############