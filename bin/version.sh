#!/bin/sh
##############################################################################################
#
# version.sh
# description: show the installer package version or the current installed bmi version
# usage: version.sh [-h]
#
##############################################################################################

PROGNAME=$(basename $0)
PROGNAME_DIR=$(dirname $0)

# Source the utility function script.
source $PROGNAME_DIR/bashlibs/importlibs.shf $PROGNAME_DIR
Log_disableSum

function usage()
{
   echo "usage: $0 [-h]"
   echo "Description: show the installer package version or the current installed version"
   exit 0;
}

function show_version_info()
{
   [ $# != 0 ] &&  CM_singleStr "$*" "-h" && usage
	 
   echo
   if [ -d ${PROGNAME_DIR}/tools ] && [ -f ${PROGNAME_DIR}/install.sh ]; then
      local _l_package_version
      local _l_products
      Setup_getProducts "_l_products"
      BC_getPackageVer _l_package_version
      echo "The version of the installer package is '$_l_package_version', contain: ${_l_products}"
   fi
   
   echo
   
   if ! BC_isInstalled; then
      echo "None BMI is installed in the current machine!"
   else
      local _l_installed_version
      local _l_installed
      Setup_findAllInstalled "_l_installed"
      BC_getInstalledVer _l_installed_version
      echo "The version of the current installed is '$_l_installed_version', installed: ${_l_installed}"
   fi
   
   echo
}

show_version_info $*
