#!/bin/sh


# NOTES_DIRECTORY="$HOME/vaults/Again/"
#
# cd $NOTES_DIRECTORY
#
# selected_file=$(fzf --preview 'bat {}')
#
# if [ -n "$selected_file" ]; then
#     nvim "$selected_file"
# fi


# New version of this same script using 'glow'
# I'd like to add options such as:
# - view by tags (notities project)
# - check spelling (aspell)
# - add a net note

NOTES_DIRECTORY="$HOME/vaults/Again/"

cd $NOTES_DIRECTORY
glow --tui .
