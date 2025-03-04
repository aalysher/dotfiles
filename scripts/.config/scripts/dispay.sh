#!/bin/bash

# Упрощенный скрипт настройки мониторов
INTERNAL_OUTPUT="eDP-1"
EXTERNAL_OUTPUT_DP1="DP-1"
EXTERNAL_OUTPUT_HDMI1="HDMI-1"
EXTERNAL_OUTPUT_HDMI2="HDMI-2"
EXTERNAL_OUTPUT_DP2="DP-2"

# Определение подключенного внешнего монитора
if xrandr | grep -q "$EXTERNAL_OUTPUT_DP1 connected"; then
    EXTERNAL_OUTPUT=$EXTERNAL_OUTPUT_DP1
elif xrandr | grep -q "$EXTERNAL_OUTPUT_HDMI1 connected"; then
    EXTERNAL_OUTPUT=$EXTERNAL_OUTPUT_HDMI1
elif xrandr | grep -q "$EXTERNAL_OUTPUT_HDMI2 connected"; then
    EXTERNAL_OUTPUT=$EXTERNAL_OUTPUT_HDMI2
elif xrandr | grep -q "$EXTERNAL_OUTPUT_DP2 connected"; then
    EXTERNAL_OUTPUT=$EXTERNAL_OUTPUT_DP2
else
    echo "Внешний монитор не обнаружен."
    exit 1
fi

# Путь к обоям
WALLPAPER="/home/aalysher/dotfiles/backgrounds/A.png"

# Варианты режимов
choices="laptop\ndual\nexternal\nclone"
chosen=$(echo -e $choices | dmenu -i)

# Функция для обновления обоев
update_wallpaper() {
    feh --bg-scale $WALLPAPER &
}

# Определение настроек монитора
setup_monitor() {
    # Определяем все доступные разрешения и частоты
    local resolutions=$(xrandr | grep -A 20 "$EXTERNAL_OUTPUT connected" | grep -o "[0-9]*x[0-9]*" | sort -u)

    # Ищем 2560x1440 среди доступных разрешений
    if echo "$resolutions" | grep -q "2560x1440"; then
        # Напрямую устанавливаем 2560x1440 с частотой 143.98 Гц
        xrandr --output $EXTERNAL_OUTPUT --mode 2560x1440 --rate 143.98
        echo "Установлено разрешение 2560x1440 с частотой 143.98 Гц"
    else
        # Если 2560x1440 недоступно, используем auto
        xrandr --output $EXTERNAL_OUTPUT --auto
        echo "Установлены автоматические настройки"
    fi
}

# Выполнение выбранного действия
case "$chosen" in
    external)
        # Только внешний монитор
        setup_monitor
        xrandr --output $EXTERNAL_OUTPUT --primary
        xrandr --output $INTERNAL_OUTPUT --off
        update_wallpaper
        echo "Режим: только внешний монитор"
        ;;
    laptop)
        # Только экран ноутбука
        xrandr --output $INTERNAL_OUTPUT --auto --primary
        xrandr --output $EXTERNAL_OUTPUT --off
        update_wallpaper
        echo "Режим: только ноутбук"
        ;;
    clone)
        # Клонирование
        xrandr --output $INTERNAL_OUTPUT --auto
        setup_monitor
        xrandr --output $EXTERNAL_OUTPUT --same-as $INTERNAL_OUTPUT
        update_wallpaper
        echo "Режим: клонирование экранов"
        ;;
    dual)
        # Два монитора
        xrandr --output $INTERNAL_OUTPUT --auto
        setup_monitor
        xrandr --output $EXTERNAL_OUTPUT --right-of $INTERNAL_OUTPUT --primary
        update_wallpaper
        echo "Режим: двойной экран"
        ;;
esac

# Проверка текущих настроек
current_resolution=$(xrandr | grep "$EXTERNAL_OUTPUT" -A 1 | grep "\*" | awk '{print $1}')
current_rate=$(xrandr | grep "$EXTERNAL_OUTPUT" -A 1 | grep "\*" | awk '{print $2}' | tr -d "*")

if [ "$chosen" != "laptop" ]; then
    echo "Текущая конфигурация внешнего монитора: $current_resolution @ $current_rate Гц"
fi
