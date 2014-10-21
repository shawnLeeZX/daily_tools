#!/bin/bash

usage()
{
    printf "%b" "
This script takes a normal command, in any form, and discard all its
output, then makes it run in the background.

x COMMAND
"
}

"$@" 1>/dev/null 2>&1 &
