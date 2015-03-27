#!/bin/bash

usage()
{
    printf "%b" "
This script could merge multiple pdf files into one, with order the same with
the order you list the files in the command line.

Usage:
    Output file will be named merge.pdf.

    bash PROG SOURCEs
    "
}

if [ $# -lt 1 ]
then
    usage
    exit 0
fi

gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
   -sOutputFile=merge.pdf \
    ${@}
