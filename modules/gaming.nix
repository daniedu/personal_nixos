{ pkgs, ... }:

let
  es-de-session = pkgs.runCommand "es-de-session" { } ''
    mkdir -p $out/share/wayland-sessions
    cat > $out/share/wayland-sessions/emulationstation-de.desktop <<EOF
    [Desktop Entry]
    Name=EmulationStation-DE
    Comment=Gaming Frontend
    Exec=${pkgs.emulationstation-de}/bin/emulationstation
    Type=Application
    EOF
  '';
in
{
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

  environment.systemPackages = with pkgs; [ emulationstation-de ];

  services.displayManager.sessionPackages = [ es-de-session ];
}
