#!/bin/bash -x

ogg123 /usr/share/sounds/freedesktop/stereo/service-logout.oga

# reenable wifi - TODO: check what permissions bt-speaker might need for this (netdev group?)
sudo ifconfig wlan0 up 