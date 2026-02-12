#!/usr/bin/env bash

# Study Tracker - Main Script
# Usage: study-tracker.sh [start|stop|status|toggle|cleanup|stats]

STUDY_DIR="$HOME/Personal/trackings/study-tracker"
SESSIONS_FILE="$STUDY_DIR/sessions.csv"
CURRENT_SESSION_FILE="$STUDY_DIR/current_session"
DAILY_TOTALS_FILE="$STUDY_DIR/daily_totals.csv"

# Create directory if it doesn't exist
mkdir -p "$STUDY_DIR"

# Initialize CSV files with headers if they don't exist
if [[ ! -f "$SESSIONS_FILE" ]]; then
    echo "start_time,end_time,duration_minutes,date" > "$SESSIONS_FILE"
fi

if [[ ! -f "$DAILY_TOTALS_FILE" ]]; then
    echo "date,total_minutes,session_count" > "$DAILY_TOTALS_FILE"
fi

format_time() { date -d "@$1" "+%Y-%m-%d %H:%M:%S" }
current_timestamp() { date +%s }

# Function to start a study session
start_session() {
    if [[ -f "$CURRENT_SESSION_FILE" ]]; then
        echo "Study session already active!"
        echo "Started at: $(format_time $(cat "$CURRENT_SESSION_FILE"))"
        return 1
    fi
    
    local start_time=$(current_timestamp)
    echo "$start_time" > "$CURRENT_SESSION_FILE"
    echo "Study session started at $(format_time $start_time)"
    
    notify-send "Study Tracker" "Study session started"
}

# Function to stop a study session
stop_session() {
    if [[ ! -f "$CURRENT_SESSION_FILE" ]]; then
        echo "No active study session found!"
        return 1
    fi
    
    local start_time=$(cat "$CURRENT_SESSION_FILE")
    local end_time=$(current_timestamp)
    local duration=$((($end_time - $start_time) / 60))  # Duration in minutes
    local date=$(date -d "@$start_time" "+%Y-%m-%d")
    
    # Add to sessions file
    echo "$(format_time $start_time),$(format_time $end_time),$duration,$date" >> "$SESSIONS_FILE"
    
    # Remove current session file
    rm "$CURRENT_SESSION_FILE"
    
    echo "Study session completed!"
    echo "Duration: ${duration} minutes ($(($duration / 60))h $(($duration % 60))m)"
    
    # Update daily totals
    update_daily_totals "$date"
    
    notify-send "Study Tracker" "Session completed! ${duration} minutes"
}

# Function to get session status
get_status() {
    if [[ -f "$CURRENT_SESSION_FILE" ]]; then
        local start_time=$(cat "$CURRENT_SESSION_FILE")
        local current_time=$(current_timestamp)
        local elapsed=$(((current_time - start_time) / 60))
        
        echo "ACTIVE"
        echo "Started: $(format_time $start_time)"
        echo "Elapsed: ${elapsed} minutes ($(($elapsed / 60))h $(($elapsed % 60))m)"
        return 0
    else
        echo "INACTIVE"
        return 1
    fi
}

# Function for waybar output
waybar_output() {
    if [[ -f "$CURRENT_SESSION_FILE" ]]; then
        local start_time=$(cat "$CURRENT_SESSION_FILE")
        local current_time=$(current_timestamp)
        local elapsed=$(((current_time - start_time) / 60))
        
        # JSON output for waybar
        echo "{\"text\": \"${elapsed}m\", \"tooltip\": \"Study session active: ${elapsed} minutes\", \"class\": \"active\"}"
    else
        echo "{\"text\": \"Start\", \"tooltip\": \"Click to start study session\", \"class\": \"inactive\"}"
    fi
}

# Function to toggle session (start if stopped, stop if started)
toggle_session() {
    if [[ -f "$CURRENT_SESSION_FILE" ]]; then
        stop_session
    else
        start_session
    fi
}

# Function to update daily totals
update_daily_totals() {
    local date="$1"
    local temp_file=$(mktemp)
    local found=false
    
    # Read existing totals and update if date exists
    while IFS=',' read -r d total_min count; do
        if [[ "$d" == "date" ]]; then
            echo "$d,$total_min,$count" >> "$temp_file"
        elif [[ "$d" == "$date" ]]; then
            local sessions_today=$(grep ",$date$" "$SESSIONS_FILE" | wc -l)
            local total_today=$(grep ",$date$" "$SESSIONS_FILE" | cut -d',' -f3 | awk '{sum+=$1} END {print sum+0}')
            echo "$date,$total_today,$sessions_today" >> "$temp_file"
            found=true
        else
            echo "$d,$total_min,$count" >> "$temp_file"
        fi
    done < "$DAILY_TOTALS_FILE"
    
    # Add new date if not found
    if [[ "$found" == "false" ]]; then
        local sessions_today=$(grep ",$date$" "$SESSIONS_FILE" | wc -l)
        local total_today=$(grep ",$date$" "$SESSIONS_FILE" | cut -d',' -f3 | awk '{sum+=$1} END {print sum+0}')
        echo "$date,$total_today,$sessions_today" >> "$temp_file"
    fi
    
    mv "$temp_file" "$DAILY_TOTALS_FILE"
}

# Function to cleanup orphaned sessions
cleanup_orphaned() {
    if [[ -f "$CURRENT_SESSION_FILE" ]]; then
        local start_time=$(cat "$CURRENT_SESSION_FILE")
        read -p "This session was likely interrupted by shutdown. Keep it? (y/N): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Session preserved. Use 'study-tracker.sh stop' when ready."
        else
            rm "$CURRENT_SESSION_FILE"
            echo "Orphaned session discarded."
        fi
    else
        echo "No orphaned sessions found."
    fi
}

# Function to show statistics
show_stats() {
    echo "Study Tracker Statistics"
    echo
    
    # Total sessions and time
    local total_sessions=$(( $(wc -l < "$SESSIONS_FILE") - 1 ))
    local total_minutes=$(tail -n +2 "$SESSIONS_FILE" | cut -d',' -f3 | awk '{sum+=$1} END {print sum+0}')
    local total_hours=$((total_minutes / 60))
    local remaining_minutes=$((total_minutes % 60))
    
    echo "Overall Stats:"
    echo "   Total sessions: $total_sessions"
    echo "   Total time: ${total_hours}h ${remaining_minutes}m"
    echo
    
    # Today's stats
    local today=$(date "+%Y-%m-%d")
    local today_sessions=$(grep ",$today$" "$SESSIONS_FILE" | wc -l)
    local today_minutes=$(grep ",$today$" "$SESSIONS_FILE" | cut -d',' -f3 | awk '{sum+=$1} END {print sum+0}')
    local today_hours=$((today_minutes / 60))
    local today_remaining=$((today_minutes % 60))
    
    echo "Today ($today):"
    echo "   Sessions: $today_sessions"
    echo "   Time: ${today_hours}h ${today_remaining}m"
    echo
    
    # Recent sessions (last 5)
    echo "Recent Sessions:"
    tail -n 5 "$SESSIONS_FILE" | tail -n +2 | while IFS=',' read -r start end duration date; do
        echo "   $date: ${duration}m ($start)"
    done
}

# Main script magic
case "${1:-status}" in
    start)
        start_session
        ;;
    stop)
        stop_session
        ;;
    status)
        get_status
        ;;
    toggle)
        toggle_session
        ;;
    waybar)
        waybar_output
        ;;
    cleanup)
        cleanup_orphaned
        ;;
    stats)
        show_stats
        ;;
    *)
        echo "Usage: $0 [start|stop|status|toggle|waybar|cleanup|stats]"
        echo
        echo "Commands:"
        echo "  start   - Start a new study session"
        echo "  stop    - Stop the current session"
        echo "  status  - Show current session status"
        echo "  toggle  - Start session if stopped, stop if started"
        echo "  waybar  - Output JSON for waybar integration"
        echo "  cleanup - Handle orphaned sessions from unexpected shutdowns"
        echo "  stats   - Show study statistics"
        ;;
esac
