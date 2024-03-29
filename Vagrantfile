# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure('2') do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = 'ubuntu/focal64'

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = true

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider 'virtualbox' do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true
    # Customize the amount of memory on the VM:
    vb.memory = '2048' # see ~/jenkins/.mvn/jvm.config for tunning
    vb.name = 'Jenkins Builder'
    vb.customize ['modifyvm', :id, '--vram', 9]
    vb.customize ['modifyvm', :id, '--uartmode1', 'disconnected']
    vb.customize ['modifyvm', :id, '--vrde', 'off']
    vb.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']
    vb.customize ['modifyvm', :id, '--audio', 'none']
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  maven_version = '3.8.6'
  maven_tarball = '/opt/apache-maven.tar.gz'
  final_dir = 'apache-maven'
  profile = '/home/vagrant/.profile'

  config.vm.provision 'shell', inline: <<-SHELL
    apt-get update
    apt-get upgrade -y
    apt-get install -y openjdk-11-jdk-headless wget git tree
    wget --no-verbose --continue --output-document=#{maven_tarball} https://dlcdn.apache.org/maven/maven-3/#{maven_version}/binaries/apache-maven-#{maven_version}-bin.tar.gz
    cd /opt
    if [ -d #{final_dir} ]; then rm -rf #{final_dir}; fi
    echo 'Extracting the tarball...'
    tar -xzf #{maven_tarball}
    mv -v apache-maven-#{maven_version} #{final_dir}
    rm -fv #{maven_tarball}
    chmod -v a+w #{profile}
    echo -e '\n# Configuring Apache Maven' | tee -a #{profile}
    echo 'export PATH=/opt/#{final_dir}/bin:$PATH' | tee -a #{profile}
    chmod -v 644 #{profile}
  SHELL
end
