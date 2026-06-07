#!/usr/bin/env bash

PKG_LEDGER='/home/ak/.local/share/pkg_reasons.txt'

pkg-add() {
    local pkg=$1
    local reason=$2

    # Check if package name was provided
    if [ -z "$pkg" ]; then
        echo "Usage: pkg-add <package_name>"
        return 1
    fi

    if [ -z "$reason" ]; then
        # Ask for the reason before installing if not given via cli
        echo -n "Reason for installing $pkg: "
        read -r reason
    fi

    # Install the package
    if xbps-query -m | grep "$pkg"; then
        local date=$(date '+%Y-%m-%d %H:%M')
        echo "$date | $pkg | $reason" >> ~/.local/share/pkg_reasons.txt
        echo "Logged: $pkg ($reason)"
    elif doas xbps-install -S "$pkg"; then
        # If successful, log it with a timestamp
        local date=$(date '+%Y-%m-%d %H:%M')
        echo "$date | $pkg | $reason" >> ~/.local/share/pkg_reasons.txt
        echo "Logged: $pkg ($reason)"
    fi
}

pkg-why() {
    if [ -z "$1" ]; then
        # List everything in a nice table
        column -t -s '|' ~/.local/share/pkg_reasons.txt
    else
        # Search for a specific package
        grep -i "$1" ~/.local/share/pkg_reasons.txt | column -t -s '|'
    fi
}

pkg-audit() {
    # Ensure files exist to avoid grep errors
    touch "$PKG_LEDGER"

    echo "Packages missing a reason:"
    local missing_count=0

    for full_pkg in $(xbps-query -m); do
        
        # Clean the name: "firefox-149.0.2_1" becomes "firefox"
        local clean_name=$(xbps-uhelper getpkgname "$full_pkg")

        # Check the Ledger (using the cleaned name)
        if grep -q "| $clean_name |" "$PKG_LEDGER"; then
            continue
        fi

        echo "  [?] $full_pkg"
        missing_count=$((missing_count + 1))
    done
    echo "Total undocumented: $missing_count"
}
