#!/usr/bin/env bash

read -p "Run: " cmd

setsid -f sh -c "$cmd" > /dev/null 2>&1 &
sleep 0.01
