{ ... }: {
  services.displayManager.ly.enable     = true;
  services.displayManager.ly.settings = {
    xinitrc = null;
    # Remember last desktop+user so mango stays preselected
    # (ly has no defaultSession/sort-order key; defaultSession only affects GDM/SDDM/LightDM).
    save = true;
    load = true;
  };
  services.flatpak.enable               = true;
}
