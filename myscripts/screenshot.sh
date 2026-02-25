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

    ACTION=$(notify-send \
        --action="open=Open Location" \
        -i "$file" \
        "Screenshot saved!" \
        "Click to open file location")

    case "$ACTION" in
    "open")
        thunar "$file"
        ;;
    esac
}

notify_capture () {
    local preview_file="$1"

    ACTION=$(notify-send \
        --action="save=Save" \
        --action="edit=Edit" \
        -i "$preview_file" \
        "Screenshot captured" \
        "What would you like to do?")

    case "$ACTION" in
    "save")
        save_screenshot "$preview_file"
        ;;
    "edit")
        wl-paste | ksnip -
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
