#!/usr/bin/env bash

NOTES_DIRECTORY="$HOME/2_Notes/"

cleanup () {
    # Returns the terminal to how it was before the script was ran
    tput rmcup
    tput cnorm  # Makes cursor visible again
}

fzf_filename() {
    # filename search
    selection=$(fzf --height 80% --reverse --preview 'bat --color=always --style=plain {}' \
        --header 'find note by filename' \
        --preview-window '50%,bottom,border-sharp')
        #--preview-window '50%,top,border-horizontal')

    if [ -n "$selection" ]; then
        nvim "$selection"
    fi
}

fzf_rgrep(){
    # text search:
    selection=$(fzf --ansi --height 80% --reverse \
        --bind "change:reload:rg --column --line-number --no-heading --smart-case --color=always {q} || true" \
        --disabled \
        --delimiter : \
        --header 'live grep in notes directory' \
        --preview 'bat --color=always --highlight-line {2} {1}' \
        --preview-window '50%,bottom,border-sharp,+{2}+3/3')

    # Extract filename and line number from the selection
    if [ -n "$selection" ]; then
        file=$(echo "$selection" | cut -d: -f1)
        line=$(echo "$selection" | cut -d: -f2)
        
        # Open nvim at the specific line
        nvim +"$line" "$file"
    fi
}

search_by_tag() {
    tput rmcup
    # Step 1: Get the list of unique tags from all notes
    selected_tag=$(rg --no-filename --only-matching '(^|\s)#(\w+)|tags: \[(.*?)\]' "$NOTES_DIRECTORY" \
        | tr -d '[] ,' | sed 's/tags://g' | sort -u | fzf --prompt="Filter by Tag: ")

    # Step 2: If a tag was picked, search for files containing it
    if [ -n "$selected_tag" ]; then
        # Search for either the hash-version (#todo) or the YAML string
        selection=$(rg -l --smart-case "$selected_tag" "$NOTES_DIRECTORY" | fzf \
            --preview "bat --color=always --style=plain {} | grep -C 5 --color=always $selected_tag")

        if [ -n "$selection" ]; then
            nvim "$selection"
        fi
    fi
}

list_all_tags() {
    tput rmcup
    echo "Listing all tags: "
    # 1. Finds #tags and YAML tags
    # 2. Cleans up punctuation/brackets
    # 3. Sorts and finds unique values
    rg --no-filename --only-matching '(^|\s)#(\w+)|tags: \[(.*?)\]' "$NOTES_DIRECTORY" \
        | tr -d '[] ,' | sed 's/tags://g' | sort -u | fzf --prompt="Select a Tag: "
    # Press enter to exit or choose one
}

create_note() {
    tput cnorm # Show cursor so I can see what I'm typing
    echo -n "Enter title: "
    read -r note_title
    
    if [ -n "$note_title" ]; then
        # Convert spaces to dashes
        filename="${note_title// /-}.md"
        nvim "$filename"
    fi
}


main() {
    cd $NOTES_DIRECTORY || exit
    options=("Search by filename" "Search live-grep" "List all tags" "Search by tag" "Create new note" "Quit")

    while true; do
        tput smcup 
        clear
        echo "~ Note Manager ~"
        
        select opt in "${options[@]}"; do
            case $opt in
                "Search by filename")
                    tput rmcup # Temporarily exit TUI mode to let fzf/nvim take over
                    fzf_filename
                    break # Break out of select to redraw the menu
                    ;;
                "Search live-grep")
                    tput rmcup
                    fzf_rgrep
                    break
                    ;;
                "List all tags")
                    list_all_tags
                    break
                    ;;
                "Search by tag")
                    search_by_tag
                    break
                    ;;

                "Create new note")
                    tput rmcup
                    create_note
                    break
                    ;;
                *) 
                    exit 0
                    ;;
            esac
        done
    done
}

# stuff to make the tui-like interface
trap cleanup exit
tput civis  # Makes cursor invisible
main
exit 0
