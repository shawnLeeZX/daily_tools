#!/bin/bash
# Copyright 2015
#
# Filename: djvu_2_pdf.sh
# Author: Shuai
# Contact: lishuai918@gmail.com
# Created: Fri Mar 27 15:32:43 2015 (+0800)
# Package-Requires: ()
# Last-Updated:
#           By:
#     Update #: 138
#
#
# Commentary:
# See usage below.
#
# Code:

usage()
{
    printf "%b" "
The script converts document from djvu format to pdf format. The most important
feature is that it keeps the text layer of djvu file so you could highlight
text! This is very important for serious reading of books.

Usage:
  bash djvu_2_pdf.sh INPUT_FILE

The output will the same file name with a change of suffix.

The script depends on [ocrodjvu](http://jwilk.net/software/ocrodjvu) and
[pdfbeads](https://rubygems.org/gems/pdfbeads),
[DjVuLibre](http://djvu.sourceforge.net/doc/index.html) and gs(Ghost script,
which normally include in modern UNIX OS by default.)
"
}

if [ $# -lt 1 ]
then
    usage
    exit 0
fi

DJVU_FILE=$1
FILE_NAME=${DJVU_FILE%.djvu}

# We process the document page by page since it seems that pdfbeads will create
# very large intermediate files during operation, which impractical.

TMP_DIR="/tmp/djvu_2_pdf_${FILE_NAME}"

# Create the tmp folder to hold intermediate output.
if [ ! -d ${TMP_DIR} ]
then
    mkdir ${TMP_DIR}
fi

# For release.
PAGE_NUM=$(djvused -e n ${DJVU_FILE})
# For testing.
# PAGE_NUM=2
# We have to keep the created pdf files in order, so we maintain a list.
pdf_file_list=""

for (( page=1; page <= ${PAGE_NUM}; page++ ))
do
    # Save current pwd. We change directory because pdfbeads will find its
    # intermediate file under the current folder. If we do not change
    # directory, it cannot find relevant files.
    pushd .

    # Extract text layer.
    OCR_OUTPUT="${TMP_DIR}/${FILE_NAME}_p${page}.html"
    djvu2hocr -p ${page} ${DJVU_FILE} | sed 's/ocrx/ocr/g' > ${OCR_OUTPUT}
    # Extract image layer.
    TIF_OUTPUT="${TMP_DIR}/${FILE_NAME}_p${page}.tif"
    ddjvu -format=tiff -page=${page} ${DJVU_FILE} ${TIF_OUTPUT}

    # Actually create pdf for each page.
    cd ${TMP_DIR}
    PDF_OUTPUT="${TMP_DIR}/${FILE_NAME}_p${page}.pdf"
    # After some painful test, it seems that pdfbeads works this way:
    #   Given one image file to process, it would try to find the text file
    #   under the same folder. So we need to change to the temporary folder and
    #   remove the suffix of the *.tif files.
    pdfbeads -B 100 ${TIF_OUTPUT##*/} -o ${PDF_OUTPUT}
    # Add the pdf to the list.
    pdf_file_list="${pdf_file_list} ${PDF_OUTPUT}"

    # Return back to previous folder.
    popd
done

# Merge all pdf files.
gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
   -sOutputFile="${FILE_NAME}.pdf" \
    ${pdf_file_list}

# Cleanup tmp folder.
rm -rf ${TMP_DIR}

#
# djvu_2_pdf.sh ends here
