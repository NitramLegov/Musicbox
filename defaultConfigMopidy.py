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
    config['local']['enabled'] = 'True'
    config['local']['media_dir'] = '/Music \n  /usbdrives'
    config['local']['library'] = 'sqlite'
    config['local']['scan_timeout'] = '1000'
    config['local']['scan_flush_threshold'] = '100'
    config['local']['scan_follow_symlinks'] = 'true'
    config['local']['excluded_file_extensions'] = '\n  .directory\n  .html\n  .jpeg\n  .jpg\n  .log\n  .nfo\n  .png\n  .txt'

def file_defaults():
    config['file']['enabled'] = 'True'
    config['file']['media_dirs'] = '/Music \n  /usbdrives'
    config['file']['excluded_file_extensions'] = '\n  .jpg\n  .jpeg'
    config['file']['show_dotfiles'] = 'false'
    config['file']['follow_symlinks'] = 'false'
    config['file']['metadata_timeout'] = '1000'

def m3u_defaults():
    config['m3u']['playlists_dir'] = '/var/lib/mopidy/playlists'

def http_defaults():
    config['http']['enabled'] = 'True'
    config['http']['hostname'] = '::'
    config['http']['port'] = '8888'
    config['http']['static_dir'] = ""
    config['http']['zeroconf'] = 'Mopidy HTTP server on $hostname'

def mpd_defaults():
    config['mpd']['enabled'] = 'True'
    config['mpd']['hostname'] = '::'
    config['mpd']['port'] = '6600'
    config['mpd']['password'] = ''
    config['mpd']['max_connections'] = '20'
    config['mpd']['connection_timeout'] = '60'
    config['mpd']['zeroconf'] = 'Mopidy MPD server on $hostname'
    config['mpd']['command_blacklist'] = '  listall\n  listallinfo'
    config['mpd']['default_playlist_scheme'] = 'm3u'

def websettings_defaults():
    config['websettings']['enabled'] = 'True'
    config['websettings']['musicbox'] = 'True'
    config['websettings']['config_file'] = '/etc/mopidy/mopidy.conf'

def spotify_defaults(spotify_user = '', spotify_client_id = '', spotify_client_secret = '', spotify_password = ''):
    config['spotify']['enabled'] = 'True'
    config['spotify']['username'] = spotify_user
    config['spotify']['client_id'] = spotify_client_id
    config['spotify']['client_secret'] = spotify_client_secret
    config['spotify']['password'] = spotify_password
    config['spotify']['bitrate'] = '320'

def spotify_web_defaults(spotify_user = '', spotify_client_id = '', spotify_client_secret = '', spotify_password = ''):
    config['spotify_web']['enabled'] = 'True'
    config['spotify_web']['username'] = spotify_user
    config['spotify_web']['client_id'] = spotify_client_id
    config['spotify_web']['client_secret'] = spotify_client_secret
    config['spotify_web']['password'] = spotify_password
    config['spotify_web']['bitrate'] = '320'

def audio_defaults():
    config['audio']['mixer_volume'] = '100'
    config['audio']['mixer'] = 'software'
#    config['audio']['output'] = 'alsasink device=hw:1,0'
    config['audio']['output'] = 'alsasink device=default'

if not config.has_section('core'):
    config.add_section('core')

if not config.has_section('logging'):
    config.add_section('logging')

if not config.has_section('local'):
    config.add_section('local')

if not config.has_section('file'):
    config.add_section('file')

if not config.has_section('m3u'):
    config.add_section('m3u')

if not config.has_section('http'):
    config.add_section('http')

if not config.has_section('mpd'):
    config.add_section('mpd')

if not config.has_section('websettings'):
    config.add_section('websettings')

if not config.has_section('spotify'):
    config.add_section('spotify')

if not config.has_section('spotify_web'):
    config.add_section('spotify_web')

if not config.has_section('audio'):
    config.add_section('audio')

core_defaults()
logging_defaults()
local_defaults()
file_defaults()
m3u_defaults()
http_defaults()
mpd_defaults()
websettings_defaults()
spotify_defaults()
spotify_web_defaults()
audio_defaults()
with open(config_file, 'wb') as configfile:
  config.write(configfile)