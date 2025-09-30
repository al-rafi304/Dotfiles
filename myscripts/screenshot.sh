# grim -g "$(slurp)" -c $HOME/Pictures/Screenshots/$(date +'%s(%m-%d-%y).png') && notify
# FILE=$HOME/Pictures/Screenshots

save_screenshot () {
    file="$HOME/Pictures/Screenshots/$(date +'%s(%m-%d-%y).png')"
    wl-paste > $file

    ACTION=$(dunstify --action="default,Reply" -i folder-open "Screenshot saved!" "Click to open file location")
    case "$ACTION" in
    "2")
        thunar $file
        ;;
    esac
}

notify_capture () {
    ACTION=$(dunstify --action="default,Reply" -i paste "Screenshot copied to clipboard" "Click to save")
    # ACTION=$(dunstify \
    #     --action="default,Save" \
    #     --action="ksnip,Edit" \
    #     -i paste "Screenshot copied to clipboard" "Choose an action")

    case "$ACTION" in
    "2")
        save_screenshot
        ;;
    "1")
        wl-paste | ksnip -
        ;;
    esac
}

if [[ "$1" == "--now" ]]; then
    grim - | wl-copy && save_screenshot
else
    grim -g "$(slurp)" - | wl-copy && notify_capture
fi