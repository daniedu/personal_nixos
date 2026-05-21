{ pkgs, ... }: {
  hardware.opentabletdriver.enable = true;
  hardware.uinput.enable = true;

  # boot.kernelModules = [ "uinput" ];
  # boot.blacklistedKernelModules = [ "wacom" "hid_uclogic" ];

  # services.udev.extraRules = ''
  #   KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
  # '';
}
