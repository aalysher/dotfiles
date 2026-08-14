# 🖥️ Автоматическое переключение мониторов (Arch Linux + i3wm / X11)

Автоматическая система горячего подключения внешних мониторов (Hotplug) и переключения при открытии/закрытии крышки ноутбука (Clamshell / Dock mode) без мерцания и задержек.

---

## 📁 Структура файлов

```
dotfiles/
├── scripts/
│   ├── .config/scripts/
│   │   ├── auto_display_switch.sh   # Основной скрипт управления xrandr и обоями
│   │   ├── display_watcher.sh       # Фоновый слушатель DRM-событий ядра (i3wm)
│   │   └── dispay.sh                # Меню ручного выбора монитора через dmenu ($mod+Display)
│   ├── setup_system_display_hooks.sh # Скрипт однократной системной установки (sudo)
│   └── README.md                    # Данная документация
└── i3/
    └── .config/i3/config            # Конфигурация i3wm (автозапуск display_watcher.sh)
```

---

## ⚙️ Как это работает

### 1. `auto_display_switch.sh`
- **Определение оборудования**: считывает статус портов напрямую из ядра Linux (`/sys/class/drm/card*-*/status`), что исключает задержки и устаревший кэш X-сервера.
- **Определение крышки ноутбука**: читает `/proc/acpi/button/lid/LID/state` (`open` / `closed`).
- **Атомарное переключение `xrandr`**: переключение разрешения, отключение встроенного экрана `eDP-1` и включение внешнего монитора (`DP-1`, `HDMI-1` и др.) происходят в **одной неделимой команде**, предотвращая повторные сбросы сигнала монитора.
- **Поддержка высокой частоты**: автоматически применяет `2560x1440@143.98Hz` (если поддерживается) или `--auto`.
- **Обои**: автоматически растягивает обои через `feh --bg-scale`.
- **Защита от гонок**: использует PID lock-файл `/tmp/auto_display_switch.lock`.

### 2. `display_watcher.sh`
- Запускается внутри сессии i3wm через `exec_always` в `~/.config/i3/config`.
- В реальном времени слушает события `udevadm monitor --subsystem-match=drm`.
- Содержит быстрый фильтр дребезга (Burst Drain `0.15s`), чтобы объединять пачку событий физического контакта кабеля в **один вызов**.

### 3. Системные правила (ACPI, udev, logind)
- **`acpid` (`/etc/acpi/events/lid-switch`)**: перехватывает физическое открытие и закрытие крышки.
- **`udev` (`/etc/udev/rules.d/99-monitor-hotplug.rules`)**: реагирует на системные события DRM.
- **`logind` (`/etc/systemd/logind.conf.d/lid.conf`)**: содержит `HandleLidSwitchDocked=ignore`, предотвращая засыпание ноутбука при закрытии крышки с подключенным монитором.
- **Wrapper (`/usr/local/bin/auto-display-switch-wrapper.sh`)**: безопасно пробрасывает `DISPLAY=:0` и `XAUTHORITY` от root к пользователю `ninja`.

---

## 🚀 Восстановление на новой системе (после переустановки ОС)

Если вы переустановили Arch Linux и развернули dotfiles (например, через `stow`), выполните следующие шаги:

### Шаг 1. Убедитесь, что установлены необходимые пакеты
```bash
sudo pacman -S --needed xorg-xrandr feh acpid
```

### Шаг 2. Разверните dotfiles (stow) и выдайте права на исполнение
```bash
cd ~/dotfiles
stow scripts i3
chmod +x ~/.config/scripts/*.sh ~/dotfiles/scripts/setup_system_display_hooks.sh
```

### Шаг 3. Запустите скрипт установки системных хуков
```bash
sudo ~/dotfiles/scripts/setup_system_display_hooks.sh
```
Этот скрипт автоматически:
1. Установит и включит `acpid.service`.
2. Создаст wrapper в `/usr/local/bin/auto-display-switch-wrapper.sh`.
3. Создаст udev-правило `/etc/udev/rules.d/99-monitor-hotplug.rules`.
4. Настроит событие крышки `/etc/acpi/events/lid-switch`.
5. Настроит `HandleLidSwitchDocked=ignore` в `/etc/systemd/logind.conf.d/lid.conf`.

### Шаг 4. Перезагрузите i3wm
В i3 нажмите `$mod+Shift+r` или выполните:
```bash
i3-msg restart
```

---

## 🔍 Диагностика и логи

Все действия скрипта логируются с таймстемпами. Посмотреть лог в реальном времени:
```bash
tail -f /tmp/auto_display_switch.log
```
Ручной тестовый запуск:
```bash
~/.config/scripts/auto_display_switch.sh
```
