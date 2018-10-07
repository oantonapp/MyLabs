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

### Checking the day of the week
check_day=true
#false
#true 
#Set the day of the week when backup is enabled
day_of_week="Sat"

################################################################
# Which VMs to backup. Possible values are:
# "all" - Backup all VMs
# "running" - Backup all running VMs
# "list" - Backup all VMs in the backup list (see below) or existing backup tag
# "none" - Don't backup any VMs, this is the default
# "tag"  -  Backup VMs whith backup tag
backup_vms="tag"
# VM backup list
#add_to_backup_list "661dcff6-ee79-59a0-efe8-c5d9998071ce"
################################################################

# include libs
dir=`dirname $0`/backup_libs
source $dir"/backup.so"

# Start backup only in Saturday
today=$(date |  awk '{ print $1 }')
if [ $check_day == true ] && [ "$today" != $day_of_week ]; then
#	echo "STOP today not $day_of_week"
       	exit 0
fi

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
         "tag")
                log_message "Backup tag VMs"
                add_to_backup_list_tag
                ;;

        *)
                log_message "Backup no VMs"
                reset_backup_list
                ;;

esac

# Start VM BACKUP
backup_vm_list

# DELETE VM Bckups
if [ $conserved_vds_quantity != 0 ];then
	remove_old_backups
fi


