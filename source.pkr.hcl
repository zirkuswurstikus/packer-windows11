packer {
  required_plugins {
    hyperv = {
      source  = "github.com/hashicorp/hyperv"
      version = "~> 1"
    }
    windows-update = {
      version = "0.15.0"
      source = "github.com/rgl/windows-update"
    }
  }
}

// TODO: use ./scripts/*
// TODO: templating for Autounattend.xml
source "hyperv-iso" "hyperv" {
  boot_command                      = ["a<wait2>a<wait2>a<wait2>a<wait2>a"]
  boot_wait                         = "2s"
  cd_files                          = [
                                      "./ressources/configs/autounattend.xml",
                                      "./ressources/configs/autounattend_sysprep.xml",
									                    "./ressources/scripts/Enable-Winrm.ps1"
                                    ]
  communicator                      = "winrm"
  configuration_version             = "9.0" //"10.0"
  cpus                              = "${var.cpus}"
  disk_size                         = "${var.disk_size}"
  enable_dynamic_memory             = false
  enable_mac_spoofing               = true
  enable_secure_boot                = true
  enable_tpm                        = true
  enable_virtualization_extensions  = true
  generation                        = "2"
  guest_additions_mode              = "disable"
  iso_checksum                      = "${var.iso_checksum}"
  iso_url                           = "${var.iso_url}"
  secondary_iso_images				      = ["../common/updates/wsusoffline/iso/wsusoffline-w100-x64.iso"] //[E:\] if removed the path for cd_files should be changed back to e: 
  memory                            = "${var.memory}"
  //shutdown_command                  = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_command                  = "C:\\Windows\\system32\\Sysprep\\sysprep.exe /generalize /oobe /shutdown /unattend:F:\\autounattend_sysprep.xml"  
  shutdown_timeout                  = "60m"
  switch_name                       = "Default Switch"
  vm_name                           = "${var.vm_name}"
  winrm_password                    = "vagrant"
  winrm_username                    = "vagrant"
  winrm_timeout                     = "6h"
  disable_shutdown					        = false // FOR DEBUGGING
  skip_export						            = false // no .box, keep vhd(x)
  output_directory					        = "../out"
}

build {
  sources = ["source.hyperv-iso.hyperv"]
  provisioner "windows-update" {}
  provisioner "powershell" {
    scripts = ["ressources/scripts/Cleanup-Windows.ps1"]
  }

  post-processor "vagrant" {
    keep_input_artifact  = false	// DEFAULT false
    output               = "WINDOWS_11_ENT_BASE_{{ .Provider }}.box"
    vagrantfile_template = "ressources/configs/WINDOWS_11_ENT_BASE.vagrantfile.template"
  }
}
