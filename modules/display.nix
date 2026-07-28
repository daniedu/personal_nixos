{ pkgs, ... }: {
  services.displayManager.ly.enable     = true;
  services.displayManager.ly.settings = {
    xinitrc = null;
  };
  services.flatpak.enable               = true;
  services.displayManager.sddm.settings.Theme.CursorTheme = "Bibata-Modern-Ice";
}
