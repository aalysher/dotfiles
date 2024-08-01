#!/bin/bash

# Уникальный идентификатор уведомления
NOTIFICATION_ID=9998

# Изменение громкости с помощью amixer
amixer sset Master "$1"

# Получение текущего уровня громкости
volume=$(amixer get Master | grep -oP '\[\d+%\]' | head -1 | tr -d '[]')

# Проверка статуса отключения звука
mute=$(amixer get Master | grep -oP '\[on\]|\[off\]' | head -1)

# Отправка уведомления с помощью notify-send
if [ "$mute" = "[off]" ]; then
    notify-send -u low -t 2000 -r $NOTIFICATION_ID "Volume: Muted"
else
    notify-send -u low -t 2000 -r $NOTIFICATION_ID "Volume: $volume"
fi

