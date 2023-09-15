#!/bin/sh
######################################################################################################
#
# upgrade.sh
# description: downgrade the current installed bmi.The downgrade script will do the downgrade according to
#the version of installed bmi and the installer package verison. If the installation package must
#support the downgrade from the current version. For example, a downgrade folder in {installer package}/
#upgrade/iptv/from1.0 is for downgrading from 1.0 to the version of installer package. In the folder,
#there should be a configuration file called version.conf marking the downgrade, and the configuration
#should have two properties: from_version and to_version.
#Various versions will have differrent processes of downgrade. So there are not the common process.
#Each downgrade should define its own script. Here this scripts is the definition of downgrade common flow.
#
# the framework of downgrade is same with upgade.
#
# usage: downgrade.sh [-f] [-d bmiinstaller or backup archive] [-o all|bmi|db] [-p downgradepackage] [-q] [-h]
#
######################################################################################################

PROGNAME=$(basename $0)
PROGNAME_DIR=$(dirname $0)

# Source the utility function script.
source $PROGNAME_DIR/bashlibs/importlibs.shf $PROGNAME_DIR "downgrade.log"

function usage()
{
     Log_disableSum
     echo
     echo "Show help information of $0."
     echo "usage:$0"
#	 echo "usage:$0 [-d bmiinstaller or backup archive] [-p folder] [-o all|bmi|db] [-h]"
#	 echo "options:"
#	 echo "    -o    [optional] the $UPDATE_ACTION options"
#     echo "       all    include all bmi components and database data"
#     echo "       com    bmi components only excluding database data"
#     echo "       db     database data only excluding bmi components"
#     echo "    -d    [optional] the BMI installer or backup archive file. If this option is specified,"
#     echo "          script will use the specified installer or backup archive to $UPDATE_ACTION or restore BMI."
#     echo "          If not, script will use the current installer to do $UPDATE_ACTION."
#     echo "    -q    $UPDATE_ACTION bmi silently"
#	 echo "    -h    help"
	 exit 0
}

#function: handle_arguments
function handle_arguments()
{
    local args=$*
    
   while getopts hqd:o:p: options
    do
       case $options in
       d) UPDATE_TO_D=$OPTARG;; 
       q) BC_setInstallSilent;;
       o) INSTALL_MODE=$OPTARG; ! BC_isCorrectOption "${INSTALL_MODE}" "${INSTALL_MODE_OPTIONS}" && usage;;
       h) usage;;
       \?)usage;;
       esac
    done
    while (($# > 0))
    do
       case $1 in
       -f)shift;;
       -d|-o)shift 2;;
       *)log "ERROR:$0: illegal argument '$args'!";usage;;
       esac
    done
}

function check_arguments()
{
   [ "$UPDATE_TO_D" != "" ] &&  CM_completeDir $UPDATE_TO_D UPDATE_TO_D
   [ "$UPDATE_TO_D" != "" ] && [ -e "$UPDATE_TO_D" ] && return 0
   
   UPDATE_TO_D="$BMI_BACKUP_DIR/update/backup_by_upgrade.tar"
   log " "
   log "Finding the backup archive created by upgrade ... ... '$UPDATE_TO_D' ..."
   log " "
   if [ ! -e "$UPDATE_TO_D" ]; then
       log "ERROR: The backup archive created by upgrade does not exist."
       log " "
       log "Perhaps,The bachup archive has never been created. Or, the backup archive has been moved."
       log "You can finish the downgrade by specifying a backup archive or a installer with argument '-d'."
       log " "
       exit 0
    fi
}

function run_update()
{
   handle_arguments $*

   check_arguments
   Setup_checkEnv
   
   local l_fromVersion
   BC_getInstalledVer "l_fromVersion"

   BAK_startRestore $INSTALL_MODE $UPDATE_TO_D

   local l_toVersion
   BC_getInstalledVer "l_toVersion"

   log " "
   log "The downgrade from '$l_fromVersion' to version '$l_toVersion' is completed."
   log " "	
}

INSTALL_MODE=$INSTALL_MODE_ALL

UPDATE_TO_D=""

#start script
run_update $*
