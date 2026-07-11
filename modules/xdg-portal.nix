{ pkgs, lib, ... }: {
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
config = {
    common = {
      default = [ "gtk" ];
    };
    hyprland = {
      default = [ "hyprland" "gtk" ];
    };
    mango = {
      default = lib.mkForce [ "wlr" "gtk" ];
    };
    labwc = {
      default = [ "wlr" "gtk" ];
    };
    niri = {
      default = [ "wlr" "gtk" ];
    };
  };
  };
  services.dbus.enable = true;
  services.gvfs.enable = true;
}
