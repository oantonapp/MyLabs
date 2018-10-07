#!/bin/bash
################## SET PARAMETERS #############################
# Set backup directory
backup_directory="/mnt/VDS_BACKUP"


# Set log path
log_path="/var/log/xe_backup/vm_backup.log"

# Set backup tag
backup_tag="backup_mon"

# Enable logging
# Remove to disable logging
log_enable


## USE POOL or Standalone
#true false
used_pool=false


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

