# Home-Manager configuration for the "work" user
{ pkgs, inputs, lib, config, ... }: {
  imports = [
    inputs.noctalia.homeModules.default
    ./wm/noctalia.nix
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

    wlr-which-key
  ];

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
