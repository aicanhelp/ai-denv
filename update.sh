#!/usr/bin/env bash

curDir=`pwd`
function update(){
   exist=0
   input=$1

   for dir in `ls .`
   do
      if test -d $dir; then
         cd $dir
         if test -e ".git"; then
            exist=1
            echo "Updating ...... $dir"
            git pull
            cd ..
         else
            if (exist==0); then
               update $dir
            fi
         fi
      fi
   done

   if [ "$curDir" != "$input" ]; then
      cd ..
   fi

}

update $curDir