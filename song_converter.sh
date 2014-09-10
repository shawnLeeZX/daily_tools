#!/bin/bash

# pacpl usage sample:
# pacpl -t mp3  -v -bitrate 320 --overwrite 致青春.mp

usage()
{
    printf "%b" "

Usage:
    song_converter.sh will use pacpl to extract video' audio from mp4 file and
    store it in mp3 format.

    bash song_converter.sh TARGET_FOLDER
    "
}

print_separator()
{
    for i in {1..80}
    do
        printf "="
    done
    printf "\n\n"
}

if [ $# -ne 1 ]
then
    usage
    exit 0
fi

TARGET_FOLDER=`readlink -f $1`
TARGET_FILES="$TARGET_FOLDER/*mp4"

# Check any mp4 files under this folder.
if ! ls $TARGET_FILES >& /dev/null
then
    echo "No mp4 files found."
    echo "Exiting..."
    exit 0
fi

echo 'Begin converting...'
print_separator

for file in $TARGET_FILES
do
    echo "Converting ${file}..."
    pacpl -t mp3 --overwrite "$file" >& /dev/null

    # Since pacpl does not return error code correctly, do manual check on file
    # existence to know whether conversion succeeded.
    if [ -e "${file/4/3}" ]
    then
        echo "$file converted to mp3 format."
        echo "Deleting original ${file}..."
        rm "$file"
    else
        echo "Some wrong when converting."
        echo "Exit code $?."
        echo "Skipped ${file}."
        continue
    fi

    print_separator
done
