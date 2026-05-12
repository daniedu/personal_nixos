# Home-Manager configuration for the "work" user
{ pkgs, inputs, lib, config, ... }:
let
  # This is the lightweight standalone binary (~37MB)
  opencode-working = pkgs.stdenv.mkDerivation {
    pname = "opencode";
    version = "1.14.48";
    
    src = pkgs.fetchurl {
      url = "https://github.com/anomalyco/opencode/releases/download/v1.14.48/opencode-linux-x64.tar.gz";
      sha256 = "10mggfk9pncvdw4b0c41cv3p9dsrxwmpw4s9wrxw3yaa0zg2aqfh"; 
    };
    
    sourceRoot = ".";
    
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib pkgs.zlib pkgs.glibc ];

    # Since it's a tar.gz, Nix will automatically unpack it. 
    # We just need to make sure we copy the right file in installPhase.
    installPhase = ''
      mkdir -p $out/bin
      # The binary inside is usually named 'opencode'
      cp opencode $out/bin/opencode
      chmod +x $out/bin/opencode
    '';
  };
in
{
  imports = [
    inputs.noctalia.homeModules.default
    # Stylix home-manager module is injected automatically by stylix.nixosModules.stylix
  ];

  home.username    = "work";
  home.homeDirectory = "/home/work";
  home.stateVersion  = "25.11";
#   stylix.targets.kde.enable = false;
#   stylix.targets.vscode.enable = true;
# Configuration for user-level (Home Manager)
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24; # Optional
  };
  # ─────────────────────────────────────────────────────────────────────────
  # NOCTALIA — sidebar (left bar) mode
  # ─────────────────────────────────────────────────────────────────────────
  # Noctalia manages ~/.config/noctalia/settings.json as a read-only symlink.
  # After first boot you can also copy live settings with:
  #   noctalia-shell ipc call state all | jq .settings
  programs.noctalia-shell = {
    enable  = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      bar = {
        # Sidebar mode — bar on the left edge.
        # Change to "top" | "bottom" | "right" any time.
        position = "left";

        # backgroundOpacity = 0.85; # 0.0 transparent → 1.0 opaque

        # In vertical (sidebar) mode "left" slots stack at the top,
        # "right" slots stack at the bottom.
        widgets = {
          left = [
            { id = "AppMenu"; }     # launcher button — top of sidebar
            { id = "Workspace"; }   # workspace switcher
          ];
          center = [];
          right = [
            { id = "Tray"; }
            { id = "Volume"; }
            # { id = "Network"; }
            { id = "Clock";
              # Uncomment to customise the vertical clock format:
              # formatVertical = "HH:mm\nddd\nMMM\ndd";
            }
            { id = "ControlCenter"; }  # bottom of sidebar
          ];
        };
      };

      launcher.enable = true;

      # Disable Noctalia's wallpaper setter — Stylix handles the wallpaper
      wallpaper.enabled = true;

      colorSchemes = {
        darkMode         = true;
        # "custom" stops Noctalia overwriting the colours Stylix already set.
        # Change to "Wallpaper" and set wallpaper.enabled = true above if you
        # want Noctalia's own matugen extraction instead.
        predefinedScheme = "Wallpaper";
      };

      ui.fontDefault = lib.mkForce "JetBrainsMono Nerd Font";
    };
  };

  # ─────────────────────────────────────────────────────────────────────────
  # HYPRLAND
  # ─────────────────────────────────────────────────────────────────────────
  wayland.windowManager.hyprland = {
    enable         = true;
    systemd.enable = true;

    settings = {
      "$mod" = "SUPER";

      animations.enabled = false;

      # Noctalia started directly (systemd startup is deprecated upstream)
      "exec-once" = [
        "noctalia-shell"
        "nm-applet --indicator"  # network tray icon
        "blueman-applet"         # bluetooth tray icon
      ];

      bind = [
        # Noctalia launcher (mirrors caelestia's drawer toggle)
        "$mod, SPACE,  exec, noctalia-shell ipc call launcher toggle"
        "$mod, RETURN, exec, kitty"
        "$mod, Q,      killactive,"
        "$mod, M,      exit,"
        "$mod, F,      fullscreen,"
        "$mod, E,      exec, nautilus"

        # Focus movement
        "$mod, h,  movefocus, l"
        "$mod, l,  movefocus, r"
        "$mod, j,  movefocus, u"
        "$mod, k,  movefocus, d"
        
        # Workspace switching
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        # Move window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        "$mod, P, exec, wlr-which-key"
      ];

      general = {
        gaps_in  = 5;
        gaps_out = 10;
        # Borders are transparent by default — Stylix themes via GTK/Qt.
        # Uncomment and set hex values (rgba format) to enable coloured borders:
        # "col.active_border"   = "rgba(7aa2f7ff)"; # base0D — blue
        # "col.inactive_border" = "rgba(2f354988)"; # base02 — selection bg
        "col.active_border"   = lib.mkForce "rgba(00000000)";
        # "col.inactive_border" = lib.mkForce "rgba(00000000)";
        border_size = 2;
        layout      = "dwindle";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size    = 3;
          passes  = 1;
        };
      };

      master.new_status = "master";

      misc = {
        disable_hyprland_logo   = true;
        force_default_wallpaper = 0;
      };

      # Blur Noctalia layer-shell surfaces
      # layerrule = [
        # "blur, bar"
        # "blur, notifications"
        # "blur, system-menu"
        # "blur, osd"
        # "blur, logout_dialog"
        # "ignorealpha 0.2, notifications"
        # "ignorealpha 0.2, system-menu"
        # "ignorealpha 0.5, osd"
        # "ignorealpha 0.5, logout_dialog"
      # ];

      # windowrulev2 = [
      #   "float, class:^(pavucontrol)$"
      #   "float, class:^(nm-connection-editor)$"
      #   "float, class:^(blueman-manager)$"
      #   "float, class:^(system-config-printer)$"
      #   "float, title:^(Open File)$"
      #   "float, title:^(Save As)$"
      #   "float, title:^(Picture-in-Picture)$"
      #   "pin,   title:^(Picture-in-Picture)$"
      # ];
    };
  };

  # ─────────────────────────────────────────────────────────────────────────
  # KITTY — terminal
  # ─────────────────────────────────────────────────────────────────────────
  programs.kitty = {
    enable = true;
    settings = {
      shell = "fish";
      # --- Visuals ---
    window_padding_width = 8; # More breathing room looks more modern
    confirm_os_window_close = 0;
    background_opacity = "0.85";
    dynamic_background_opacity = "yes"; # Allows changing on the fly
    
    # --- Text Rendering ---
    # Makes the font look "thicker" and clearer on high-res monitors
    text_composition_strategy = "platform"; 
    
    # --- Cursor ---
    cursor_shape = "beam"; # Vertical line like an IDE
    cursor_beam_thickness = 1.5;
    cursor_blink_interval = 0; # Static cursor is often less distracting
    
    # --- Tab Bar (The "Nice" Look) ---
    tab_bar_edge = "top"; # Moving it to the top feels more "browser-like"
    tab_bar_style = "slant"; # Powerline is classic, but slant is more unique
    active_tab_font_style = "bold";
    inactive_tab_font_style = "normal";
    
    # --- Terminal Bell ---
    enable_audio_bell = "no"; # Silence is gold
    };
  };

  programs.fish = {
    enable = true;
    # This is the magic line that connects Starship to Fish automatically
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
      # Inserts a blank line between commands for readability
      add_newline = true;

      # Clean, minimal prompt character
      character = {
        success_symbol = "[➜](bold #ebbcba)"; # Rose Pine 'Gold/Rose'
        error_symbol = "[➜](bold #eb6f92)";   # Rose Pine 'Love'
      };

      # Directory style
      directory = {
        style = "bold #9ccfd8"; # Rose Pine 'Foam'
        truncate_to_repo = true;
        truncation_length = 3;
      };

      # Minimal Git status
      git_branch = {
        symbol = " ";
        style = "bold #f6c177";
      };

      # Disable most language modules to keep it fast, 
      # only keep what you use for work
      php.disabled = false;
      nodejs.disabled = false;
      python.disabled = true;
      lua.disabled = true;
    };
  };


  # ─────────────────────────────────────────────────────────────────────────
  # VSCODE
  # ─────────────────────────────────────────────────────────────────────────
  # Stylix generates a Base16 VS Code theme and activates it automatically.
  programs.vscode = {
    enable  = true;
    package = pkgs.vscode-fhs;  # FHS wrapper — best extension compatibility
  };

  # ─────────────────────────────────────────────────────────────────────────
  # PACKAGES
  # ─────────────────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    opencode-working
    # ── Fonts (beyond what Stylix sets system-wide) ───────────────────────
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    candy-icons

    # ── Screenshot tools ─────────────────────────────────────────────────
    hyprshot
    grim
    slurp
    wl-clipboard

    # ── Work / productivity ───────────────────────────────────────────────
    onlyoffice-desktopeditors        # Microsoft-compatible office suite (docx/xlsx/pptx)
    hunspell              # spell checking backend
    hunspellDicts.en_US
    hunspellDicts.es_CO   # Spanish (Colombia) — matches your locale

    # ── Communication ─────────────────────────────────────────────────────
    # discord            # uncomment if you use Discord
    # slack              # uncomment for Slack

    # ── Development ───────────────────────────────────────────────────────
    #     nodejs
    #     python3
    #     cargo

    # ── Misc ──────────────────────────────────────────────────────────────
    pavucontrol         # audio volume control GUI
    btop                # system monitor
    ripgrep
    fd
    tree

    nil
    lazygit
    
    wlr-which-key
  ];


home.file.".config/wlr-which-key/config.yaml".text = ''
  # Theming to match your setup
  font: "JetBrainsMono Nerd Font 12"
  background: "#191724d0" # Rose Pine dark background with transparency
  color: "#e0def4"
  border: "#ebbcba"
  separator: " ➜ "
  
  menu:
    - key: "s"
      desc: "Screenshot (Hyprshot)"
      submenu:
        - key: "s"
          desc: "Select Region"
          # -m region: allows mouse selection
          cmd: "hyprshot -m region"
        - key: "f"
          desc: "Full Screen (Monitor)"
          # -m output: captures the current monitor
          cmd: "hyprshot -m output"
        - key: "w"
          desc: "Active Window"
          # -m window: captures the active window
          cmd: "hyprshot -m window"
        - key: "c"
          desc: "Region to Clipboard Only"
          # --clipboard-only: skips saving a file to disk
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

  # XDG dirs
  xdg.userDirs = {
    enable     = true;
    createDirectories = true;
  };
}
