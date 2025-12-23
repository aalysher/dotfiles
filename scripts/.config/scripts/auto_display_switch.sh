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
    # If the process is not running, remove the stale lock file
    if ! ps -p $(cat "$LOCK_FILE") > /dev/null; then
        rm -f "$LOCK_FILE"
    else
        log_message "Script is already running. Exiting."
        exit 1
    fi
fi

# Create lock file with PID
echo $$ > "$LOCK_FILE"

# --- Configuration ---
INTERNAL_OUTPUT="eDP-1" # Adjust if your internal display name is different
# List of potential external outputs, ordered by preference or commonality
EXTERNAL_OUTPUT_CANDIDATES=("DP-1" "HDMI-1" "HDMI-2" "DP-2")
WALLPAPER="/home/aalysher/dotfiles/backgrounds/A.png" # Path to your wallpaper

# --- Functions ---

# Function to update wallpaper
update_wallpaper() {
    if [ -f "$WALLPAPER" ]; then
        feh --bg-scale "$WALLPAPER" &
        log_message "Wallpaper updated."
    else
        log_message "Wallpaper file not found: $WALLPAPER"
    fi
}

# Function to setup external monitor resolution (reused from dispay.sh)
setup_monitor() {
    local output_name=$1
    local resolutions=$(xrandr | grep -A 20 "$output_name connected" | grep -o "[0-9]*x[0-9]*" | sort -u)

    if echo "$resolutions" | grep -q "2560x1440"; then
        xrandr --output "$output_name" --mode 2560x1440 --rate 143.98
        log_message "Set $output_name to 2560x1440@143.98Hz."
    else
        xrandr --output "$output_name" --auto
        log_message "Set $output_name to auto resolution."
    fi
}

# --- Main Logic ---

log_message "Script started."

# Find connected external monitor
EXTERNAL_OUTPUT=""
for candidate in "${EXTERNAL_OUTPUT_CANDIDATES[@]}"; do
    if xrandr | grep -q "$candidate connected"; then
        EXTERNAL_OUTPUT="$candidate"
        log_message "External monitor detected: $EXTERNAL_OUTPUT"
        break
    fi
done

# Get lid state
LID_STATE=$(cat /proc/acpi/button/lid/LID/state | grep -o 'open\|closed')

log_message "Lid state: $LID_STATE"
log_message "External output detected: $EXTERNAL_OUTPUT"

if [ "$LID_STATE" == "closed" ]; then
    if [ -n "$EXTERNAL_OUTPUT" ]; then
        # Lid closed, external monitor connected: enable external, disable internal
        log_message "Lid closed, external connected: Enabling external, disabling internal."
        setup_monitor "$EXTERNAL_OUTPUT"
        xrandr --output "$EXTERNAL_OUTPUT" --primary --auto
        xrandr --output "$INTERNAL_OUTPUT" --off
    else
        # Lid closed, no external monitor: do nothing (system might suspend)
        log_message "Lid closed, no external connected: Doing nothing (system might suspend)."
        # Optionally, you might want to add a suspend command here, but it's usually handled by logind.
    fi
elif [ "$LID_STATE" == "open" ]; then
    if [ -n "$EXTERNAL_OUTPUT" ]; then
        # Lid open, external monitor connected: dual display
        log_message "Lid open, external connected: Setting up dual display."
        xrandr --output "$INTERNAL_OUTPUT" --off
        setup_monitor "$EXTERNAL_OUTPUT"
        xrandr --output "$EXTERNAL_OUTPUT" --right-of "$INTERNAL_OUTPUT" --primary
    else
        # Lid open, no external monitor: enable internal, disable external
        log_message "Lid open, no external connected: Enabling internal, disabling external."
        xrandr --output "$INTERNAL_OUTPUT" --auto --primary
        # Turn off all other connected outputs that are not the internal one
        xrandr | grep " connected" | awk '{print $1}' | grep -v "$INTERNAL_OUTPUT" | while read -r output; do
            xrandr --output "$output" --off
        done
    fi
fi

update_wallpaper

# Remove lock file
rm -f "$LOCK_FILE"
log_message "Script finished."