{ pkgs, lib, ... }: {
  services.xserver.enable               = true;
  services.displayManager.ly.enable     = true;
  services.displayManager.sessionPackages = [ pkgs.labwc pkgs.niri ];
  services.flatpak.enable               = true;
  services.xserver.xkb = { layout = "us"; variant = ""; };
  programs.hyprland.enable              = true;
  services.displayManager.sddm.settings.Theme.CursorTheme = "Bibata-Modern-Ice";

  systemd.user.services.krita-flatpak-fs = {
    enable = true;
    description = "Set Krita Flatpak filesystem override for color schemes";
    wantedBy = [ "default.target" ];
    after = [ "flatpak-session-helper.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.flatpak}/bin/flatpak override --user org.kde.krita --filesystem=%h/.local/share/color-schemes:ro";
    };
  };
}
