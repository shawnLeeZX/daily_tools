#!/bin/bash

usage()
{
    printf "%b" "

Usage:
    $1 is the first page of the range to extract
    $2 is the last page of the range to extract
    $3 is the input file
    output file will be named 'inputfile_pXX-pYY.pdf'

    bash PROG FIRST_PAGE LAST_PAGE INPUT
    "
}

if [ $# -ne 3 ]
then
    usage
    exit 0
fi

gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
   -dFirstPage=${1} \
   -dLastPage=${2} \
   -sOutputFile=${3%.pdf}_p${1}-p${2}.pdf \
   ${3}
