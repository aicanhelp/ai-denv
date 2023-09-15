#!/bin/sh
##############################################################################################
#
# install.sh
# description: TSX1000 installer
# usage: install.sh [-p product suite] [-o db|com|all] [-q]
##############################################################################################

PROGNAME=$(basename $0)
PROGNAME_DIR=$(dirname $0)
LOG_FILE="install.log"
INSTALLER_DIR="$PROGNAME_DIR"
# Source the utility function script.
source ${INSTALLER_DIR}/bashlibs/importlibs.shf "${INSTALLER_DIR}" "${LOG_FILE}"

INSTALL_MODE="all"
PRODUCTS_OPTIONS=""
PRODUCT_SUITE_OPTIONS="bmi report monitor"
PRODUCT_SUITES=("bmi ad ams sg" "sareport etl" "monitor")
TOOLS_OPTIONS=""

INSTALL_DEFAULT="bmi ad ams sg"

INSTALL_PRODUCTS=""
INSTALL_TOOLS=""
INSTALL_SUITE=""

function usage()
{
	 local products_options="`echo ${PRODUCTS_OPTIONS} | sed 's/bmi//g' | sed 's/sareport//g' | sed 's/monitor//g'`"
   Log_disableSum
   echo
   echo "usage: $0 [-p {product suite}] [-c product component] [-t toolName] [-o all|com|db] [-q]"
   echo "optional arguments:"
   echo "    -p product suite "
   echo "       including: ${PRODUCT_SUITE_OPTIONS}"
   echo "    -c product component "
   echo "       including: ${products_options}"
   echo "    -t toolName"
   echo "       including: ${TOOLS_OPTIONS}"
   echo "    -o [all|com|db] "
   echo "        all         including components and database objects"
   echo "        com         install components only"
   echo "        db          install database objects only"
   echo "    -q              install silently"
   echo "   -f  force to install database objects"
   echo
   echo " Note: argument '-p' and '-c' can not be used at the same time."
   echo
   exit 0;
}

function init_install_options()
{
    Setup_getProducts "PRODUCTS_OPTIONS" && Setup_getTools "TOOLS_OPTIONS"

    if CM_singleStr "$PRODUCTS_OPTIONS" "bmi"; then
        PRODUCT_SUITE_OPTIONS="bmi report monitor"
        INSTALL_SUITE="bmi"
        INSTALL_DEFAULT=${PRODUCT_SUITES[0]}
    elif CM_singleStr "$PRODUCTS_OPTIONS" "sareport"; then
        PRODUCT_SUITE_OPTIONS="report"
        INSTALL_SUITE="report"
        INSTALL_DEFAULT=${PRODUCT_SUITES[1]}
    elif CM_singleStr "$PRODUCTS_OPTIONS" "monitor"; then
        PRODUCT_SUITE_OPTIONS="monitor"
        INSTALL_SUITE="monitor"
        INSTALL_DEFAULT=${PRODUCT_SUITES[2]}
    fi
}

function set_install_suite()
{
    local suite=$1
    if [ -z $suite ]; then
       Log_err "Invalid product suite: null value"
       usage
    fi
    ! BC_isCorrectOption "$1" "${PRODUCT_SUITE_OPTIONS}" && usage

    case $1 in
        bmi) INSTALL_PRODUCTS=${PRODUCT_SUITES[0]};;
        report) INSTALL_PRODUCTS=${PRODUCT_SUITES[1]};;
        monitor) INSTALL_PRODUCTS=${PRODUCT_SUITES[2]};;
    esac
    INSTALL_SUITE=$suite
}

function check_args()
{
    init_install_options
    
    local args="$*"
    if [ "$args" != "" ] && CM_singleStr "$args" "-p" && CM_singleStr "$args" "-c"; then
        Log_err "Can not specify argument '-p' and argument '-c' at the same time."
        usage
    fi

    while (( $#>0 ))
    do
       case $1 in
       -p) shift 1; set_install_suite "$1"; shift 1;;
       -c) shift 1; INSTALL_SUITE="";
           while [[ $1 != -* ]] && [[ "$1" != "" ]]
           do
              ! BC_isCorrectOption "$1" "${PRODUCTS_OPTIONS}" && echo "Error: invalid argument - $1" && usage
              INSTALL_PRODUCTS="$1 `echo ${INSTALL_PRODUCTS} | sed 's/${_l_temps}'//`"
              shift 1;
           done
           ;;
       -t) shift 1;
           while [[ $1 != -* ]] && [[ "$1" != "" ]]
           do
              ! BC_isCorrectOption "$1" "${TOOLS_OPTIONS}" && echo "Error: invalid argument - $1" && usage
              INSTALL_TOOLS="$1 `echo ${INSTALL_TOOLS} | sed 's/$1'//`"
              shift 1;
              _l_temps=$1
           done
           ;;
       -o) shift 1; INSTALL_MODE=$1; 
           [ -z ${INSTALL_MODE} ] && echo && echo "Error: argument value required for -o!" && usage; 
           ! BC_isCorrectOption "${INSTALL_MODE}" "${INSTALL_MODE_OPTIONS}" && usage;
           shift 1;;
       -q) BC_setInstallSilent;shift 1;;
       -f) UNINSTALL_FORCE=Y;;
       \?|-h) usage;;
       *) echo "Error: invalid argument - $1"; usage;;
       esac
    done
}

function install_products()
{
	if ! Setup_checkCoinstall "${INSTALL_PRODUCTS}"; then
        Log_err "Product components '${INSTALL_PRODUCTS}' can not be co-installed."
        exit 0;
    fi

    BC_showInstalled
    Setup_checkEnv "${INSTALL_PRODUCTS}"

    log "This installation will install products:"
    if [ "${INSTALL_SUITE}" != "" ]; then
       log "including: product suite '${INSTALL_SUITE}' with components '${INSTALL_PRODUCTS}'"
    else
       log "including: product components '${INSTALL_PRODUCTS}'"
    fi
    [ "${INSTALL_TOOLS}" != "" ] && log "including: other tools '${INSTALL_PRODUCTS}'"
    echo
    if ! CM_askYesOrNo "Are you sure you want to install them?" Yes $INSTALL_CONFIRM; then
       log "User aborts the operation."
       log "exit."
       exit 1
    fi

    Setup_startInstall "${INSTALL_PRODUCTS}" "${INSTALL_MODE}"
}

#function: run_install_process
#Here starts the process of installation
function start_install()
{
    check_args $*
	[ "${INSTALL_PRODUCTS}" = "" ] && [ "${INSTALL_TOOLS}" = "" ]  && INSTALL_PRODUCTS=${INSTALL_DEFAULT}
    if [ "${INSTALL_MODE}" != "db" ]; then
    	
    	[ "${INSTALL_TOOLS}" != "" ] && Setup_installTools "${INSTALL_TOOLS}" "${INSTALL_MODE}"
    
    	[ "${INSTALL_PRODUCTS}" != "" ] && install_products
	else
		Setup_startInstall "${INSTALL_PRODUCTS}" "${INSTALL_MODE}"
	fi

}

start_install $*

