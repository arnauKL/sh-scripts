#!/usr/bin/env sh

#inotify info:
#https://linuxconfig.org/how-to-monitor-filesystem-events-on-files-and-directories-on-linux

# the file to watch, should be given as arg
FILENAME=$1

if [ -z "$FILENAME" ]; then
    echo "error: No filename provided."
    echo "usage: $0 <filename> [compiler]"
    exit 1
fi

if [ ! -f "$FILENAME" ]; then
    exit 1
fi

# the compiler to use, default to make
if [ -z "$2" ]; then
    COMPILER="make"
else
    COMPILER="$2"
fi

# This does not work on nvim because of the way it saves files
# inotifywait -m -e modify "$FILENAME" | while read -r event; do
#   echo "running $COMPILER..."
#   $COMPILER "$FILENAME"
# done


# The -m flag keeps inotifywait running indefinitely instead of existing after a
# single event, and -e modify specifies to watch for modification events.


DIR=$(dirname "$FILENAME")
BASE=$(basename "$FILENAME")

# Watch the directory for specific "save-like" events
inotifywait -m -e close_write -e moved_to "$DIR" | while read -r directory events filename; do
    # Only run the compiler if the changed file matches the target
    if [ "$filename" = "$BASE" ]; then
        echo "Change detected in $filename. Running $COMPILER..."
        $COMPILER
    fi
done
