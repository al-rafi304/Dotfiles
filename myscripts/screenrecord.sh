#!/bin/bash

save_screenshot () {
    # file="$HOME/Pictures/Screenshots/$(date +'%s(%m-%d-%y).png')"
    # wl-paste > $file

    ACTION=$(dunstify --action="default,Reply" -i folder-open "Screen Recording Saved!" "Click to open file location")
    case "$ACTION" in
    "2")
        thunar $(cat /tmp/recording.txt)
        ;;
    esac
}

file="$HOME/Videos/Recordings/$(date +'%s(%m-%d-%y).mp4')"

# Finish recording if already running
if pgrep -x "wf-recorder" > /dev/null;then
	echo "Ending Recording"
	pkill -INT -x wf-recorder && save_screenshot

# Start recording
else
	echo "Starting Recording"
	echo "$file" > /tmp/recording.txt
	dunstify "Recording started"
	wf-recorder -f "$file" &>/dev/null
fi
