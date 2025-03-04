#!/bin/bash
# Скрипт для добавления информации о раскладке в i3status

# Путь к конфигурационному файлу i3status
I3STATUS_CONFIG="$HOME/.config/i3/i3status.conf"

i3status --config $I3STATUS_CONFIG | while :
do
    read line
    LG=$(setxkbmap -query | awk '/layout/{print $2}')
    echo "⌨️ $LG | $line" || exit 1
done
