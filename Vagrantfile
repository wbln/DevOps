# Configurations
ram = 8192          #ram in mb
# storage = 60        #hdd size in Gb for vm
Hub_port = 8081
YouTrack_port = 8082
UpSource_port = 8083
TeamCity_port = 8084
Portainer_port = 8090


Vagrant.configure("2") do |config|
    config.vm.box = "archlinux/archlinux"
    config.vm.hostname = "jb"

    config.vm.network :forwarded_port, guest: 22, host: 15022, id: 'ssh'
    config.vm.network :forwarded_port, guest: "#{Hub_port}", host: 8810, id: 'Hub'
    config.vm.network :forwarded_port, guest: "#{YouTrack_port}", host: 8820, id: 'YouTrack'
    config.vm.network :forwarded_port, guest: "#{UpSource_port}", host: 8830, id: 'UpSource'
    config.vm.network :forwarded_port, guest: "#{TeamCity_port}", host: 8840, id: 'TeamCity'
    config.vm.network :forwarded_port, guest: "#{Portainer_port}", host: 8890, id: 'Portainer'

    config.vm.provider "virtualbox" do |v|
      v.name = "jb"
      v.customize ["modifyvm", :id, "--memory", "#{ram}"]
      v.customize ["modifyvm", :id, "--usb", "off"]
      v.customize ["modifyvm", :id, "--usbehci", "off"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    # config.disksize.size = "#{storage}GB"
    config.vm.provision "shell", privileged:false, inline: <<-SHELL
    bash /vagrant/run-docker.sh "#{Hub_port}" "#{YouTrack_port}" "#{UpSource_port}" "#{TeamCity_port}" "#{Portainer_port}"
    SHELL
end
