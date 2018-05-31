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
```bash
git clone https://github.com/NitramLegov/Musicbox.git && cd Musicbox && sudo ./Install.sh
```
Please note that this script contains the following line:<br>
```bash
curl -s https://raw.githubusercontent.com/lukasjapan/bt-speaker/master/install.sh | sudo bash
```
This means trusting the owner of the bt-speaker repo just as much as the author of this Musicbox repo. Please check upfront and decide whether you really want to do this.
