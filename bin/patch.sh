#!/bin/sh
##############################################################################################
#
# patch.sh
#
##############################################################################################

PROGNAME=$(basename $0)
PROGNAME_DIR=$(dirname $0)

# Source the utility function script.
source $PROGNAME_DIR/bashlibs/importlibs.shf $PROGNAME_DIR "patch.log"

function usage()
{
   Log_disableSum
   echo "usage: $0 [-q]"
   echo "optional arguments:"
   echo "    -q                  patch BMI silently"
   echo ""
   exit 0;
}

#function: handle_arguments
#called by function 'run_install_process' only
function handle_arguments()
{
    local args=$*
    [ "$args" = "" ] && return 0

    while getopts hq options
    do
       case $options in
       q) BC_setInstallSilent;;
       h) usage;;
       \?)usage;;
       esac
    done
}

function start_patch()
{
    handle_arguments $*

    BC_checkInstalled
    Setup_checkEnv

    Patch_start
}

start_patch $*

