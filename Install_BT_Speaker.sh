curl -s https://raw.githubusercontent.com/lukasjapan/bt-speaker/master/install.sh | sudo bash
sudo python defaultConfigBluetooth.py
sudo python defaultConfigBTSpeaker.py
sudo systemctl restart bt_speaker