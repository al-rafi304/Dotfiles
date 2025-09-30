#!/bin/bash

# Define your sinks by name
HEADPHONE="alsa_output.usb-GeneralPlus_USB_Audio_Device-00.analog-stereo"
SPEAKER="alsa_output.pci-0000_00_1f.3.analog-stereo"

# Get current default sink
CURRENT=$(pactl get-default-sink)

if [ "$CURRENT" = "$HEADPHONE" ]; then
    pactl set-default-sink "$SPEAKER"
else
    pactl set-default-sink "$HEADPHONE"
fi