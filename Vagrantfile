NUM_WORKER_NODES=2
IP_NW="192.168.1."
IP_START=50

Vagrant.configure("2") do |config|
  config.vm.provision "shell", env: {"IP_NW" => IP_NW, "IP_START" => IP_START, "NUM_WORKER_NODES" => NUM_WORKER_NODES}, inline: <<-SHELL
      apt-get update -y
      echo "$IP_NW$((IP_START)) master-node" >> /etc/hosts
      for i in $(seq $NUM_WORKER_NODES)
      do 
        echo "$IP_NW$((IP_START+i)) worker-node0$i" >> /etc/hosts
      done
  SHELL

  config.vm.box = "bento/ubuntu-22.04"
  config.vm.box_check_update = true

  config.vm.define "master" do |master|
    # master.vm.box = "bento/ubuntu-18.04"
    master.vm.hostname = "master-node"
    master.vm.network "public_network", ip: IP_NW + "#{IP_START}", bridge: "enp4s0"
    master.vm.provider "virtualbox" do |vb|
        vb.memory = 4096
        vb.cpus = 2
    end
    master.vm.provision "shell", path: "scripts/common.sh"
    master.vm.provision "shell", path: "scripts/master.sh", args: IP_NW + "#{IP_START}"
  end

  (1..NUM_WORKER_NODES).each do |i|

  config.vm.define "node0#{i}" do |node|
    node.vm.hostname = "worker-node0#{i}"
    node.vm.network "public_network", ip: IP_NW + "#{IP_START + i}", bridge: "enp4s0"
    node.vm.provider "virtualbox" do |vb|
        vb.memory = 2048
        vb.cpus = 1
    end
    node.vm.provision "shell", path: "scripts/common.sh"
    node.vm.provision "shell", path: "scripts/node.sh"
  end

  end
end 
