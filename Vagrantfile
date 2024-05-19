# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  config.vm.box = "WINDOWS_11_ENT_BASE"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # config.vm.network "private_network", type: "dhcp"

  config.vm.provider "hyperv" do |hv|
    hv.memory = "2048"
    hv.cpus = "2"
    hv.vmname = "WINDOWS_11_ENT_BASE"
  end

  config.vm.provision "shell", privileged: "true", inline: <<-'POWERSHELL'
    Write-Output ">>> Nothing to do."
  POWERSHELL
  
end
