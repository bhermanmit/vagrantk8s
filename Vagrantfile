# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |v|
    v.memory = 1024
    v.cpus = 1
  end

  config.vm.define :control do |control|
    control.vm.box = "bento/ubuntu-22.04"
    control.vm.hostname = "control"
    control.vm.network :private_network, ip: "10.0.0.10"
  end

  %w{compute1 compute2}.each_with_index do |name, i|
    config.vm.define name do |compute|
      compute.vm.box = "bento/ubuntu-22.04"
      compute.vm.hostname = name
      compute.vm.network :private_network, ip: "10.0.0.#{i + 11}"
    end
  end

end
