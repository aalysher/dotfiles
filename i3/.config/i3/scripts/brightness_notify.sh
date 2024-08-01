#!/bin/bash

# Уникальный идентификатор уведомления
NOTIFICATION_ID=9999

# Изменение яркости с помощью brightnessctl
brightnessctl set "$1"

# Получение текущего уровня яркости
brightness=$(brightnessctl g)
max_brightness=$(brightnessctl m)
percent=$(( 100 * brightness / max_brightness ))

# Отправка уведомления с помощью notify-send
notify-send -u low -t 2000 -r $NOTIFICATION_ID "Brightness: $percent%"

