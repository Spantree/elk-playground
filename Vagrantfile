PROJECT_ROOT='/usr/local/src/elk-demo'

Vagrant.configure("2") do |config|
  config.vm.box = "spantree/trusty64-puppet-3.7.4-java8"
  config.vm.box_version = ">= 1.0.0"

  config.vm.synced_folder '.', PROJECT_ROOT, :create => 'true'
  config.vm.synced_folder 'puppet', '/usr/local/etc/puppet', :create => 'true'

  config.ssh.shell = "bash -l"

  config.ssh.keep_alive = true
  config.ssh.forward_agent = false
  config.ssh.forward_x11 = false
  config.vagrant.host = :detect

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = true
    config.vbguest.no_remote = false
  end

  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
    config.cache.auto_detect = false
    config.cache.enable :gem
    config.cache.enable :apt
    config.cache.enable :generic, {
      "wget" => { cache_dir: "/var/cache/wget" },
    }
  end

  config.vm.define :elk do |elk|
    elk.vm.hostname = "elk.demo.local"
    elk.hostmanager.aliases = %w(es.demo.local)
    elk.hostmanager.manage_host = true
    elk.vm.provider :virtualbox do |v, override|
      override.vm.network :private_network, ip: "192.168.222.101"
      v.customize ["modifyvm", :id, "--name", "elk"]
      v.customize ["modifyvm", :id, "--memory", 4096]
    end

    config.vm.provision :shell, :inline => "apt-get update"
    config.vm.provision :shell, :path => "shell/curl-setup.sh", :args => [PROJECT_ROOT, '3.7.4-1puppetlabs1']

    elk.vm.provision :hostmanager

    elk.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.options = [
        "--verbose",
        "--debug",
        "--modulepath=/etc/puppet/modules:#{PROJECT_ROOT}/puppet/modules",
        "--hiera_config #{PROJECT_ROOT}/hiera.yaml",
        "--templatedir=#{PROJECT_ROOT}/puppet/templates",
      ]
      puppet.facter = {
      }
    end
  end

end
