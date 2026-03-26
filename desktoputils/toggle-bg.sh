#!/usr/bin/env bash

(pkill swaybg) || (swaybg -i "$(cat /var/tmp/selected-bg 2>/dev/null)" -m fill 2>/dev/null & )
