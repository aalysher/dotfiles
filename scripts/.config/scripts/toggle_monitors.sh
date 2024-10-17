#!/bin/bash

INTERNAL_OUTPUT="eDP-1"
EXTERNAL_OUTPUTS=("HDMI-1" "HDMI-2", "DP-1", "DP-2")

# Функция для проверки подключенных внешних мониторов
check_external_connected() {
    for output in "${EXTERNAL_OUTPUTS[@]}"; do
        if xrandr | grep "$output connected"; then
            return 0
        fi
    done
    return 1
}

# Проверяем, подключены ли внешние мониторы
if check_external_connected; then
    xrandr --output $INTERNAL_OUTPUT --off --output "${EXTERNAL_OUTPUTS[0]}" --auto --primary
else
    xrandr --output $INTERNAL_OUTPUT --auto --primary --output "${EXTERNAL_OUTPUTS[0]}" --off
fi

