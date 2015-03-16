#!/bin/bash

usage()
{
    printf "%b" "

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
