#!/bin/sh
######################################################################################################
#
# upgrade.sh
# description: upgrade the current installed bmi.
#    
# usage: upgrade.sh [-f] [-o all|com|db] [-q] [-h]"
#  
######################################################################################################

PROGNAME=$(basename $0)
PROGNAME_DIR=$(dirname $0)

# Source the utility function script.
source $PROGNAME_DIR/bashlibs/importlibs.shf $PROGNAME_DIR "upgrade.log"

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
#     echo "    -q    $UPDATE_ACTION bmi silently"
#	 echo "    -h    help"
	 exit 0
}

#function: handle_arguments
function handle_arguments()
{
    local args=$*
    
    while getopts hqo: options
    do
       case $options in
       q) BC_setInstallSilent;;
       o) INSTALL_MODE=$OPTARG; ! BC_isCorrectOption "${INSTALL_MODE}" "${INSTALL_MODE_OPTIONS}" && usage;;
       h) usage;;
       \?)usage;;
       esac
    done
}

function run_update()
{
   handle_arguments $*

   #BC_checkInstalled
   Setup_checkEnv
   
   Upgrade_start "${INSTALL_MODE}"
}

INSTALL_MODE=$INSTALL_MODE_ALL
#start script
run_update $*
