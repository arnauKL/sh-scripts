#!/bin/sh

DATABASE="$HOME/Documents/Passwords.kdbx"

keepassxc-cli ls $DATABASE | dmenu

