# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04-arm64" # replace if necessary

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provision.yml"
  end

  config.vm.network :private_network, ip: "192.168.100.4"
  config.vm.network "forwarded_port", guest: 8000, host: 8000 

  #replace if necessary
  config.vm.provider "vmware_desktop" do |v|
    v.memory = 2048           # Allocate 2GB of RAM
    v.cpus = 2                # Allocate 2 CPUs
    v.gui = true
  end
end
