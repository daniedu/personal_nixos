# Home-Manager configuration for the "work" user
{ pkgs, inputs, lib, config, ... }:
let
  opencode-version = "1.14.48";
  opencode-src = pkgs.fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${opencode-version}/opencode-linux-x64.tar.gz";
    sha256 = "10mggfk9pncvdw4b0c41cv3p9dsrxwmpw4s9wrxw3yaa0zg2aqfh";
  };
  opencode-bin = pkgs.runCommandLocal "opencode-${opencode-version}" { } ''
    mkdir -p $out/bin
    tar -xzf ${opencode-src} -C $out/bin opencode
    chmod +x $out/bin/opencode
  '';
in {
  imports = [
    ./wm/waybar.nix
    ./wm/hyprland.nix
    ./text/kitty.nix
    ./text/nixvim.nix
  ];

  home.username    = "work";
  home.homeDirectory = "/home/work";
  home.stateVersion  = "25.11";

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_add_path ~/.local/bin
      starship init fish | source
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold #ebbcba)";
        error_symbol = "[➜](bold #eb6f92)";
      };
      directory = {
        style = "bold #9ccfd8";
        truncate_to_repo = true;
        truncation_length = 3;
      };
      git_branch = {
        symbol = " ";
        style = "bold #f6c177";
      };
      php.disabled = true;
      nodejs.disabled = true;
      python.disabled = true;
      lua.disabled = true;
    };
  };

  programs.waybar.enable = true;

  programs.vscode = {
    enable  = true;
    package = pkgs.vscode-fhs;
  };

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    candy-icons

    hyprshot
    grim
    slurp
    wl-clipboard

    onlyoffice-desktopeditors
    hunspell
    hunspellDicts.en_US
    hunspellDicts.es_CO

    pavucontrol
    btop
    ripgrep
    fd
    tree

    nil
    lazygit

    wofi
    wlr-which-key
    steam-run
  ];

  home.file.".local/bin/opencode" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      exec ${pkgs.steam-run}/bin/steam-run ${opencode-bin}/bin/opencode "$@"
    '';
  };

  home.file.".config/wlr-which-key/config.yaml".text = ''
    font: "JetBrainsMono Nerd Font 12"
    background: "#191724d0"
    color: "#e0def4"
    border: "#ebbcba"
    separator: " ➜ "

    menu:
      - key: "s"
        desc: "Screenshot (Hyprshot)"
        submenu:
          - key: "s"
            desc: "Select Region"
            cmd: "hyprshot -m region"
          - key: "f"
            desc: "Full Screen (Monitor)"
            cmd: "hyprshot -m output"
          - key: "w"
            desc: "Active Window"
            cmd: "hyprshot -m window"
          - key: "c"
            desc: "Region to Clipboard Only"
            cmd: "hyprshot -m region --clipboard-only"
      - key: "p"
        desc: "Power"
        submenu:
          - key: "r"
            desc: "Reboot"
            cmd: "reboot"
          - key: "o"
            desc: "Power Off"
            cmd: "poweroff"
  '';

  fonts.fontconfig.enable = true;

  xdg.userDirs = {
    enable     = true;
    createDirectories = true;
  };
}
