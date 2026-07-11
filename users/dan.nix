{ pkgs, inputs, lib, config, ... }: {
  imports = [
    inputs.mangowm.hmModules.mango
    inputs.nixvim.homeModules.nixvim
    inputs.vicinae.homeManagerModules.default
    inputs.niri.homeModules.niri
    ./shell/fish.nix
    ./shell/starship.nix
    ./shell/zoxide.nix
    ./shell/tmux.nix

    ./text/kitty.nix
    ./text/nixvim.nix
    ./text/vscode.nix
    ./text/emacs.nix
    # ./text/zed.nix (disabled — no Vulkan support)
    
    ./wm/hyprland.nix
    ./wm/mangowm.nix
    ./wm/labwc.nix
    ./wm/niri.nix
    ./wm/waybar.nix
    # ./wm/noctalia.nix
    ./services/vicinae.nix
    ./services/wlr-which-key.nix
    
    ./launchers/opencode.nix
    ./programs/direnv.nix

    ./packages.nix
  ];

  home.username    = "dan";
  home.homeDirectory = "/home/work";
  home.stateVersion  = "25.11";
  programs.retroarch = {
    enable = true;
    cores = {
      mgba.enable = true;
      snes9x.enable = true;
      fbneo.enable = true;
      fceumm.enable = true;
      melonds.enable = true;
      # Sega Saturn & Dreamcast
      beetle-saturn.enable = true;
      flycast.enable = true;
    };
  };


  gtk = {
    enable = true;
    gtk4.theme = null;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };
  
  home.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };

  fonts.fontconfig.enable = true;

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = "helium.desktop";
    "x-scheme-handler/https" = "helium.desktop";
    "x-scheme-handler/about" = "helium.desktop";
    "x-scheme-handler/unknown" = "helium.desktop";
    "text/html" = "helium.desktop";
    "application/xhtml+xml" = "helium.desktop";

    "x-scheme-handler/terminal" = "kitty.desktop";

    "application/pdf" = "org.gnome.Evince.desktop";

    "image/bmp" = "org.gnome.eog.desktop";
    "image/gif" = "org.gnome.eog.desktop";
    "image/jpeg" = "org.gnome.eog.desktop";
    "image/png" = "org.gnome.eog.desktop";
    "image/svg+xml" = "org.gnome.eog.desktop";
    "image/tiff" = "org.gnome.eog.desktop";
    "image/webp" = "org.gnome.eog.desktop";

    "video/mp4" = "mpv.desktop";
    "video/mpeg" = "mpv.desktop";
    "video/ogg" = "mpv.desktop";
    "video/webm" = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";
    "video/quicktime" = "mpv.desktop";

    "audio/mpeg" = "mpv.desktop";
    "audio/ogg" = "mpv.desktop";
    "audio/flac" = "mpv.desktop";
    "audio/wav" = "mpv.desktop";

    "text/plain" = "code.desktop";
    "text/markdown" = "code.desktop";
    "application/json" = "code.desktop";

    "inode/directory" = "org.gnome.Nautilus.desktop";
  };

  xdg.userDirs = {
    enable     = true;
    createDirectories = true;
  };
}
