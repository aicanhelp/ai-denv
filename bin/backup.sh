#!/bin/sh
##############################################################################################
#
# backup.sh
# description: backup or restore bmi
# usage: backup.sh [-cr] [-f tarfile] [-o all|bmi|db]
#        -c          --  create a backup bmi tar file
#        -r          --  restore bmi from a backup tar file
#        -f tarfile     --  specify a tarfile for backup or restore
#                        for restoration, this argument is mandatory
# optional arguments, these options are for restoration only:
#        -o  [all|bmi|db]
#            all         -- restore including bmi and db
#            com         -- restore bmi components only
#            db          -- restore database objects only
#        alone           --restore bmi as stand-alone
#        -q              -- do backup silently
#
##############################################################################################

PROGNAME=$(basename $0) 
PROGNAME_DIR=$(dirname $0)

# Source the utility function script.
source $PROGNAME_DIR/bashlibs/importlibs.shf $PROGNAME_DIR "backup.log"

function usage()
{
   Log_disableSum
   echo "description: backup or restore bmi"
   echo "usage: $0 [-cr] [-f tarfile] [-o all|bmi|db]"
   echo "mandatory arguments:"
   echo "    -c          create a backup bmi tar file"
   echo "    -r          restore bmi from a backup tar file"
   echo "    -f tarfile     specify a tarfile for backup or restore"
   echo "                for creating, this argument is not mandatory"
   echo " "
   echo "optional arguments:"
   echo "    -o          options for restoration"
   echo "        all         restore including bmi and db"
   echo "        com         restore bmi components only"
   echo "        db          restore database objects only"
   echo "    -q          do backup silently"
   echo "help argument '-h'."
   echo " "
   exit 0;
}

#function: handle_arguments
#called by function 'run_install_process' only
function run_backup_restore_process()
{
    if [ $# = 0 ]; then
       log "ERROR: $0: arguments required!"
       log " "
       usage
    fi
    local args=$*
    if (CM_singleStr "$args" "-c" && CM_singleStr "$args" "-r") || CM_singleStr "$args" "-cr"; then
       log " "
       log "ERROR: $0: You can not specify more than one '-cr' options!"
       log " "
       usage
    fi
    
    if CM_singleStr "$args" "-r" && ! CM_singleStr "$args" "-f"; then
       log " "
       log "ERROR: Restoration requires bmi backup package file. "
       log " "
       usage
    fi
    
    local _l_action
    local _l_file
    while (( $#>0 ))
    do
       case $1 in
       -c) _l_action="create";;
       -r) _l_action="restore";;
       -f) shift 1;_l_file=$1;;
       -q) BC_setInstallSilent;;
       -o) shift 1; INSTALL_MODE=$1;
           [ -z ${INSTALL_MODE} ] && echo && echo "Error: argument value required for -o!" && usage; 
           ! BC_isCorrectOption "${INSTALL_MODE}" "${INSTALL_MODE_OPTIONS}"  && usage;;
       -h|\?) usage;;
       \?) echo "Error: invalid argument - $1"; usage;;
       esac
       shift 1
    done
    
    if [[ $_l_action = create ]]; then
    	 BC_checkInstalled
       Setup_checkEnv2
       BAK_startBackup $INSTALL_MODE $_l_file
    fi
    
    if [[ $_l_action = restore ]]; then
       BC_showInstalled
       Setup_checkEnv
       BAK_startRestore $INSTALL_MODE $_l_file
    fi
}

# the entry of installing process
INSTALL_MODE=$INSTALL_MODE_ALL
run_backup_restore_process $*
