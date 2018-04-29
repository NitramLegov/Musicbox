#!/bin/sh
check_iqaudio_activated() {
if grep -q -E "^(device_tree_overlay|dtoverlay)=([^,]*,)*iqaudio-dacplus?(,.*)?$" /boot/config.txt ; then
  #line is available and activated
  return 0
else
  #line not available or not activated
  return 1
fi
}

enter_full_setting()
{
lua - "$1" "$2" <<EOF > "$2.bak"
local key=assert(arg[1])
local fn=assert(arg[2])
local file=assert(io.open(fn))
local made_change=False
for line in file:lines() do
  if line:match("^#?%s*"..key) then
    line=key
    made_change=True
  end
  print(line)
end
if not made_change then
  print(key)
end
EOF
mv "$2.bak" "$2"
}

toggle_setting_on_off()
{
lua - "$1" "$2" "$3" <<EOF > "$3.bak"
local key=assert(arg[1])
local value=assert(arg[2])
local fn=assert(arg[3])
local file=assert(io.open(fn))
local made_change=False
for line in file:lines() do
  if line:match("^#?%s*"..key.."=.*$") then
    line=key.."="..value
    made_change=True
  end
  print(line)
end
if not made_change then
  print(key.."="..value)
end
EOF
mv "$3.bak" "$3"
}

enable_wifi_ap()
{
sudo apt-get -qq -y install dnsmasq hostapd
NOW=$(date +"%m_%d_%Y")
sudo cp /etc/dhcpcd.conf /etc/dhcpcd_$NOW.conf.bak
sudo echo "interface wlan0" > /etc/dhcpcd.conf
sudo echo "static ip_address=10.0.0.1/24" >> /etc/dhcpcd.conf
sudo service dhcpcd restart
sudo cp /etc/dnsmasq.conf /etc/dnsmasq_$NOW.conf.bak  
sudo echo "interface=wlan0" > /etc/dnsmasq.conf
sudo echo "dhcp-range=10.0.0.1,10.0.0.255,255.255.255.0,24h" >> /etc/dnsmasq.conf

sudo echo "interface=wlan0" > /etc/hostapd/hostapd.conf
#sudo echo "driver=rtl8192cu" >> /etc/hostapd/hostapd.conf
sudo echo "ssid=asmo" >> /etc/hostapd/hostapd.conf
sudo echo "hw_mode=g" >> /etc/hostapd/hostapd.conf
sudo echo "channel=6" >> /etc/hostapd/hostapd.conf
sudo echo "macaddr_acl=0" >> /etc/hostapd/hostapd.conf
sudo echo "auth_algs=1" >> /etc/hostapd/hostapd.conf
sudo echo "ignore_broadcast_ssid=0" >> /etc/hostapd/hostapd.conf
sudo echo "wpa=2" >> /etc/hostapd/hostapd.conf
sudo echo "wpa_passphrase=12345678" >> /etc/hostapd/hostapd.conf
sudo echo "wpa_key_mgmt=WPA-PSK" >> /etc/hostapd/hostapd.conf
sudo echo "wpa_pairwise=TKIP" >> /etc/hostapd/hostapd.conf
sudo echo "rsn_pairwise=CCMP" >> /etc/hostapd/hostapd.conf

sudo cp /etc/default/hostapd /etc/default/hostapd_$NOW.bak  
sudo echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" > /etc/default/hostapd

sudo systemctl start hostapd
sudo systemctl start dnsmasq
}

BLACKLIST=/etc/modprobe.d/raspi-blacklist.conf
CONFIG=/boot/config.txt
#Let us do some basic config
echo '--------------------------------------------'
echo 'First, we need to do some basic settings: Expand the FS and boot to command line.'
sudo raspi-config nonint do_expand_rootfs
sudo raspi-config nonint do_boot_behaviour B1

#Enable the x400 expansion board
echo '--------------------------------------------'
echo 'Now we will enable the x400 expansion board by enabling i2c and adding a device tree overlay'
sudo raspi-config nonint do_i2c 0

if check_iqaudio_activated ; then
 #do nothing
 echo 'iqaudio already activated'
else
 echo 'activating iqaudio'
 enter_full_setting dtoverlay=iqaudio-dacplus $CONFIG
fi
echo 'iqaudio activated'

echo '--------------------------------------------'
echo 'now we can start installing mopidy, following the instructions on https://docs.mopidy.com/en/latest/installation/raspberrypi/'
echo 'Adding the repository...'
wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
sudo wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/jessie.list
echo '--------------------------------------------'
echo 'Updating the apt-get index'
sudo apt-get -qq update
echo '--------------------------------------------'
echo 'Installing mopidy'
sudo apt-get -qq -y install build-essential python-dev python-pip mopidy

echo '--------------------------------------------'
echo 'now we will install a couple of mopidy extensions.'
#extensions are installed in this order because the apt-get commands will install dependencies like libffi automatically. This is needed by some of the extensions installed via pip.

echo 'spotify and youtube..'
sudo apt-get -qq -y install mopidy-spotify mopidy-spotify-tunigo mopidy-youtube
echo 'Mopidy-Iris..'
sudo pip install -q Mopidy-Iris
echo 'Mopidy-Material-Webclient..'
sudo pip install -q Mopidy-Material-Webclient
echo 'Mopidy-Moped..'
sudo pip install -q Mopidy-Moped
echo 'Mopidy-Mopify..'
sudo pip install -q Mopidy-Mopify
echo 'Mopidy-Party..'
sudo pip install -q Mopidy-Party
echo 'Mopidy-MusicBox-Webclient..'
sudo pip install -q Mopidy-MusicBox-Webclient
echo 'Mopidy-Websettings..'
sudo pip install -q Mopidy-WebSettings

echo '--------------------------------------------'
echo 'now we will add the default configuration'
sudo pip install -q configparser
sudo python defaultConfigMopidy.py

echo '--------------------------------------------'
echo 'now we enable running mopidy as a service. This requires all config to be stored in /etc/mopiy/mopidy.conf'
sudo systemctl enable mopidy

echo '--------------------------------------------'
echo 'Since this is intended to run on a pi3 with active Wifi, an SSH parameter needs to be set in order to ensure good ssh performance'
enter_full_setting 'IPQoS 0x00' /etc/ssh/ssh_config
enter_full_setting 'IPQoS 0x00' /etc/ssh/sshd_config
sudo systemctl restart ssh


#echo '--------------------------------------------'
#echo 'Let us enable the pi to run as a wifi Access point'
#enable_wifi_ap

# Bluetooth config
curl -s https://raw.githubusercontent.com/lukasjapan/bt-speaker/master/install.sh | sudo bash
sudo python defaultConfigBTSpeaker.py
sudo systemctl restart bt_speaker

echo '--------------------------------------------'
echo 'All done, a reboot is recommended.'