#!/bin/bash

# Kill previous instances of display_watcher if running
for pid in $(pgrep -f "display_watcher.sh" | grep -v "^$$$"); do
    kill "$pid" 2>/dev/null
done

# Run once on startup
~/.config/scripts/auto_display_switch.sh

# Fast debounced listener for DRM hotplug events
udevadm monitor --subsystem-match=drm | while read -r line; do
    if echo "$line" | grep -q "change.*drm"; then
        # Consume any rapid follow-up events within 0.15s (burst drain)
        while read -t 0.15 -r discarded; do :; done
        ~/.config/scripts/auto_display_switch.sh
    fi
done
