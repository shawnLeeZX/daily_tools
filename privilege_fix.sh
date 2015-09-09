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
# The '*/\.*' is to exclude hidden file given that it is normally be special
# files that may need special permission, so we do not change them.
# find dose to treat as . according to the man page, but I am sure why I wrote
# it this way first, and adding a backslash seems to work the same.
find $TARGET_FOLDER -type f -not \
    -path '*/\.*' \
    -not -iregex ".*\.\(\(py\)\|\(sh\)\)" \
    -exec chmod 600 {} \; # exclude normal executable files

# Change all executable file to be executable.
find $TARGET_FOLDER -type f -iregex ".*\.\(\(py\)\|\(sh\)\)" -exec chmod 700 {} \;

# Change all folders mode to 700.
find $TARGET_FOLDER -type d -not -path '*/\.*' -exec chmod 700 {} \;
