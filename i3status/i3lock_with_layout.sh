#!/bin/bash

layout=$(setxkbmap -query | grep layout | awk '{print $2}')

# Сохраняем текущую раскладку
current_layout=$layout

# Устанавливаем раскладку для i3lock
setxkbmap -layout us

# Блокируем экран
i3lock -c 000000

# Восстанавливаем раскладку после разблокировки
setxkbmap -layout $current_layout

