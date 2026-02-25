#!/usr/bin/env bash

# --- Configuration ---
DB_PATH="$HOME/Documents/Passwords.kdbx" # Update this to your DB path
CACHE_TIMEOUT=5 # How many seconds to keep the password in clipboard

MASTER_PW=$(echo "" | wmenu -P -p "Master Password:" )

# Get list of entries
ENTRIES=$(keepassxc-cli ls -R "$DB_PATH" <<< "$MASTER_PW" 2>/dev/null)

# Check
if [ -z "$ENTRIES" ]; then
    notify-send "KeePassXC" "Access denied or Database empty."
    exit 1
fi

# Select entry via dmenu
SELECTION=$(echo "$ENTRIES" | wmenu -i -p "Select Entry:")

# Copy to clipboard
if [ -n "$SELECTION" ]; then
    keepassxc-cli show -a password "$DB_PATH" "$SELECTION" <<< "$MASTER_PW" | wl-copy
    notify-send "Password for '$SELECTION' copied. Clears in ${CACHE_TIMEOUT}s."
    
    # Clear clipboard after timeout
    sleep "$CACHE_TIMEOUT"
    echo "" | wl-copy
fi
