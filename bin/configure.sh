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
source $PROGNAME_DIR/bashlibs/importlibs.shf $PROGNAME_DIR "configure.log"
Log_disableSum

function runMySQLiSql()
{
    local l_db_desc="${1:?'function runMySQLiSql: argument db_desc required!'}"
    local l_sqlCommand=${2:?'function runMySQLiSql: argument sql command required!'}

    DB_copyDesc $l_db_desc l_db_desc

    local l_db_conn="-h ${l_db_desc[1]} -u ${l_db_desc[2]}"
    [ "`echo ${l_db_desc[3]} | sed 's/ //'`" != "" ] &&  l_db_conn="$l_db_conn -p${l_db_desc[3]}"
    l_db_conn="$l_db_conn ${l_db_desc[4]}"

    if ! DB_isDbAccessible "l_db_desc" quiet; then
       log "Database is not accessible."
       return 1
    fi

    mysql $l_db_conn -e "${l_sqlCommand}"
}

function list()
{
    local l_paramname=$1
    [ "$l_paramname" != "" ] && check_paramName "$l_paramname"
    local l_sql="select b.nodeid,b.paramname,b.paramvalue,b.datatype,if(b.needrestart,'true','false') as needRestart from bmi.nodeparameter b "
    [ "$l_paramname" != "" ] && l_sql="$l_sql where paramname='$l_paramname'"
    l_sql="$l_sql;"
    runMySQLiSql "DB_DESC" "$l_sql"
}

function listnode()
{
    local l_nodeId=${1:?'listnode: argument nodeId required!'}
    local l_sql="select b.nodeid,b.paramname,b.paramvalue,b.datatype,if(b.needrestart,'true','false') as needRestart from bmi.nodeparameter b "
    l_sql="$l_sql where nodeid=${l_nodeId};"
    runMySQLiSql "DB_DESC" "$l_sql"
}

function update()
{
    local l_paramName=${1:?'update: argument paramName required!'}
    local l_nodeId=${2:?'update: argument paramName required!'}
    local l_paramValue=${3:?'update: argument paramValue required!'}
    Log_warn " "
    Log_warn "A wrong parameter value can cause the exception of BMI."
    Log_warn "please make sure the input value is correct."
    Log_warn " "
    if ! CM_askYesOrNo "Are you sure to update parammeter '$l_paramName' with value '$l_paramValue'?" No; then
         exit 0
    fi

    check_paramName "$l_paramname" "${l_nodeId}"

    runMySQLiSql "DB_DESC" "update bmi.nodeparameter set paramvalue='$l_paramValue' where paramname='$l_paramName';"
    echo
    log "Operation finished."
    echo
}

function check_paramName()
{
    local l_paramName=${1:?'check_paramName: argument paramName required!'}
    local l_nodeId=$2

    local l_sql="select count(*) from bmi.nodeparameter where paramname='$l_paramName'"
    [ "${l_nodeId}" != "" ] && l_sql="${l_sql} and nodeid=${l_nodeId}"
    DB_runSql "DB_DESC" "${l_sql}" l_rowCount true

    if [ "$l_rowCount" = "0" ]; then
       echo
       local errMsg="Invalid parameter name: '$l_paramName' "
       [ "${l_nodeId}" != "" ] && errMsg="${errMsg} under Node ${l_nodeId} "
       Log_err "${errMsg}"
       echo
       exit 1
    fi
}

function usage()
{
   echo
   echo "usage: $0 [list [paramname] | listnode nodeId | update paramname nodeId newvalue]"
   echo "Description:  list or update the parammeters"
   echo "  list [paramname]             list all parameters or specified parameter"
   echo "  listnode nodeId              list all parameters under the specified NodeId"
   echo "  update paramname nodeId newvalue    update the specified parameter of NodeId with new value"
   echo
   exit 0;
}

function runCmd()
{
   local _l_cmd=$1
   case $_l_cmd in
   list|listnode|update)
     $*
     ;;
   *)
     usage
     ;;
   esac
}

runCmd $*

