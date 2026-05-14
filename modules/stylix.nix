{ config, pkgs, ... }: {
  stylix = {
    enable     = true;
    autoEnable = true;
    targets = {
      gnome.enable = false;
    };

    base16Scheme = ../assets/gruvbox-dark-hard.yaml;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name    = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name    = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name    = "Noto Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name    = "Noto Color Emoji";
      };
      sizes = {
        applications = 11;
        terminal     = 11;
        desktop      = 11;
        popups       = 11;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name    = "Bibata-Modern-Classic";
      size    = 24;
    };

    opacity = {
      terminal     = 0.90;
      applications = 1.0;
      popups       = 0.90;
      desktop      = 1.0;
    };
  };
}
