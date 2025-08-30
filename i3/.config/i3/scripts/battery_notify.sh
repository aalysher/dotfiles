#!/bin/bash

# File for storing previous state
STATE_FILE="/tmp/battery_notification_state"
# Time interval between notifications (in seconds)
NOTIFICATION_INTERVAL=300  # 5 minutes

# Get battery information
battery_info=$(acpi -b)

# Find maximum battery level among all batteries
battery_level=$(echo "$battery_info" | grep -oP '[0-9]+(?=%)' | sort -nr | head -n 1)
battery_status=$(echo "$battery_info" | grep -oP 'Charging|Discharging' | head -n 1)

# Check for empty or invalid values
if [[ -z "$battery_level" || -z "$battery_status" ]]; then
    exit 1
fi

# Function to check if notification should be sent
should_send_notification() {
    local current_time=$(date +%s)
    local current_state="$battery_status:$battery_level"

    # If state file exists, check last notification time
    if [[ -f "$STATE_FILE" ]]; then
        local last_notification_time=$(head -n 1 "$STATE_FILE" 2>/dev/null)
        local last_state=$(tail -n 1 "$STATE_FILE" 2>/dev/null)

        # If state hasn't changed and not enough time has passed, don't send notification
        if [[ "$last_state" == "$current_state" && \
              $((current_time - last_notification_time)) -lt $NOTIFICATION_INTERVAL ]]; then
            return 1
        fi
    fi

    # Update state file with current time and state
    echo "$current_time" > "$STATE_FILE"
    echo "$current_state" >> "$STATE_FILE"
    return 0
}

# Notifications for low battery (only when discharging)
if [[ "$battery_status" == "Discharging" ]]; then
    if [[ $battery_level -le 20 ]]; then
        if should_send_notification; then
            notify-send "⚠️ Battery Low" "Battery level: $battery_level%" \
                -u critical --expire-time 10000  # Auto-hide after 10 seconds
        fi
    elif [[ $battery_level -eq 0 ]]; then
        if should_send_notification; then
            notify-send "❌ Battery Reading Error" "acpi shows 0%, but this might be an error." \
                -u normal --expire-time 8000
        fi
    fi
# Notification when charging with low battery level
elif [[ "$battery_status" == "Charging" && $battery_level -le 20 ]]; then
    # Check if status changed from Discharging to Charging
    if [[ -f "$STATE_FILE" ]]; then
        local last_state=$(tail -n 1 "$STATE_FILE")
        if [[ "$last_state" == *":Discharging" ]]; then
            if should_send_notification; then
                notify-send "🔌 Charger Connected" "Current battery level: $battery_level%" \
                    -u normal --expire-time 8000
            fi
        fi
    fi
fi

