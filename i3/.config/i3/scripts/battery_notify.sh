#!/bin/bash
# Файл для хранения предыдущего состояния
STATE_FILE="/tmp/battery_notification_state"

# Получение информации о батареях
battery_info=$(acpi -b)

# Найти максимальный уровень заряда среди всех батарей
battery_level=$(echo "$battery_info" | grep -oP '[0-9]+(?=%)' | sort -nr | head -n 1)
battery_status=$(echo "$battery_info" | grep -oP 'Charging|Discharging' | head -n 1)

# Проверка на пустые или некорректные значения
if [[ -z "$battery_level" || -z "$battery_status" ]]; then
    exit 1
fi

# Функция для проверки повторяющихся уведомлений
check_duplicate_notification() {
    local current_state="$battery_level:$battery_status"

    # Если файл состояния существует
    if [[ -f "$STATE_FILE" ]]; then
        local previous_state=$(cat "$STATE_FILE")

        # Не отправлять уведомление, если состояние не изменилось с прошлого раза
        if [[ "$previous_state" == "$current_state" ]]; then
            return 1  # Повторяющееся уведомление
        fi
    fi

    # Обновляем файл состояния
    echo "$current_state" > "$STATE_FILE"
    return 0  # Не повторяющееся уведомление
}

# Уведомления при низком уровне заряда (только если батарея разряжается)
if [[ "$battery_status" == "Discharging" ]]; then
    if [[ $battery_level -le 20 ]]; then
        check_duplicate_notification && notify-send "⚠️ Батарея разряжена" "Осталось $battery_level% батареи" -u critical
    elif [[ $battery_level -eq 0 ]]; then
        check_duplicate_notification && notify-send "❌ Ошибка считывания заряда" "acpi показывает 0%, но может быть ошибка." -u normal
    fi
# Добавляем уведомление при подключении зарядки с низким уровнем заряда
elif [[ "$battery_status" == "Charging" && $battery_level -le 20 ]]; then
    # Проверяем, было ли изменение статуса с Discharging на Charging
    if [[ -f "$STATE_FILE" ]]; then
        previous_state=$(cat "$STATE_FILE")
        if [[ "$previous_state" == *":Discharging" ]]; then
            check_duplicate_notification && notify-send "🔌 Зарядка подключена" "Текущий заряд: $battery_level%" -u normal
        fi
    fi
fi
