{ ... }: {
  services.displayManager.ly.enable     = true;
  services.displayManager.ly.settings = {
    xinitrc = null;
  };
  services.flatpak.enable               = true;
}
