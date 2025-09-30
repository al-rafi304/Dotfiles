#!/bin/bash
# changeVolume

# Arbitrary but unique message tag
msgTag="volume"

# Change the volume using alsa(might differ if you use pulseaudio)


# Query amixer for the current volume and whether or not the speaker is muted

increase_volume() {
    pactl set-sink-volume @DEFAULT_SINK@ +1% && notify
}

decrease_volume() {
    pactl set-sink-volume @DEFAULT_SINK@ -1% && notify
}

toggle_mute() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle && notify
}

get_volume() {
    echo "$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n 1)"
}

get_mute() {
    echo "$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')"
}

# get_icon() {
#     if [[ "$(get_volume)" == "0%" ]];then
# }


notify() {
    if [[ "$(get_volume)" == "0%" || "$(get_mute)" == "yes" ]]; then
        # Show the sound muted notification
        dunstify -a "changeVolume" -i audio-volume-muted -h string:x-dunst-stack-tag:$msgTag "Volume muted" 
    else
        # Show the volume notification
        dunstify -a "changeVolume" -i audio-volume-medium -h string:x-dunst-stack-tag:$msgTag \
        "Volume: $(get_volume)"
    fi
}

if [[ "$1" == "--inc" ]]; then
    increase_volume
elif [[ "$1" == "--dec" ]]; then
    decrease_volume
elif [[ "$1" == "--toggle" ]]; then
    toggle_mute
else
    echo $volume
fi