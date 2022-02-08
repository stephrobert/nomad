# -*- mode: ruby -*-
# vi: set ft=ruby :

base_ip_str = "10.240.0.1"
number_nodes = 2
mem_node = 1024

Vagrant.configure(2) do |config|
  (1..number_nodes).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.box = "generic/ubuntu1804" # 18.04 LTS
      node.vm.hostname = "node-#{i}"
      # Expose the nomad api and ui to the host
      node.vm.network "forwarded_port", guest: 4646, host: 4646, auto_correct: true, host_ip: "127.0.0.1"
      node.vm.network "forwarded_port", guest: 80, host: 80, auto_correct: true, host_ip: "127.0.0.1"
      node.vm.network "private_network", ip: "#{base_ip_str}#{i}"
      node.vm.provider "libvirt" do |lv|
        lv.cpus = 1
        lv.memory = mem_node
      end
      node.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbooks/provision.yml"
      end
    end
  end
end
