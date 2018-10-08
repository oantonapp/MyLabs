#!/bin/bash
# mod: Backup_mon.sh
# txt: This is main module
################## SET PARAMETERS #############################
# fun: MAIN_Backup_mon.sh

# env: Var: backup_directory 
# txt: Set backup directory
backup_directory="/mnt/VDS_BACKUP"

# env: Var: backup_tag
# txt: Set backup tag
backup_tag="backup_mon"

# env: Var: log_path
# txt: Set log path
log_path="/var/log/xe_backup/vm_backup.log"
# env: Var: conserved_vds_quantity
# txt: Set the number of conserved VDS per month
#      Set 0 (zero) if you do not delete anything
conserved_vds_quantity=3
# env: Var: used_pool
# txt: USE POOL or Standalone
# opt: bool: true or false
used_pool=false

# env: Var: check_day
# txt: Checking the day of the week
# opt: bool: true or false
check_day=true
#false
#true 
# env: Var: day_of_week
# txt: Set the day of the week when backup is enabled
# txt: template: "Sat"
day_of_week="Sat"
# env: Var: backup_vms
################################################################
# txt:  Which VMs to backup. Possible values are:
# txt:  "all" - Backup all VMs
# txt:  "running" - Backup all running VMs
# txt:  "list" - Backup all VMs in the backup list (see below) or existing backup tag
# txt:  "none" - Don't backup any VMs, this is the default
# txt:  "tag"  -  Backup VMs whith backup tag
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


