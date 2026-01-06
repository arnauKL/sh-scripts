#!/usr/bin/env bash

TOTP=$(keepassxc-cli show --totp ~/Documents/Passwords.kdbx UdG)

echo "$TOTP"

wl-copy $TOTP && notify-send "TOTP $TOTP copied to clipboard!"
