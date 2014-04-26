#!/bin/sh

# Switch Esc and CapsLock keys using loadkeys, so that virtual consoles
# can also enjoy the pleasure of a useful CapsLock key.

# This should be loaded when booting. On Ubuntu & Debian, you could
# modify /etc/rc.local by adding a line to call this script.

# Adapted from http://linuxcommando.blogspot.com/2008/03/remap-caps-lock-key-for-virtual-console.html

{
    echo `dumpkeys | grep -i keymaps`
    echo keycode 58 = Escape
    echo keycode 1 = Caps_Lock
} | loadkeys -
