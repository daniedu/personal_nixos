{ pkgs, ... }: {
  programs.steam = {
    enable                     = true;
    remotePlay.openFirewall    = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable    = false;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];

  };

  programs.gamescope = {
    enable      = false;
    capSysNice  = true;
  };

  programs.gamemode.enable = true;
  
  hardware.xone.enable = true;
  
  services.displayManager.sessionPackages = let
    # 1. Create the actual desktop definition file
    steamDesktopFile = pkgs.writeTextFile {
      name = "steam-direct-x11-file";
      destination = "/share/xsessions/steam-direct.desktop";
      text = ''
        [Desktop Entry]
        Name=Steam Big Picture
        Comment=Launch Steam directly using native hardware OpenGL acceleration
        Exec=steam -bigpicture
        Type=Application
      '';
    };
  in [
    # 2. Wrap it with the metadata NixOS requires to pass validation
    (pkgs.symlinkJoin {
      name = "steam-direct-x11";
      paths = [ steamDesktopFile ];
      passthru.providedSessions = [ "steam-direct" ];
    })
  ];
}
