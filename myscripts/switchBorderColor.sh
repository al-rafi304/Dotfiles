#!/bin/bash

# Path to your Hyprland config file
config_file="$HOME/.config/hypr/hyprland.conf"

# Check if the active_border is commented or not
if grep -q "^#\s*col.active_border = rgba(33ccffee)" "$config_file"; then
    # Uncomment the commented part and comment the uncommented part
    sed -i 's/^\s*#\s*\(col\.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg\)/\1/' "$config_file"
    sed -i 's/^\s*#\s*\(col\.inactive_border = rgba(595959aa)\)/\1/' "$config_file"
    sed -i 's/^\s*\(col\.active_border = rgba(BF4040ee)\)/#\1/' "$config_file"
    sed -i 's/^\s*\(col\.inactive_border = rgba(BF4040aa)\)/#\1/' "$config_file"
else
    # Comment the uncommented part and uncomment the commented part
    sed -i 's/^\s*\(col\.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg\)/#\1/' "$config_file"
    sed -i 's/^\s*\(col\.inactive_border = rgba(595959aa)\)/#\1/' "$config_file"
    sed -i 's/^\s*#\s*\(col\.active_border = rgba(BF4040ee)\)/\1/' "$config_file"
    sed -i 's/^\s*#\s*\(col\.inactive_border = rgba(BF4040aa)\)/\1/' "$config_file"
fi