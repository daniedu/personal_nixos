{ config, lib, pkgs, ... }: {
  # Portable SSD support for Intel -> AMD APU (8600G Phoenix RDNA3 760M gfx1103)
  # Enables amdgpu firmware + microcode so same SSD boots on both machines.
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # KVM: load correct hypervisor module on each host
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];

  # Initrd: merge Intel (ehci/ata_piix) + AMD (xhci/ahci/nvme/amdgpu) for portable SSD
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "ehci_pci"
    "ata_piix"
  ];
  boot.initrd.kernelModules = [ "amdgpu" ];
}
