#!/usr/bin/env bash

SESSION_NAME="general"

tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? != 0 ]; then
    tmux new-session -d -s $SESSION_NAME
    #tmux send-keys -t $SESSION_NAME "clear" C-m
fi

# Attach to the session
tmux attach-session -t $SESSION_NAME
