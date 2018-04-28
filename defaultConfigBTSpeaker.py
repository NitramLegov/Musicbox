try:
    import configparser
except:
    import ConfigParser as configparser

config_file = "/etc/bt_speaker/config.ini"
config = configparser.ConfigParser()
config.read(config_file)
def alsa_defaults():
    config['alsa']['enabled'] = 'yes'
    config['alsa']['mixer'] = 'DSP Program'
    config['alsa']['id'] = '0'
    config['alsa']['cardindex'] = '1'


if not config.has_section('alsa'):
    config.add_section('alsa')

alsa_defaults()


with open(config_file, 'wb') as configfile:
  config.write(configfile)