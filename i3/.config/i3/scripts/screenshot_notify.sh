#!/bin/bash

# Директория для сохранения скриншотов
screenshot_dir=~/Pictures/Screenshots
mkdir -p "$screenshot_dir"

# Имя файла для скриншота
filename="$screenshot_dir/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

# Проверка на параметр -s
if [ "$1" == "-s" ]; then
    # Делать скриншот выделенной области
    scrot -s "$filename"
else
    # Делать скриншот всего экрана
    scrot "$filename"
fi

# Проверка на успешное создание скриншота
if [ -f "$filename" ]; then
    # Отправка уведомления с предпросмотром скриншота
    notify-send -i "$filename" "Screenshot taken" ""
else
    # Если скриншот не был создан, отправляем уведомление об ошибке
    notify-send -u critical "Screenshot Error" "Failed to capture screenshot."
fi

