#!/bin/sh

BLACKLIST=/etc/modprobe.d/raspi-blacklist.conf
CONFIG=/boot/config.txt

sudo apt-get -qq update

#Let us do some basic config
echo 'First, we need to do some basic settings: Expand the FS and boot to command line'
sudo raspi-config nonint do_expand_rootfs
sudo raspi-config nonint do_boot_behaviour B1

#Enable the x400 expansion board
echo 'Now we will enable the x400 expansion board by enabling i2c and adding a device tree overlay'
sudo raspi-config nonint do_i2c 0
if check_iqaudio_activated ; then
 #do nothing
else
 enter_full_setting dtoverlay=iqaudio-dacplus $CONFIG
fi



echo 'All done, a reboot is recommended.'

check_iqaudio_activated() {
if grep -q -E "^(device_tree_overlay|dtoverlay)=([^,]*,)*iqaudio-dacplus?(,.*)?$" /boot/config.txt ; then
  #line is available and activated
  return true
else
  #line not available or not activated
  return false
fi
}

enter_full_setting()
{
lua - "$1" "$2" <<EOF > "$2.bak"
local key=assert(arg[1])
local fn=assert(arg[2])
local file=assert(io.open(fn))
local made_change=false
for line in file:lines() do
  if line:match("^#?%s*"..key) then
    line=key
    made_change=true
  end
  print(line)
end
if not made_change then
  print(key)
end
EOF
mv "$2.bak" "$2"
}

toogle_setting_on_off()
{
lua - "$1" "$2" "$3" <<EOF > "$3.bak"
local key=assert(arg[1])
local value=assert(arg[2])
local fn=assert(arg[3])
local file=assert(io.open(fn))
local made_change=false
for line in file:lines() do
  if line:match("^#?%s*"..key.."=.*$") then
    line=key.."="..value
    made_change=true
  end
  print(line)
end
if not made_change then
  print(key.."="..value)
end
EOF
mv "$3.bak" "$3"
}