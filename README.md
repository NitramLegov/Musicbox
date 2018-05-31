# Musicbox
This Repository contains installation code for setting up a music system based on the raspberry pi.<br>
# Hardware
Raspberry pi<br>
Suptronics x400<br>

# Software
[Raspbian](https://www.raspberrypi.org/downloads/raspbian/)<br>
[Mopidy](https://www.mopidy.com/) (with the following plugins)<br>

   mopidy-spotify <br>
   mopidy-spotify-tunigo <br>
   mopidy-youtube<br>
   
[BT-Speaker](https://github.com/lukasjapan/bt-speaker)<br>

# Installation
If you want to install the software as is (e.g. if you have the exact same system as me), just do:
```bash
git clone https://github.com/NitramLegov/Musicbox.git && cd Musicbox && sudo ./Install.sh
```
Please note that this script contains the following line:<br>
```bash
curl -s https://raw.githubusercontent.com/lukasjapan/bt-speaker/master/install.sh | sudo bash
```
This means trusting the owner of the bt-speaker repo just as much as the author of this Musicbox repo. Please check upfront and decide whether you really want to do this.

# Adjusting to your needs
If you use a different soundcard:
Adjust the following lines in Install_SystemSettings.sh to your needs:
```bash```
if check_iqaudio_activated ; then
 #do nothing
 echo 'iqaudio already activated'
else
 echo 'activating iqaudio'
 enter_full_setting dtoverlay=iqaudio-dacplus $CONFIG
 sudo cp asound.conf /etc/asound.conf
fi
echo 'iqaudio activated'
```

In this case, please also consider changing asound.conf to your needs accordingly.

If you want to use a different set of mopidy plugins:
Install Mopidy manually (Following this [Tutorial] (https://docs.mopidy.com/en/latest/installation/raspberrypi/))
Install the plugins
Check the settings done in defaultConfigMopidy.py and copy especially the output option in the audio section:
output = 'alsasink device=default'
