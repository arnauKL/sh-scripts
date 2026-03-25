#!/usr/bin/env bash

SESSION_NAME="journal"

# This prevents errors if you run the script while the session is already live.
tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? != 0 ]; then
    # Create the session and the first window
    # -d: "Detached" (don't jump into it yet, let us finish setting it up)
    # -s: Name of the session
    # -n: Name of the first window
    # -c: The "Start In" directory
    tmux new-session -d -s $SESSION_NAME -n "writing" -c "$JOURNAL_DIR"

    # Open Neovim
    # The ':' separates session name from window name/index.
    # $SESSION_NAME:Writing = "In session 'tfg_work', look at window 'Writing'"
    tmux send-keys -t $SESSION_NAME:writing "journal" C-m

    # journal is a custom command, if I don't have it in my bashrc it's this:
    # journal() {
    #     local journal_dir=$HOME/vaults/Journals/2026
    #     local filename="$(date +%F).md"
    #     mkdir -p "$journal_dir"
    #     nvim "$journal_dir/$filename"
    # }
fi

# Attach to the session
tmux attach-session -t $SESSION_NAME
