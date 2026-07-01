{ pkgs, ... }: {
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
    mangowm = {
      default = [ "wlr" "gtk" ];
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
  xdg.mime.defaultApplications = {
    # Web
    "x-scheme-handler/http" = "helium.desktop";
    "x-scheme-handler/https" = "helium.desktop";
    "x-scheme-handler/about" = "helium.desktop";
    "x-scheme-handler/unknown" = "helium.desktop";
    "text/html" = "helium.desktop";
    "application/xhtml+xml" = "helium.desktop";

    # Terminal
    "x-scheme-handler/terminal" = "kitty.desktop";

    # Documents / PDF
    "application/pdf" = "org.gnome.Evince.desktop";
    "application/postscript" = "org.gnome.Evince.desktop";
    "application/vnd.comicbook-rar" = "org.gnome.Evince.desktop";
    "application/vnd.comicbook+zip" = "org.gnome.Evince.desktop";

    # Images
    "image/bmp" = "org.gnome.eog.desktop";
    "image/gif" = "org.gnome.eog.desktop";
    "image/jpeg" = "org.gnome.eog.desktop";
    "image/jpg" = "org.gnome.eog.desktop";
    "image/png" = "org.gnome.eog.desktop";
    "image/svg+xml" = "org.gnome.eog.desktop";
    "image/tiff" = "org.gnome.eog.desktop";
    "image/webp" = "org.gnome.eog.desktop";

    # Video
    "video/mp4" = "mpv.desktop";
    "video/mpeg" = "mpv.desktop";
    "video/ogg" = "mpv.desktop";
    "video/webm" = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";
    "video/x-msvideo" = "mpv.desktop";
    "video/quicktime" = "mpv.desktop";
    "video/x-ms-wmv" = "mpv.desktop";
    "video/x-flv" = "mpv.desktop";
    "application/vnd.apple.mpegurl" = "mpv.desktop";
    "application/x-mpegurl" = "mpv.desktop";

    # Audio
    "audio/mpeg" = "mpv.desktop";
    "audio/ogg" = "mpv.desktop";
    "audio/flac" = "mpv.desktop";
    "audio/wav" = "mpv.desktop";
    "audio/x-wav" = "mpv.desktop";
    "audio/webm" = "mpv.desktop";

    # Text / code
    "text/plain" = "code.desktop";
    "text/x-python" = "code.desktop";
    "text/javascript" = "code.desktop";
    "text/css" = "code.desktop";
    "text/xml" = "code.desktop";
    "text/markdown" = "code.desktop";
    "application/json" = "code.desktop";
    "application/x-yaml" = "code.desktop";
    "application/xml" = "code.desktop";

    # Directories
    "inode/directory" = "org.gnome.Nautilus.desktop";

    # Archives
    "application/zip" = "org.gnome.Nautilus.desktop";
    "application/x-tar" = "org.gnome.Nautilus.desktop";
    "application/gzip" = "org.gnome.FileRoller.desktop";
    "application/x-bzip2" = "org.gnome.FileRoller.desktop";
    "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
    "application/x-rar" = "org.gnome.FileRoller.desktop";
  };
}
