# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |v|
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.define :control do |control|
    control.vm.box = "bento/ubuntu-22.04"
    control.vm.hostname = "control"
    control.vm.network :private_network, ip: "10.0.0.10"
    control.vm.provision :shell, privileged: false, inline: $provision_control_node
  end

  %w{compute1 compute2}.each_with_index do |name, i|
    config.vm.define name do |compute|
      compute.vm.box = "bento/ubuntu-22.04"
      compute.vm.hostname = name
      compute.vm.network :private_network, ip: "10.0.0.#{i + 11}"
      compute.vm.provision :shell, privileged: false, inline: $provision_compute_node
    end
  end

end

$provision_control_node = <<-CONTROL
  set -x
  JOIN_FILE=/vagrant/join.key
  rm -rf $JOIN_FILE
  sudo -- sh -c "echo 10.0.0.10 control >> /etc/hosts"
  sudo -- sh -c "echo 10.0.0.11 compute1 >> /etc/hosts"
  sudo -- sh -c "echo 10.0.0.12 compute2 >> /etc/hosts"
  sudo apt update && sudo apt upgrade -y && sudo apt install -y jq
  sudo snap install microk8s --classic
  sudo usermod -a -G microk8s vagrant
  sudo chown -f -R vagrant ~/.kube
  sg microk8s -c "microk8s status --wait-ready"
  sg microk8s -c "microk8s enable dashboard dns registry"
  sg microk8s -c "microk8s add-node --token-ttl=3600 --format=json | jq -c '.urls[1]' | sed 's/\\"//g'" >> $JOIN_FILE
CONTROL

$provision_compute_node = <<-COMPUTE
  set -x
  JOIN_FILE=/vagrant/join.key
  sudo -- sh -c "echo 10.0.0.10 control >> /etc/hosts"
  sudo -- sh -c "echo 10.0.0.11 compute1 >> /etc/hosts"
  sudo -- sh -c "echo 10.0.0.12 compute2 >> /etc/hosts"
  sudo apt update && sudo apt upgrade -y
  sudo snap install microk8s --classic
  sudo usermod -a -G microk8s vagrant
  sudo chown -f -R vagrant ~/.kube
  sg microk8s -c "microk8s status --wait-ready"
  sg microk8s -c "microk8s join $(cat ${JOIN_FILE}) --worker --skip-verify"
COMPUTE
