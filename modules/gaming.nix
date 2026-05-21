{ pkgs, ... }: {
  programs.steam = {
    enable                     = true;
    remotePlay.openFirewall    = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable    = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];

    gamescopeSession.args = [
        "-W 3460"
        "-H 2160"
        "-f" # Force Fullscreen immediately
      ];
  };

  programs.gamescope = {
    enable      = true;
    capSysNice  = true;
  };

  programs.gamemode.enable = true;
  
  hardware.xone.enable = true;
  
  services.displayManager.sessionPackages = [
    (pkgs.writeTextFile {
      name = "steam-direct-session";
      destination = "/share/xsessions/steam-direct.desktop"; # Using X11 session for older Intel drivers
      text = ''
        [Desktop Entry]
        Name=Steam Big Picture Mode
        Comment=Boot directly into Steam without a heavy desktop environment
        Exec=unclutter -idle 1 & steam -bigpicture
        Type=Application
      '';
    })
  ];
}
