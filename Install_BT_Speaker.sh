
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

echo 'Installing the bt_speaker Software'
curl -s https://raw.githubusercontent.com/lukasjapan/bt-speaker/master/install.sh | sudo bash
echo 'bt_speaker installed, starting configuration.'
BTMac = $(sudo ls /var/lib/bluetooth)
sudo python defaultConfigBluetooth.py $BTMac
sudo python defaultConfigBTSpeaker.py


#enable wifi down when connecting
enter_full_setting "btspeaker ALL=(ALL) NOPASSWD: /sbin/ifconfig" /etc/sudoers
enter_full_setting "btspeaker ALL=(ALL) NOPASSWD: /bin/systemctl" /etc/sudoers
sudo cp custom_connect.sh /etc/bt_speaker/hooks/
sudo cp custom_disconnect.sh /etc/bt_speaker/hooks/
sudo chmod +x /etc/bt_speaker/hooks/custom_connect.sh
sudo chmod +x /etc/bt_speaker/hooks/custom_disconnect.sh

sudo systemctl restart bt_speaker
echo 'bt_speaker installed'