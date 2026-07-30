{ pkgs, ... }:
let
  uriSchemes = pkgs.runCommandLocal "x-scheme-handler-mime" { } ''
    mkdir -p $out/share/mime/packages
    cat > $out/share/mime/packages/x-scheme-handler.xml << EOF
    <?xml version="1.0"?>
    <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
      <mime-type type="x-scheme-handler/http">
        <comment>HTTP URL</comment>
        <sub-class-of type="text/uri-list"/>
      </mime-type>
      <mime-type type="x-scheme-handler/https">
        <comment>HTTPS URL</comment>
        <sub-class-of type="x-scheme-handler/http"/>
      </mime-type>
      <mime-type type="x-scheme-handler/about">
        <comment>About URL</comment>
        <sub-class-of type="text/uri-list"/>
      </mime-type>
      <mime-type type="x-scheme-handler/unknown">
        <comment>Unknown URL</comment>
        <sub-class-of type="text/uri-list"/>
      </mime-type>
      <mime-type type="x-scheme-handler/terminal">
        <comment>Terminal URL</comment>
        <sub-class-of type="text/uri-list"/>
      </mime-type>
    </mime-info>
    EOF
    # Ensure mime.cache is regenerated
    ${pkgs.shared-mime-info}/bin/update-mime-database $out/share/mime
  '';
in {
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config = {
      common.default = [ "gtk" ];
      mango.default = [ "wlr" "gtk" ];
    };
  };

  services.dbus.enable = true;
  services.gvfs.enable = true;

  environment.systemPackages = [ uriSchemes ];

  # Flatpak ships a stub mime.cache that shadows the real one and breaks
  # Chromium's MIME detection. Override it with a symlink to the system cache.
  systemd.tmpfiles.settings."10-xdg-portal" = {
    "/var/lib/flatpak/exports/share/mime/mime.cache".L = {
      argument = "/run/current-system/sw/share/mime/mime.cache";
    };
  };
}
