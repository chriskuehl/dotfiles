#!/bin/bash
# disable caps lock
/usr/bin/setxkbmap -option ctrl:nocaps

# set caps lock key to compose key
/usr/bin/setxkbmap -option compose:caps

# use a reasonable keyboard rate
xset r on
xset r rate 200 30

xset m 0 0
