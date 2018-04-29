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

# Bluetooth config

sudo apt-get -y install alsa-utils bluez bluez-tools pulseaudio-module-bluetooth python-gobject python-gobject-2
sudo usermod -a -G lp pi
sudo usermod -a -G pulse-access,audio root
sudo adduser pi pulse-access
enter_full_setting "resample-method = trivial" /etc/pulse/daemon.conf
enter_full_setting ".ifexists module-bluetooth-policy.so/nload-module module-bluetooth-policy/n.endif/n.ifexists module-bluetooth-discover.so/nload-module module-bluetooth-discover/n.endif/n.ifexists module-bluez5-device.so/nload-module module-bluez5-device/n.endif/n.ifexists module-bluez5-discover.so/nload-module module-bluez5-discover/n.endif" /etc/pulse/system.pa

sudo echo "interface=wlan0" > /etc/systemd/system/pulseaudio.service
sudo echo "[Unit]" >> /etc/systemd/system/pulseaudio.service
sudo echo "Description=Pulse Audio" >> /etc/systemd/system/pulseaudio.service
sudo echo "[Service]" >> /etc/systemd/system/pulseaudio.service
sudo echo "Type=simple" >> /etc/systemd/system/pulseaudio.service
sudo echo "ExecStart=/usr/bin/pulseaudio --system --disallow-exit --disallow-module-loading --disable-shm --daemonize" >> /etc/systemd/system/pulseaudio.service
sudo echo "[Install]" >> /etc/systemd/system/pulseaudio.service
sudo echo "WantedBy=multi-user.target" >> /etc/systemd/system/pulseaudio.service

sudo systemctl daemon-reload
sudo systemctl enable pulseaudio.service
sudo systemctl start pulseaudio.service
