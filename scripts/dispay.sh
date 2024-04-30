#!/bin/bash

# Имя встроенного монитора (замените на ваше имя)
INTERNAL_OUTPUT="eDP-1"

# Имя внешнего монитора (замените на ваше имя)
EXTERNAL_OUTPUT="HDMI-2"

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

