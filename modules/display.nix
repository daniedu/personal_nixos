{ pkgs, ... }: {
  services.xserver.enable               = true;
  services.displayManager.ly.enable     = true;
  services.displayManager.ly.settings = {
    xinitrc = null;
  };
  services.displayManager.sessionPackages = [ pkgs.niri ];
  services.flatpak.enable               = true;
  services.xserver.xkb = { layout = "us"; variant = ""; };
  
  services.displayManager.sddm.settings.Theme.CursorTheme = "Bibata-Modern-Ice";
}
