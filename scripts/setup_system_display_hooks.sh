#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Пожалуйста, запустите этот скрипт с sudo: sudo $0"
    exit 1
fi

echo "=== 1. Установка acpid (если не установлен) ==="
if ! command -v acpid &>/dev/null; then
    pacman -S --noconfirm acpid
fi
systemctl enable --now acpid.service

echo "=== 2. Создание wrapper скрипта в /usr/local/bin/auto-display-switch-wrapper.sh ==="
cat << 'EOF' > /usr/local/bin/auto-display-switch-wrapper.sh
#!/bin/bash
sleep 0.5

ACTIVE_USER="ninja"
export DISPLAY=":0"
export XAUTHORITY="/home/$ACTIVE_USER/.Xauthority"

if [ -f "$XAUTHORITY" ]; then
    sudo -u "$ACTIVE_USER" DISPLAY=":0" XAUTHORITY="$XAUTHORITY" /home/$ACTIVE_USER/.config/scripts/auto_display_switch.sh
fi
EOF
chmod +x /usr/local/bin/auto-display-switch-wrapper.sh

echo "=== 3. Настройка udev правила для монитора ==="
cat << 'EOF' > /etc/udev/rules.d/99-monitor-hotplug.rules
ACTION=="change", SUBSYSTEM=="drm", RUN+="/usr/local/bin/auto-display-switch-wrapper.sh"
EOF
udevadm control --reload-rules

echo "=== 4. Настройка события закрытия/открытия крышки (acpid) ==="
mkdir -p /etc/acpi/events
cat << 'EOF' > /etc/acpi/events/lid-switch
event=button/lid.*
action=/usr/local/bin/auto-display-switch-wrapper.sh
EOF
systemctl restart acpid.service

echo "=== 5. Настройка logind (не усыплять при закрытии крышки с подключенным монитором) ==="
mkdir -p /etc/systemd/logind.conf.d
cat << 'EOF' > /etc/systemd/logind.conf.d/lid.conf
[Login]
HandleLidSwitchDocked=ignore
EOF
systemctl restart systemd-logind

echo "=== Готово! Все системные правила успешно обновлены ==="
