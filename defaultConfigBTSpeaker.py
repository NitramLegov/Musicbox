try:
    import configparser
except:
    import ConfigParser as configparser

config_file = "/etc/bt_speaker/config.ini"
config = configparser.ConfigParser()
config.read(config_file)

def bt_speaker_defaults():
#    config['bt_speaker']['play_command'] = 'aplay -Ddmix:CARD=IQaudIODAC,DEV=0 -f cd -'
    config['bt_speaker']['play_command'] = 'aplay -D default -N -f cd -'
    config['bt_speaker']['connect_command'] = '/etc/bt_speaker/hooks/custom_connect.sh'
    config['bt_speaker']['disconnect_command'] = '/etc/bt_speaker/hooks/custom_disconnect.sh'


def alsa_defaults():
    config['alsa']['enabled'] = 'yes'
    config['alsa']['mixer'] = 'Digital'
    config['alsa']['id'] = '0'
    config['alsa']['cardindex'] = '1'


if not config.has_section('bt_speaker'):
    config.add_section('bt_speaker')
if not config.has_section('alsa'):
    config.add_section('alsa')


bt_speaker_defaults()
alsa_defaults()


with open(config_file, 'wb') as configfile:
  config.write(configfile)