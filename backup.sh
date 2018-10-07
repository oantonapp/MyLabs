#!/bin/bash
################## SET PARAMETERS #############################
# Set backup directory
backup_directory="/mnt/VDS_BACKUP"

# Set backup tag
backup_tag="backup_mon"

## USE POOL or Standalone
#true false
used_pool=false

# include libs
dir=`dirname $0`/backup_libs
source $dir"/backup.so"

# Enable logging
# Remove to disable logging
log_enable

date=$(date +%Y-%m-%d_%H-%M-%S)
year=$(date +%Y)
mon=$(date +%m)
day=$(date +%d)

case $backup_vms in

        "all")
                log_message "Backup All VMs"
                set_all_vms
                ;;

        *)
                log_message "Backup no VMs"
                reset_backup_list
                ;;

esac

# Start VM BACKUP
backup_vm_list

