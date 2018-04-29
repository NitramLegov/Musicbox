try:
    import configparser
except:
    import ConfigParser as configparser

config_file_audio = "/etc/bluetooth/audio.conf"
config_audio = configparser.ConfigParser()
try:
    config_audio.read(config_file_audio)
except:
    print 'file not available'

if not config_audio.has_section('General'):
    config_audio.add_section('General')

config_audio['General']['Enable'] = 'Source,Sink,Media,Socket'
config_audio['General']['HFP'] = 'true'
config_audio['General']['Class'] = '0x20041C'
with open(config_file_audio, 'wb') as configfile:
  config_audio.write(configfile)



config_file_main = "/etc/bluetooth/main.conf"
config_main = configparser.ConfigParser()
try:
    config_main.read(config_file_main)
except:
    print 'file not available'

if not config_main.has_section('General'):
    config_main.add_section('General')

config_audio['General']['Name'] = 'PiBoxBT'
config_audio['General']['Class'] = '0x20041C'
with open(config_file_audio, 'wb') as configfile:
  config_audio.write(configfile)

