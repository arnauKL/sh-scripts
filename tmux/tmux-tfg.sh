#!usr/bin/env bash

SESSION_NAME="tfg_memoria"
TARGET_DIR="$HOME/Uni/4t/TFG/writing/"

# Check if the session already exists
# This prevents errors if you run the script while the session is already live.
tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? != 0 ]; then
    # Create the session and the first window
    # -d: "Detached" (don't jump into it yet, let us finish setting it up)
    # -s: Name of the session
    # -n: Name of the first window
    # -c: The "Start In" directory
    tmux new-session -d -s $SESSION_NAME -n "Writing" -c "$TARGET_DIR"

    # Open Neovim in the first pane
    # The ':' separates session name from window name/index.
    # $SESSION_NAME:Writing = "In session 'tfg_work', look at window 'Writing'"
    tmux send-keys -t $SESSION_NAME:Writing "nvim report.typ" C-m

    # Split the window to create the Typst watcher
    # split-window: Cuts the current window into two panes
    # -v: Vertical split (one pane on top of the other)
    # -p 20: Give the NEW pane 20% of the space
    # -f: "Full" (optional, but ensures it spans the whole width)
    # -b: "Before" (puts the new 20% pane at the TOP instead of the bottom)
    tmux split-window -v -p 20 -b -t $SESSION_NAME:Writing -c "$TARGET_DIR"

    # Run the watch command in the new top pane
    # '1.0' refers to Window 1, Pane 0 (the first pane in the window)
    tmux send-keys -t $SESSION_NAME:Writing.0 "typst watch report.typ" C-m

    # Create a second window for "Misc/Terminal"
    # -t: Target session
    # -n: Name of this specific window
    tmux new-window -t $SESSION_NAME -n "Resources" -c "$TARGET_DIR"
    
    # Focus back on the Writing window before attaching
    tmux select-window -t $SESSION_NAME:Writing
fi

# Finally, attach to the session
tmux attach-session -t $SESSION_NAME
