echo '--------------------------------------------'
echo 'now we can start installing mopidy, following the instructions on https://docs.mopidy.com/en/latest/installation/raspberrypi/'
echo 'Adding the repository...'
wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
sudo wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/jessie.list
echo '--------------------------------------------'
echo 'Updating the apt-get index'
sudo apt-get -qq update >> /dev/null
echo '--------------------------------------------'
echo 'Installing mopidy'
sudo apt-get -qq -y install build-essential python-dev python-pip mopidy >> /dev/null

echo '--------------------------------------------'
echo 'now we will install a couple of mopidy extensions.'
#extensions are installed in this order because the apt-get commands will install dependencies like libffi automatically. This is needed by some of the extensions installed via pip.

echo 'Backend Plugins: spotify and youtube..'
sudo pip install pafy >> /dev/null
sudo pip install youtube-dl >> /dev/null
sudo apt-get -qq -y install mopidy-spotify mopidy-spotify-tunigo mopidy-youtube >> /dev/null
echo 'Backend plugin: Mopidy-Local-SQLite'
sudo pip install Mopidy-Local-SQLite
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