#!/bin/bash
# Скрипт для добавления информации о раскладке в i3status

# Путь к конфигурационному файлу i3status
I3STATUS_CONFIG="$HOME/.config/i3/i3status/i3status.conf"

i3status --config $I3STATUS_CONFIG | while :
do
    read line
    LAYOUTS=$(setxkbmap -query | awk '/layout/{print $2}')
    LED_STATUS=$(xset -q | awk '/LED mask/{print $10}')
    if [ "$LED_STATUS" = "00000000" ]; then
        LG=$(echo "$LAYOUTS" | cut -d ',' -f 1)
    else
        LG=$(echo "$LAYOUTS" | cut -d ',' -f 2)
    fi
    echo "⌨️ $LG | $line" || exit 1
done
