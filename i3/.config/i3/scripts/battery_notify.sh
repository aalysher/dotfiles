#!/bin/bash

# Получение текущего уровня заряда батареи
battery_level=$(acpi -b | grep -oP '[0-9]+(?=%)' | head -n 1)
battery_status=$(acpi -b | grep -oP 'Charging|Discharging' | head -n 1)

# Уведомления при низком уровне заряда
if [[ "$battery_status" == "Discharging" ]]; then
    if [[ $battery_level -le 20 && $battery_level -gt 15 ]]; then
        notify-send "⚠️ Батарея разряжена" "Осталось $battery_level% батареи" -u critical
    elif [[ $battery_level -le 15 && $battery_level -gt 10 ]]; then
        notify-send "🚨 Батарея на исходе" "Осталось $battery_level% батареи" -u critical
    elif [[ $battery_level -le 10 ]]; then
        notify-send "🔋 Срочно подключите зарядку" "Осталось $battery_level% батареи" -u critical
    fi
fi

