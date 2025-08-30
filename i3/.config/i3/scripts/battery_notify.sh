#!/bin/bash

STATE_FILE="/tmp/battery_notification_state"
NOTIFICATION_INTERVAL=120

battery_info=$(acpi -b)

battery_level=$(echo "$battery_info" | grep -oP '[0-9]+(?=%)' | sort -nr | head -n 1)
battery_status=$(echo "$battery_info" | grep -oP 'Charging|Discharging' | head -n 1)

if [[ -z "$battery_level" || -z "$battery_status" ]]; then
    exit 1
fi

should_send_notification() {
    local current_time=$(date +%s)
    local current_state="$battery_status:$battery_level"

    if [[ -f "$STATE_FILE" ]]; then
        local last_notification_time=$(head -n 1 "$STATE_FILE" 2>/dev/null)
        local last_state=$(tail -n 1 "$STATE_FILE" 2>/dev/null)

        if [[ "$last_state" == "$current_state" && \
              $((current_time - last_notification_time)) -lt $NOTIFICATION_INTERVAL ]]; then
            return 1
        fi
    fi

    echo "$current_time" > "$STATE_FILE"
    echo "$current_state" >> "$STATE_FILE"
    return 0
}

if [[ "$battery_status" == "Discharging" ]]; then
    if [[ $battery_level -le 20 ]]; then
        if should_send_notification; then
            notify-send "⚠️ Battery Low" "Battery level: $battery_level%" -u critical --expire-time 10000
        fi
    fi
fi
