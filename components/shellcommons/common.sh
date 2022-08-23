#!/usr/bin/env bash

function get_functions() {
    prefix=$1
    ex_functions=(`declare -F`)
    for f_name in ${ex_functions[*]}
    do
        case ${f_name} in
        ${prefix}_*)
           echo "${f_name:12}"
           ;;
        esac
    done
}