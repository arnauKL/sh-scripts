#!/usr/bin/env bash

option=$(ls -1 /usr/bin/ | fzf --tac --layout=reverse --prompt="run: " --no-info)

case $option in 
    other)
        read -p "Type command: " option
        ;;
    "")
        exit 1
        ;;
esac

exec $option
