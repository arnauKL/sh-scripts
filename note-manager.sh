#!/bin/sh

NOTES_DIRECTORY="$HOME/Notes/"

cd $NOTES_DIRECTORY 

selected_file=$(fzf --preview 'cat {}')

if [ -n "$selected_file" ]; then
    nvim "$selected_file"
fi
