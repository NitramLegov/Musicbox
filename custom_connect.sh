#!/bin/bash -x

ogg123 /usr/share/sounds/freedesktop/stereo/service-login.oga

# disconnect wifi to prevent dropouts - TODO: check what permissions bt-speaker might need for this (netdev group?)
#sudo ifconfig wlan0 down
sudo systemctl stop mopidy