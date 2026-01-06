#!/usr/bin/env bash 

# Default durations (can be overridden by command-line arguments)
FOCUS_DURATION=${1:-25}
BREAK_DURATION=${2:-5}
ROUNDS=${3:-4}

cleanup () {
# Returns the terminal to how it was before the script was ran
    tput rmcup
    tput cnorm  # Makes cursor visible again
}

# Countdown timer function
countdown() {
    local minutes=$1
    local seconds=$((minutes * 60))

    while [ $seconds -gt 0 ]; do
        mins=$((seconds / 60))
        secs=$((seconds % 60))
        printf "\r%02d:%02d remaining..." "$mins" "$secs"
        sleep 1 # I should get sth more accurate
        ((seconds--))
    done
    clear
    echo ""
}

# Start Pomodoro session
start_pomodoro() {
    for ((i = 1; i <= ROUNDS; i++)); do
        echo "Pomodoro $i: Focus for $FOCUS_DURATION minutes"
        notify-send "Pomodoro $i" "Focus for $FOCUS_DURATION minutes"
        countdown $FOCUS_DURATION

        echo "Break time! Take $BREAK_DURATION minutes."
        notify-send "Break Time" "Take $BREAK_DURATION minutes off"
        countdown $BREAK_DURATION
    done

    notify-send "Pomodoro Complete" "You've completed $ROUNDS Pomodoros!"
}

# Clear screen
# Run
trap cleanup exit
tput smcup
tput civis  # Makes cursor invisible
clear       # Clears screen
start_pomodoro
done
