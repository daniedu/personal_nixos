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
    inputs.vicinae.homeManagerModules.default
    ./wm/hyprland.nix
    ./text/kitty.nix
    ./text/nixvim.nix
  ];

  home.username    = "work";
  home.homeDirectory = "/home/work";
  home.stateVersion  = "25.11";

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_add_path ~/.local/bin
      starship init fish | source
      fastfetch
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
        format = ''[](color_orange)$os$username[](bg:color_yellow fg:color_orange)$directory[](fg:color_yellow bg:color_aqua)$git_branch$git_status[](fg:color_aqua bg:color_blue)$c$cpp$rust$golang$nodejs$bun$php$java$kotlin$haskell$python[](fg:color_blue bg:color_bg3)$docker_context$conda$pixi[](fg:color_bg3 bg:color_bg1)$time[ ](fg:color_bg1)$line_break$character'';

        palette = lib.mkForce "gruvbox_dark";

        palettes = {
          gruvbox_dark = {
            color_fg0 = "#fbf1c7";
            color_bg1 = "#3c3836";
            color_bg3 = "#665c54";
            color_blue = "#458588";
            color_aqua = "#689d6a";
            color_green = "#98971a";
            color_orange = "#d65d0e";
            color_purple = "#b16286";
            color_red = "#cc241d";
            color_yellow = "#d79921";
          };
        };

        os = {
          disabled = false;
          style = "bg:color_orange fg:color_fg0";
          symbols = {
            NixOS = "";
            Windows = "󰍲";
            Ubuntu = "󰕈";
            SUSE = "";
            Raspbian = "󰐿";
            Mint = "󰣭";
            Macos = "󰀵";
            Manjaro = "";
            Linux = "󰌽";
            Gentoo = "󰣨";
            Fedora = "󰣛";
            Alpine = "";
            Amazon = "";
            Android = "";
            AOSC = "";
            Arch = "󰣇";
            Artix = "󰣇";
            EndeavourOS = "";
            CentOS = "";
            Debian = "󰣚";
            Redhat = "󱄛";
            RedHatEnterprise = "󱄛";
            Pop = "";
          };
        };

        username = {
          show_always = true;
          style_user = "bg:color_orange fg:color_fg0";
          style_root = "bg:color_orange fg:color_fg0";
          format = "[ $user ]($style)";
        };

        directory = {
          style = "fg:color_fg0 bg:color_yellow";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = " ";
            "Music" = "󰝚 ";
            "Pictures" = " ";
            "Developer" = "󰲋 ";
          };
        };

        git_branch = {
          symbol = "";
          style = "bg:color_aqua";
          format = "[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)";
        };

        git_status = {
          style = "bg:color_aqua";
          format = "[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)";
        };

        c         = { symbol = " "; style = "bg:color_blue"; format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)"; };
        cpp       = { symbol = " "; style = "bg:color_blue"; format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)"; };
        rust      = { symbol = "";  style = "bg:color_blue"; format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)"; };
        golang    = { symbol = "";  style = "bg:color_blue"; format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)"; };
        nodejs    = { symbol = "";  style = "bg:color_blue"; format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)"; };
        bun       = { symbol = "";  style = "bg:color_blue"; format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)"; };
        php       = { symbol = "";  style = "bg:color_blue"; format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)"; };
        java      = { symbol = "";  style = "bg:color_blue"; format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)"; };
        kotlin    = { symbol = "";  style = "bg:color_blue"; format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)"; };
        haskell   = { symbol = "";  style = "bg:color_blue"; format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)"; };
        python    = { symbol = "";  style = "bg:color_blue"; format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)"; };

        docker_context = {
          symbol = "";
          style = "bg:color_bg3";
          format = "[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)";
        };

        conda = {
          style = "bg:color_bg3";
          format = "[[ $symbol( $environment) ](fg:#83a598 bg:color_bg3)]($style)";
        };

        pixi = {
          style = "bg:color_bg3";
          format = "[[ $symbol( $version)( $environment) ](fg:color_fg0 bg:color_bg3)]($style)";
        };

        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:color_bg1";
          format = "[[  $time ](fg:color_fg0 bg:color_bg1)]($style)";
        };

        line_break.disabled = false;

        character = {
          disabled = false;
          success_symbol = "[](bold fg:color_green)";
          error_symbol = "[](bold fg:color_red)";
          vimcmd_symbol = "[](bold fg:color_green)";
          vimcmd_replace_one_symbol = "[](bold fg:color_purple)";
          vimcmd_replace_symbol = "[](bold fg:color_purple)";
          vimcmd_visual_symbol = "[](bold fg:color_yellow)";
        };
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

    swaynotificationcenter
    playerctl

    nil
    lazygit

    wlr-which-key
    steam-run
    fastfetch
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
            cmd: "systemctl reboot"
          - key: "o"
            desc: "Power Off"
            cmd: "systemctl poweroff"
  '';

  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };
    settings = {
      close_on_focus_loss = true;
      consider_preedit = true;
      pop_to_root_on_close = true;
      font = {
        normal = {
          size = 12;
          family = "JetBrainsMono Nerd Font";
        };
      };
      launcher_window = {
        opacity = lib.mkForce 1.0;
      };
    };
    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      nix
    ];
  };

  fonts.fontconfig.enable = true;

  xdg.userDirs = {
    enable     = true;
    createDirectories = true;
  };
}
