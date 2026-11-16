#!/usr/bin/env python3

import ctypes
import ctypes.util
import fcntl
import re
import subprocess
import sys
from pathlib import Path

XKB_USE_CORE_KBD = 0x0100
XKB_STATE_NOTIFY = 2
XKB_STATE_NOTIFY_MASK = 1 << XKB_STATE_NOTIFY
XKB_GROUP_STATE_MASK = 1 << 4
XKB_ALL_STATE_COMPONENTS_MASK = 0x3FFF


class XkbState(ctypes.Structure):
    _fields_ = [
        ("group", ctypes.c_ubyte),
        ("locked_group", ctypes.c_ubyte),
        ("base_group", ctypes.c_ushort),
        ("latched_group", ctypes.c_ushort),
        ("mods", ctypes.c_ubyte),
        ("base_mods", ctypes.c_ubyte),
        ("latched_mods", ctypes.c_ubyte),
        ("locked_mods", ctypes.c_ubyte),
        ("compat_state", ctypes.c_ubyte),
        ("grab_mods", ctypes.c_ubyte),
        ("compat_grab_mods", ctypes.c_ubyte),
        ("lookup_mods", ctypes.c_ubyte),
        ("compat_lookup_mods", ctypes.c_ubyte),
        ("ptr_buttons", ctypes.c_ushort),
    ]


class XkbStateNotifyEvent(ctypes.Structure):
    _fields_ = [
        ("type", ctypes.c_int),
        ("serial", ctypes.c_ulong),
        ("send_event", ctypes.c_int),
        ("display", ctypes.c_void_p),
        ("time", ctypes.c_ulong),
        ("xkb_type", ctypes.c_int),
        ("device", ctypes.c_int),
        ("changed", ctypes.c_uint),
        ("group", ctypes.c_int),
        ("base_group", ctypes.c_int),
        ("latched_group", ctypes.c_int),
        ("locked_group", ctypes.c_int),
        ("mods", ctypes.c_uint),
        ("base_mods", ctypes.c_uint),
        ("latched_mods", ctypes.c_uint),
        ("locked_mods", ctypes.c_uint),
        ("compat_state", ctypes.c_int),
        ("grab_mods", ctypes.c_ubyte),
        ("compat_grab_mods", ctypes.c_ubyte),
        ("lookup_mods", ctypes.c_ubyte),
        ("compat_lookup_mods", ctypes.c_ubyte),
        ("ptr_buttons", ctypes.c_int),
        ("keycode", ctypes.c_ubyte),
        ("event_type", ctypes.c_char),
        ("req_major", ctypes.c_char),
        ("req_minor", ctypes.c_char),
    ]


class XkbEvent(ctypes.Union):
    _fields_ = [
        ("type", ctypes.c_int),
        ("state", XkbStateNotifyEvent),
        ("padding", ctypes.c_long * 24),
    ]


def load_xkb():
    library = ctypes.util.find_library("X11")
    if not library:
        raise RuntimeError("libX11 was not found")

    x11 = ctypes.CDLL(library)
    x11.XOpenDisplay.argtypes = [ctypes.c_char_p]
    x11.XOpenDisplay.restype = ctypes.c_void_p
    x11.XCloseDisplay.argtypes = [ctypes.c_void_p]
    x11.XNextEvent.argtypes = [ctypes.c_void_p, ctypes.POINTER(XkbEvent)]
    x11.XSync.argtypes = [ctypes.c_void_p, ctypes.c_int]
    x11.XkbQueryExtension.argtypes = [
        ctypes.c_void_p,
        ctypes.POINTER(ctypes.c_int),
        ctypes.POINTER(ctypes.c_int),
        ctypes.POINTER(ctypes.c_int),
        ctypes.POINTER(ctypes.c_int),
        ctypes.POINTER(ctypes.c_int),
    ]
    x11.XkbQueryExtension.restype = ctypes.c_int
    x11.XkbSelectEvents.argtypes = [
        ctypes.c_void_p,
        ctypes.c_uint,
        ctypes.c_uint,
        ctypes.c_uint,
    ]
    x11.XkbSelectEvents.restype = ctypes.c_int
    x11.XkbSelectEventDetails.argtypes = [
        ctypes.c_void_p,
        ctypes.c_uint,
        ctypes.c_uint,
        ctypes.c_ulong,
        ctypes.c_ulong,
    ]
    x11.XkbSelectEventDetails.restype = ctypes.c_int
    x11.XkbGetState.argtypes = [
        ctypes.c_void_p,
        ctypes.c_uint,
        ctypes.POINTER(XkbState),
    ]
    x11.XkbGetState.restype = ctypes.c_int
    return x11


def get_layouts():
    result = subprocess.run(
        ["setxkbmap", "-query"],
        check=True,
        capture_output=True,
        text=True,
    )
    match = re.search(r"^\s*layout:\s*(\S+)", result.stdout, re.MULTILINE)
    if not match:
        raise RuntimeError("could not read configured keyboard layouts")
    return [layout.strip() for layout in match.group(1).split(",")]


def notify(layout):
    labels = {"us": "EN", "ru": "RU"}
    label = labels.get(layout.lower(), layout.upper())
    subprocess.run(
        [
            "notify-send",
            "--transient",
            "--expire-time=1000",
            "--app-name=Keyboard",
            "--icon=/usr/share/icons/Adwaita/scalable/devices/input-keyboard.svg",
            label,
        ],
        check=True,
    )


def main():
    lock_path = Path.home() / ".cache" / "i3-layout-notify.lock"
    lock_path.parent.mkdir(parents=True, exist_ok=True)
    lock_file = lock_path.open("w")
    try:
        fcntl.flock(lock_file, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        return 0

    layouts = get_layouts()
    x11 = load_xkb()
    display = x11.XOpenDisplay(None)
    if not display:
        raise RuntimeError("could not connect to the X display")

    try:
        opcode = ctypes.c_int()
        event_base = ctypes.c_int()
        error_base = ctypes.c_int()
        major = ctypes.c_int()
        minor = ctypes.c_int()
        if not x11.XkbQueryExtension(
            display,
            ctypes.byref(opcode),
            ctypes.byref(event_base),
            ctypes.byref(error_base),
            ctypes.byref(major),
            ctypes.byref(minor),
        ):
            raise RuntimeError("the X server does not support XKB")

        if not x11.XkbSelectEvents(
            display,
            XKB_USE_CORE_KBD,
            XKB_STATE_NOTIFY_MASK,
            XKB_STATE_NOTIFY_MASK,
        ):
            raise RuntimeError("could not subscribe to XKB state changes")

        if not x11.XkbSelectEventDetails(
            display,
            XKB_USE_CORE_KBD,
            XKB_STATE_NOTIFY,
            XKB_ALL_STATE_COMPONENTS_MASK,
            XKB_GROUP_STATE_MASK,
        ):
            raise RuntimeError("could not subscribe to XKB group changes")

        state = XkbState()
        if x11.XkbGetState(display, XKB_USE_CORE_KBD, ctypes.byref(state)) != 0:
            raise RuntimeError("could not read the current XKB state")
        previous_group = state.group

        x11.XSync(display, 0)
        event = XkbEvent()
        while True:
            x11.XNextEvent(display, ctypes.byref(event))
            if (
                event.type == event_base.value
                and event.state.xkb_type == XKB_STATE_NOTIFY
                and event.state.changed & XKB_GROUP_STATE_MASK
            ):
                group = event.state.group
                if group != previous_group:
                    if group >= len(layouts):
                        raise RuntimeError(f"unknown keyboard layout group: {group}")
                    notify(layouts[group])
                    previous_group = group
    finally:
        x11.XCloseDisplay(display)


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as error:
        print(f"layout-notify: {error}", file=sys.stderr)
        sys.exit(1)
