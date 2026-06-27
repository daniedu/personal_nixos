{ pkgs, ... }: {
  programs.steam = {
    enable                     = true;
    remotePlay.openFirewall    = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable    = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  programs.gamescope = {
    enable      = true;
    capSysNice  = true;
  };

  programs.gamemode.enable = true;

  hardware.xone.enable = true;

  # environment.systemPackages = with pkgs; [ es-de ];
  # services.displayManager.sessionPackages = [ es-de-session ];
}
