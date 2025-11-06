# grim -g "$(slurp)" -c $HOME/Pictures/Screenshots/$(date +'%s(%m-%d-%y).png') && notify
# FILE=$HOME/Pictures/Screenshots

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/myscripts"
PREVIEW_FILE="$CACHE_DIR/screenshot-preview.png"
mkdir -p "$CACHE_DIR"

save_screenshot () {
    local source_file="$1"
    file="$HOME/Pictures/Screenshots/$(date +'%s(%m-%d-%y).png')"

    if [[ -n "$source_file" && -f "$source_file" ]]; then
        cp "$source_file" "$file"
    else
        wl-paste > "$file"
    fi

    ACTION=$(dunstify --action="default,Reply" -I "$file" -i folder-open "Screenshot saved!" "Click to open file location")
    case "$ACTION" in
    "2")
        thunar "$file"
        ;;
    esac
}

notify_capture () {
    local preview_file="$1"

    ACTION=$(dunstify \
        --action="edit,Edit in Ksnip" \
        -I "$preview_file" \
        -i paste \
        "Screenshot copied to clipboard" \
        "Left click to save, middle click to edit")

    case "$ACTION" in
    ""|"close"|"dismissed"|"timeout")
        # closed or timed out without action
        ;;
    "edit")
        wl-paste | ksnip -
        ;;
    "default"|"2")
        save_screenshot "$preview_file"
        ;;
    esac
}

if [[ "$1" == "--now" ]]; then
    if grim - | tee "$PREVIEW_FILE" | wl-copy; then
        save_screenshot "$PREVIEW_FILE"
    fi
else
    selection=$(slurp)

    if [[ -z "$selection" ]]; then
        exit 1
    fi

    if grim -g "$selection" - | tee "$PREVIEW_FILE" | wl-copy; then
        notify_capture "$PREVIEW_FILE"
    fi
fi
