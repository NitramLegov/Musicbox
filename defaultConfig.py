try:
    import configparser
except:
    import ConfigParser as configparser

config_file = "/etc/mopidy/mopidy.conf"
config = configparser.ConfigParser()
config.read(config_file)
def core_defaults():
    config['core']['cache_dir'] = '/var/cache/mopidy'
    config['core']['config_dir'] = '/etc/mopidy'
    config['core']['data_dir'] = '/var/lib/mopidy'

def logging_defaults():
    config['logging']['config_file'] = '/etc/mopidy/logging.conf'
    config['logging']['debug_file'] = '/var/log/mopidy/mopidy-debug.log'

def local_defaults():
    config['local']['media_dir'] = '/var/lib/mopidy/media'
    config['local']['enabled'] = False

def m3u_defaults():
    config['m3u']['playlists_dir'] = '/var/lib/mopidy/playlists'
    config['m3u']['test'] = 'bullshit'

def http_defaults():
    config['http']['enabled'] = True
    config['http']['hostname'] = '0.0.0.0'
    config['http']['port'] = 8888
    config['http']['static_dir'] = ""
    config['http']['zeroconf'] = 'Mopidy HTTP server on $hostname'

def websettings_defaults():
    config['websettings']['enabled'] = True
    config['websettings']['musicbox'] = True
    config['websettings']['config_file'] = '/etc/mopidy/mopidy.conf'

def spotify_defaults(spotify_user = '', spotify_client_id = '', spotify_client_secret = '', spotify_password = ''):
    config['spotify']['enabled'] = 'True'
    config['spotify']['username'] = spotify_user
    config['spotify']['client_id'] = spotify_client_id
    config['spotify']['client_secret'] = spotify_client_secret
    config['spotify']['password'] = spotify_password
    config['spotify']['bitrate'] = 320


if not config.has_section('core') : config.add_section('core')
if not config.has_section('logging') : config.add_section('logging')
if not config.has_section('local') : config.add_section('local')
if not config.has_section('http') : config.add_section('http')
if not config.has_section('mpd') : config.add_section('mpd')
if not config.has_section('spotify') : config.add_section('spotify')
if not config.has_section('spotify_web') : config.add_section('spotify_web')
if not config.has_section('audio') : config.add_section('audio')
core_defaults()
logging_defaults()
local_defaults()
m3u_defaults()
def_http_defaults()
websettings_defaults()
spotify_defaults()