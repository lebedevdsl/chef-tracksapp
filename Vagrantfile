Vagrant.configure("2") do |config|
  config.vm.hostname = "tracksapp"
  config.vm.box = "ubuntu/trusty64"
  config.omnibus.chef_version = '12.10.24'
  config.vm.network :private_network, ip: "192.168.0.10"
  config.vm.boot_timeout = 120
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = 'Berksfile'

  config.vm.provision :chef_solo do |chef|
    chef.json = {
    }
    chef.run_list = [
      "recipe[nginx::default]",
      "recipe[tracksapp::default]",
    ]
    chef.log_level = 'debug'
  end
end
