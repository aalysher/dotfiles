#!/bin/bash

# Имя встроенного монитора
INTERNAL_OUTPUT="eDP-1"

# Имена возможных внешних мониторов
EXTERNAL_OUTPUT_HDMI="HDMI-2"
EXTERNAL_OUTPUT_DP="DP-2"

# Проверяем, какой монитор подключен
if xrandr | grep -q "$EXTERNAL_OUTPUT_HDMI connected"; then
    EXTERNAL_OUTPUT=$EXTERNAL_OUTPUT_HDMI
elif xrandr | grep -q "$EXTERNAL_OUTPUT_DP connected"; then
    EXTERNAL_OUTPUT=$EXTERNAL_OUTPUT_DP
else
    echo "Внешний монитор не обнаружен."
    exit 1
fi

# Варианты выбора
choices="laptop\ndual\nexternal\nclone"

# Выбор пользователя в dmenu
chosen=$(echo -e $choices | dmenu -i)

# Выполнение команд xrandr в зависимости от выбора пользователя
case "$chosen" in
    external) xrandr --output $INTERNAL_OUTPUT --off --output $EXTERNAL_OUTPUT --auto --primary ;;
    laptop) xrandr --output $INTERNAL_OUTPUT --auto --primary --output $EXTERNAL_OUTPUT --off ;;
    clone) xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --auto --same-as $INTERNAL_OUTPUT ;;
    dual) xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --auto --right-of $INTERNAL_OUTPUT --primary ;;
esac

