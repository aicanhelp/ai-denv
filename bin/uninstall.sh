#!/bin/sh
##############################################################################################
#
# install.sh
# description: uninstall an installed bmi
#
# usage: uinstall.sh -o [all|bmi|db] [nonrecover]
#   -m   the modes of uninstallation
#        all         --  uninstall bmi including database
#        com         --  uninstall bmi except database objects
#        db          --  uninstall database data only
#   -q            uninstall bmi silently
#
##############################################################################################
PROGNAME=$(basename $0)
PROGNAME_DIR=$(dirname $0)

# Source the utility function script.
source $PROGNAME_DIR/bashlibs/importlibs.shf $PROGNAME_DIR "uninstall.log"

function usage()
{
   Log_disableSum
   echo "usage: $0 -o [all|com|db]"
   echo "arguments:"
   echo "   -o   the modes of uninstallation"
   echo "       all    --  uninstall bmi including database"
   echo "       com    --  uninstall bmi except database objects"
   echo "       db     --  uninstall bmi database objects"
   echo "   -q         uninstall bmi silently"
   echo "help arguments: -h"
   echo " "
   exit 0
}

function check_args()
{
    while getopts t:o:p:qfh options
    do
       case $options in
       o) INSTALL_MODE=$OPTARG; ! BC_isCorrectOption "${INSTALL_MODE}" "${INSTALL_MODE_OPTIONS}" && usage;;
       q) BC_setInstallSilent;;
       p) UNINSTALL_PRODUCTS=$OPTARG;;
       f) UNINSTALL_FORCE=Y;;
       h) usage;;
       \?)usage;;
       esac
    done
}

#function: run_uninstall_process
#Here starts the process of uninstallation
function run_uninstall_process()
{
    check_args $*

    if [ "${INSTALL_MODE}" != "db" ]; then
    	BC_checkInstalled
    	Setup_checkEnv

    	if ! CM_askYesOrNo "Would you like to remove the installed?" Yes $UNINSTALL_CONFIRM; then
        	log "User aborts the operation."
        	log "exit."
        	exit 1
    	fi

        Setup_findAllInstalled "UNINSTALL_PRODUCTS" 

        if [ "${INSTALL_MODE}" != "com" ] && ! Setup_containUseDB "${UNINSTALL_PRODUCTS}"; then
            BC_getDBAddr
            BC_validateDBAccessible
        fi

    	Setup_uninstallAll "${INSTALL_MODE}"

    	log " "
    	log "The Installed products has been removed successfully."
    	log " "
    else
       
        BC_getDBAddr
		BC_validateDBAccessible

        [ "${UNINSTALL_PRODUCTS}" = "" ] && BC_getInstalledProductsFromDB "UNINSTALL_PRODUCTS"
        [ "${UNINSTALL_PRODUCTS}" = "" ] && Setup_getProducts "UNINSTALL_PRODUCTS"
        CM_singleStr "${UNINSTALL_PRODUCTS}" "bmi" && UNINSTALL_PRODUCTS="bmi"

        if ! Setup_containUseDB "${UNINSTALL_PRODUCTS}"; then
			Log_err "No database objects for the specified products '${UNINSTALL_PRODUCTS}'"
			exit 1
        fi

		Setup_forceUninstallDB "${UNINSTALL_PRODUCTS}"

		log " "
    	log "The database object of the specified products '${UNINSTALL_PRODUCTS}' has been removed successfully."
    	log " "
    fi
}

#set the default values
INSTALL_MODE="all"
UNINSTALL_PRODUCTS=""
PRODUCTS_OPTIONS=""

# the entry of uninstalling process
run_uninstall_process $*
