#!/bin/bash

# Lock file to prevent multiple instances
LOCK_FILE="/tmp/auto_display_switch.lock"
LOG_FILE="/tmp/auto_display_switch.log"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

if [ -e "$LOCK_FILE" ]; then
    # Check if the process holding the lock is still running
    if ! ps -p $(cat "$LOCK_FILE") > /dev/null 2>&1; then
        rm -f "$LOCK_FILE"
    else
        log_message "Script is already running. Exiting."
        exit 1
    fi
fi

# Create lock file with PID
echo $$ > "$LOCK_FILE"

# --- Configuration ---
INTERNAL_OUTPUT="eDP-1" # Internal display name
EXTERNAL_OUTPUT_CANDIDATES=("DP-1" "HDMI-1" "HDMI-2" "DP-2")
WALLPAPER="/home/ninja/dotfiles/backgrounds/A.png"

# --- Functions ---

update_wallpaper() {
    if [ -f "$WALLPAPER" ]; then
        feh --bg-scale "$WALLPAPER" &
        log_message "Wallpaper updated."
    else
        log_message "Wallpaper file not found: $WALLPAPER"
    fi
}

apply_external_display() {
    local output_name="$1"
    local resolutions=$(xrandr | grep -A 20 "$output_name connected" | grep -o "[0-9]*x[0-9]*" | sort -u)

    if echo "$resolutions" | grep -q "2560x1440"; then
        xrandr --output "$INTERNAL_OUTPUT" --off --output "$output_name" --mode 2560x1440 --rate 143.98 --primary
        log_message "Set $output_name to 2560x1440@143.98Hz (atomic)."
    else
        xrandr --output "$INTERNAL_OUTPUT" --off --output "$output_name" --auto --primary
        log_message "Set $output_name to auto resolution (atomic)."
    fi
}

apply_internal_display() {
    local off_args=()
    for candidate in "${EXTERNAL_OUTPUT_CANDIDATES[@]}"; do
        off_args+=(--output "$candidate" --off)
    done
    xrandr --output "$INTERNAL_OUTPUT" --auto --primary "${off_args[@]}"
    log_message "Set $INTERNAL_OUTPUT to auto/primary and turned off externals (atomic)."
}

# --- Main Logic ---

log_message "Script started."

# Find connected external monitor (check sysfs first, fallback to xrandr)
EXTERNAL_OUTPUT=""
for candidate in "${EXTERNAL_OUTPUT_CANDIDATES[@]}"; do
    is_connected=0
    for s in /sys/class/drm/card*-${candidate}/status /sys/class/drm/card*-HDMI-A-${candidate#HDMI-}/status; do
        if [ -f "$s" ] && [ "$(cat "$s" 2>/dev/null)" == "connected" ]; then
            is_connected=1
            break
        fi
    done

    if [ $is_connected -eq 1 ] || xrandr | grep -q "$candidate connected [0-9]"; then
        EXTERNAL_OUTPUT="$candidate"
        log_message "External monitor detected: $EXTERNAL_OUTPUT"
        break
    fi
done

# Get lid state
LID_STATE="open"
if [ -f /proc/acpi/button/lid/LID/state ]; then
    LID_STATE=$(cat /proc/acpi/button/lid/LID/state | grep -o 'open\|closed')
fi

log_message "Lid state: $LID_STATE"
log_message "External output detected: $EXTERNAL_OUTPUT"

if [ "$LID_STATE" == "closed" ]; then
    if [ -n "$EXTERNAL_OUTPUT" ]; then
        log_message "Lid closed, external connected: Enabling external, disabling internal."
        apply_external_display "$EXTERNAL_OUTPUT"
    else
        log_message "Lid closed, no external connected: Doing nothing (system might suspend)."
    fi
else
    # Lid open
    if [ -n "$EXTERNAL_OUTPUT" ]; then
        log_message "Lid open, external connected: Setting up external display."
        apply_external_display "$EXTERNAL_OUTPUT"
    else
        log_message "Lid open, no external connected: Enabling internal, disabling external."
        apply_internal_display
    fi
fi

update_wallpaper

# Remove lock file
rm -f "$LOCK_FILE"
log_message "Script finished."
