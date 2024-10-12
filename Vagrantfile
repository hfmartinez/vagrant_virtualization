# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-22.04-arm64" # replace if necessary

  # Database credentials
  db_root_password = "your_root_password"
  db_name = "universidad"
  db_host = "192.168.100.6"
  app_dir = "/home/vagrant/app"
  app_host = "192.168.100.4"

  # Provisioning method (choose between 'ansible' or 'shell')
  provisioning_method = "ansible" # Change to "ansible" to use Ansible provisioning

  # Definition of the database VM
  config.vm.define :db do |db|
    db.vm.network :private_network, ip: db_host
    db.vm.hostname = "db"

    if provisioning_method == "ansible"
      db.vm.provision "ansible" do |ansible|
        ansible.playbook = "provision.yml"
        ansible.extra_vars = {
          db_root_password: db_root_password,
          db_name: db_name,
          app_host: app_host
        }
      end
    elsif provisioning_method == "shell"
      db.vm.provision "shell", inline: <<-SHELL
        #!/bin/bash
        export DB_ROOT_PASSWORD="#{db_root_password}"
        export DB_NAME="#{db_name}"
        export APP_HOST="#{app_host}"
        bash /vagrant/provision.sh
      SHELL
    end
  end

  # Definition of the FastAPI application VM
  config.vm.define :server do |server|
    server.vm.network :private_network, ip: app_host
    server.vm.hostname = "server"
    server.vm.network "forwarded_port", guest: 5500, host: 5500 

    if provisioning_method == "ansible"
      server.vm.provision "ansible" do |ansible|
        ansible.playbook = "provision.yml"
        ansible.extra_vars = {
          db_host: db_host,
          app_dir: app_dir,
          db_root_password: db_root_password,
          db_name: db_name
        }
      end
    elsif provisioning_method == "shell"
      server.vm.provision "shell", inline: <<-SHELL
        #!/bin/bash
        export DB_HOST="#{db_host}"
        export APP_DIR="#{app_dir}"
        export DB_ROOT_PASSWORD="#{db_root_password}"
        export DB_NAME="#{db_name}"
        bash /vagrant/provision.sh
      SHELL
    end
  end

  # Replace if necessary
  config.vm.provider "vmware_desktop" do |v|
    v.memory = 2048           # Allocate 2GB of RAM
    v.cpus = 2                # Allocate 2 CPUs
    v.gui = true
  end
end
