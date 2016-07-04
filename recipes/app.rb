# creating app user
user node['tracksapp']['user'] do
  manage_home true
  shell '/bin/bash'
  home "/home/#{node['tracksapp']['user']}"
end

# installing git for source deployment
package 'git-core'

# preparing project directory
directory node['tracksapp']['dir'] do
  owner node['tracksapp']['user']
  group node['tracksapp']['user']
  mode '0755'
end

# exporting source
git node['tracksapp']['dir'] do
  repository node['tracksapp']['repository']
  revision node['tracksapp']['git_revision']
  action :export
  user node['tracksapp']['user']
  group node['tracksapp']['user']
  not_if { File.exists? "#{node['tracksapp']['dir']}/.bundle" }
end

# using RVM LWRP (https://docs.omniref.com/github/martinisoft/chef-rvm/0.9.4)
# need to populate node attributes from wrappin cookbook first
node.set['rvm']['user_installs'] = [
  { 'user' => node['tracksapp']['user'],
    'default_ruby' => node['tracksapp']['ruby_default'],
    'rvmrc' => {
      'rvm_autolibs_flag' => false
    }
  }
]
include_recipe 'rvm::user_install'

# TODO not installing ruby on first try race cond?
rvm_ruby node['tracksapp']['ruby_default'] do
  user node['tracksapp']['user']
end

# creating gemset
rvm_environment node['tracksapp']['ruby_gemset'] do
  user node['tracksapp']['user']
end

# TODO do not install mysql/sqlite3 extensions as there are no mysql libs available
bash "remove mysql gem from Gemfile" do
  cwd node['tracksapp']['dir']
  code 'sed -i "/mysql/d" Gemfile; sed -i "/sqlite3/d" Gemfile; '
end

# Adding pg gem to Gemfile to use ruby driver
bash "add pg gem to Gemfile" do
  cwd node['tracksapp']['dir']
  code 'echo "gem \'pg\'" >> Gemfile'
  not_if { File.readlines("#{node['tracksapp']['dir']}/Gemfile").grep(/pg/).any? }
end

# bundle install
rvm_shell 'install dependencies' do
  ruby_string node['tracksapp']['ruby_gemset']
  cwd node['tracksapp']['dir']
  code "bundle install --without development test"
  user node['tracksapp']['user']
end

# adding configs
template "#{node['tracksapp']['dir']}/config/site.yml" do
  source 'site.yml.erb'
  owner node['tracksapp']['user']
  mode '0644'
end

template "#{node['tracksapp']['dir']}/config/database.yml" do
  source 'database.yml.erb'
  owner node['tracksapp']['user']
  mode '0644'
end

# some rake tasks
rvm_shell 'precompile assets' do
  ruby_string node['tracksapp']['ruby_gemset']
  cwd node['tracksapp']['dir']
  code "bundle exec rake assets:precompile RAILS_ENV=production"
  user node['tracksapp']['user']
end

rvm_shell 'db migrations' do
  ruby_string node['tracksapp']['ruby_gemset']
  cwd node['tracksapp']['dir']
  code "bundle exec rake db:migrate RAILS_ENV=production"
  user node['tracksapp']['user']
end

# running rails server WEBrick
# TODO add unicorn config and init.script / systemd unit
# now just serving static with nginx
rvm_shell 'run rails server' do
  ruby_string node['tracksapp']['ruby_gemset']
  cwd node['tracksapp']['dir']
  code "RAILS_ENV=production bundle exec rails server -d"
  user node['tracksapp']['user']
  ignore_failure true
end

# adding site config
nginx_site 'tracksapp' do
  template 'tracksapp.conf.erb'
  action :enable
end
