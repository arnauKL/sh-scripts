#!/usr/bin/env bash


date_long=$(date +"%b %d (W%U)")
date_short=$(date +"%Y%m%d")

schedule_file="$HOME/Notes/schedule.md"

echo 'set up time blocks for the day'
echo 'Today:' $date_long


if [ -n $schedule_file ]; then
    echo 'file does not exist'
    create_schedule()
    touch
fi

