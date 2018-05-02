#!/bin/bash
COMP=$1
FILE=$2
dpkg -s inotify-tools &> \dev\null
IS_INOTIFY_TOOLS=$?
if [ $IS_INOTIFY_TOOLS -eq 1 ]; then
    (>&2 echo "Please install inotify-tools")
    exit 1;
fi

while inotifywait -e close_write $FILE; do
    $COMP $FILE;
done
