{ pkgs, ... }: {
  services.xserver.enable               = true;
  services.displayManager.ly.enable     = true;
  services.flatpak.enable               = true;
  services.xserver.xkb = { layout = "us"; variant = ""; };
  programs.hyprland.enable              = true;
  services.displayManager.sddm.settings.Theme.CursorTheme = "Bibata-Modern-Ice";
}
