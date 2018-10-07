#!/bin/bash
################## SET PARAMETERS #############################
# Set backup directory
backup_directory="/mnt/VDS_BACKUP"

# Set backup tag
backup_tag="backup_mon"

# Set log path
log_path="/var/log/xe_backup/vm_backup.log"

### Set the number of conserved VDS per month
### Set 0 (zero) if you do not delete anything
conserved_vds_quantity=3

## USE POOL or Standalone
#true false
used_pool=false

################################################################
# Which VMs to backup. Possible values are:
# "all" - Backup all VMs
# "running" - Backup all running VMs
# "list" - Backup all VMs in the backup list (see below) or existing backup tag
# "none" - Don't backup any VMs, this is the default
# VM backup list
#add_to_backup_list "661dcff6-ee79-59a0-efe8-c5d9998071ce"
################################################################

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

check_backup_cifs  

case $backup_vms in

        "all")
                log_message "Backup All VMs"
                set_all_vms
                ;;

        "running")
                log_message "Backup running VMs"
                set_running_vms
                ;;

        "list")
                log_message "Backup list VMs"
                backup_vm_list
                ;;
        *)
                log_message "Backup no VMs"
                reset_backup_list
                ;;

esac

# Start VM BACKUP
backup_vm_list

