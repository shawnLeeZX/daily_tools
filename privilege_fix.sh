#!/bin/bash

usage()
{
    printf "%b" "
This script will change the priviledge of files and folders under the
folder given into a safe mode.

Usage:
    bash priviledge_fix.sh TARGET_FOLDER
"
}

if [ $# -ne 1 ]
then
    usage
    exit 0
fi

TARGET_FOLDER=$1

# Change all files mode to 600.
find $TARGET_FOLDER -type f -not -path '*/\.*' -exec chmod 600 {} \;
# Change all folders mode to 700.
find $TARGET_FOLDER -type d -not -path '*/\.*' -exec chmod 700 {} \;
