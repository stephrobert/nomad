# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|

base_ip_str = "10.240.0.1"
  number_masters = 1 # Number of master nodes kubernetes
  number_workers = 2 # Number of workers nodes kubernetes
  cpu = 1
  mem = 1024
  config.vm.box = "generic/ubuntu2004" # Image for all installations

# Compute nodes
  number_machines = number_masters + number_workers

  nodes = []
  (0..number_workers).each do |i|
    case i
      when 0
        nodes[i] = {
          "name" => "master#{i + 1}",
          "ip" => "#{base_ip_str}#{i}"
        }
      when 1..number_workers
        nodes[i] = {
          "name" => "worker#{i }",
          "ip" => "#{base_ip_str}#{i}"
        }
    end
  end

  nodes.each do |node|
    config.vm.define node["name"] do |machine|
      machine.vm.hostname = node["name"]
      machine.vm.network "private_network", ip: node["ip"]
      machine.vm.synced_folder '.', '/vagrant', disabled: true
      if (node["name"] =~ /master/)
        machine.vm.network "forwarded_port", guest: 4646, host: 4646, auto_correct: true, host_ip: "127.0.0.1"
        machine.vm.network "forwarded_port", guest: 8500, host: 8500, auto_correct: true, host_ip: "127.0.0.1"
      else
        machine.vm.network "forwarded_port", guest: 80, host: 80, auto_correct: true, host_ip: "127.0.0.1"
      end
      machine.vm.provider "libvirt" do |lv|
        lv.cpus = cpu
        lv.memory = mem
      end
      machine.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbooks/provision.yml"
        ansible.groups = {
          "master" => ["master1"],
          "workers" => ["worker[1:#{number_workers}]"],
          "nomad:children" => ["master", "workers"],
        }
      end
    end
  end
end
