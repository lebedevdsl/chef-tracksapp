default['tracksapp']['user'] = 'tracks'
default['tracksapp']['ruby_default'] = '1.9.3'
default['tracksapp']['ruby_gemset'] = '1.9.3@tracksapp'
default['tracksapp']['git_revision'] = 'v2.3.0'
default['tracksapp']['dir'] = '/opt/tracks'
default['tracksapp']['repository'] = 'https://github.com/TracksApp/tracks.git'
# site.yml attributes
default['tracksapp']['app'] = {
  'open_signups' => false,
  'admin_email' => 'admin@example.com',
  'secure_cookies' => false,
  'tz' => 'Europe/Moscow',
  'salt' => 'CHANGEME',
  'secret_token' => 'CHANGEME'
}
