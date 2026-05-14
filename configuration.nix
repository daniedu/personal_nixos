# Main NixOS system configuration
{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ─────────────────────────────────────────────────────────────────────────
  # STYLIX — wallpaper-driven theming for the whole system
  # ─────────────────────────────────────────────────────────────────────────
  # Stylix extracts a Base16 colour palette automatically from your wallpaper.
  # All 16 slots are labelled base00–base0F. Their roles in a dark scheme:
  #
  #   base00 — background              base08 — red   / variables / errors
  #   base01 — lighter background      base09 — orange / integers / booleans
  #   base02 — selection background    base0A — yellow / classes / bold
  #   base03 — comments / disabled     base0B — green  / strings
  #   base04 — dark foreground         base0C — cyan   / support / escapes
  #   base05 — default foreground      base0D — blue   / functions / methods
  #   base06 — light foreground        base0E — magenta / keywords / storage
  #   base07 — lightest (white)        base0F — deprecated / embedded lang
  #
  # To override a colour: uncomment the relevant line inside `override = {}`
  # and set it to a 6-digit hex value (no leading #).
#   xdg.userDirs.setSessionVariables = false;

  stylix = {
    enable     = true;
    autoEnable = true;
    targets = {
      gnome.enable = false;
    };

    base16Scheme = ./assets/gruvbox-dark-hard.yaml;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name    = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name    = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name    = "Noto Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name    = "Noto Color Emoji";
      };
      sizes = {
        applications = 11;
        terminal     = 11;
        desktop      = 11;
        popups       = 11;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name    = "Bibata-Modern-Classic";
      size    = 24;
    };

    opacity = {
      terminal     = 0.90;
      applications = 1.0;
      popups       = 0.90;
      desktop      = 1.0;
    };
  };

  # ─────────────────────────────────────────────────────────────────────────
  # BOOT
  # ─────────────────────────────────────────────────────────────────────────
  boot.loader.grub = {
    enable      = true;
    device      = "/dev/sda";
    useOSProber = true;
  };

  # Use the latest kernel for best hardware/driver support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ─────────────────────────────────────────────────────────────────────────
  # NETWORK
  # ─────────────────────────────────────────────────────────────────────────
  networking.hostName            = "dan";
  networking.networkmanager.enable = true;

  # ─────────────────────────────────────────────────────────────────────────
  # LOCALE / TIME
  # ─────────────────────────────────────────────────────────────────────────
  time.timeZone      = "America/Bogota";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "es_CO.UTF-8";
    LC_IDENTIFICATION = "es_CO.UTF-8";
    LC_MEASUREMENT    = "es_CO.UTF-8";
    LC_MONETARY       = "es_CO.UTF-8";
    LC_NAME           = "es_CO.UTF-8";
    LC_NUMERIC        = "es_CO.UTF-8";
    LC_PAPER          = "es_CO.UTF-8";
    LC_TELEPHONE      = "es_CO.UTF-8";
    LC_TIME           = "es_CO.UTF-8";
  };

  # ─────────────────────────────────────────────────────────────────────────
  # GRAPHICS / HARDWARE ACCELERATION
  # ─────────────────────────────────────────────────────────────────────────
  # hardware.graphics replaces hardware.opengl on NixOS ≥ 24.05 / unstable.
  hardware.graphics = {
    enable      = true;
    enable32Bit = true;  # required for Steam and 32-bit games / Wine

    # VA-API / VDPAU drivers for hardware video decoding.
    # ── AMD GPU users: mesa already includes radeonsi — nothing extra needed.
    # ── Intel GPU users: uncomment the intel lines below.
    # ── NVIDIA users: see the NVIDIA block further down.
    extraPackages = with pkgs; [
      # VA-API (hardware video decode for mpv, Firefox, etc.)
      libva              # base VA-API library
      libva-utils        # vainfo tool — run `vainfo` to verify drivers work

      # Mesa Vulkan (AMD/Intel open-source)
      mesa

      # GStreamer VA-API plugin (used by GNOME apps, Nautilus thumbnails, etc.)
      gst_all_1.gst-vaapi

      # ── Intel iGPU (uncomment your generation) ──────────────────────────
      intel-media-driver   # Broadwell (2014) and newer — recommended
      # intel-vaapi-driver   # Haswell and older, or if media-driver misbehaves
      # vpl-gpu-rt           # Intel Arc / 12th-gen+ for hardware AV1/HEVC encode
      # ── AMD dGPU ────────────────────────────────────────────────────────
      # amdvlk               # AMD's official Vulkan driver (alternative to radv)
      # ── NVIDIA ──────────────────────────────────────────────────────────
      # nvidia-vaapi-driver  # third-party VA-API shim for NVIDIA (limited support)
    ];

    # 32-bit VA-API / Vulkan for Steam / Wine / Proton
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa
      # intel-vaapi-driver  # uncomment for Intel 32-bit
    ];
  };

  # ── NVIDIA proprietary driver (uncomment if you have an NVIDIA GPU) ──────
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia = {
  #   modesetting.enable = true;          # required for Wayland
  #   powerManagement.enable = false;     # set true on laptops to fix suspend
  #   open = false;                       # use closed-source driver
  #   nvidiaSettings = true;              # install nvidia-settings GUI
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };

  # ─────────────────────────────────────────────────────────────────────────
  # MULTIMEDIA CODECS
  # ─────────────────────────────────────────────────────────────────────────
  # GStreamer plugin stack — used by GNOME apps, Nautilus, Celluloid, etc.
  environment.systemPackages = with pkgs; [
    # ── GStreamer codec plugins ──────────────────────────────────────────
    gst_all_1.gstreamer          # core
    gst_all_1.gst-plugins-base   # fundamental plugins (ogg, vorbis, theora…)
    gst_all_1.gst-plugins-good   # high-quality: mp4, mkv, opus, flac, png…
    gst_all_1.gst-plugins-bad    # less-polished but useful: av1, webrtc, hls…
    gst_all_1.gst-plugins-ugly   # patent-encumbered: mp3, h264, aac, mpeg…
    gst_all_1.gst-libav          # ffmpeg bridge — covers almost everything else
    gst_all_1.gst-vaapi          # VA-API hardware decode via GStreamer

    # ── ffmpeg (full build with most codecs enabled) ─────────────────────
    ffmpeg-full

    # ── Media players ─────────────────────────────────────────────────────
    mpv          # best hardware-accelerated video player on Linux
    vlc          # familiar GUI player, good codec fallback

    # ── Image / document viewers ─────────────────────────────────────────
    eog          # GNOME image viewer (Eye of GNOME)
    evince       # PDF / document viewer

    # ── Archive tools ────────────────────────────────────────────────────
    file-roller  # GNOME archive manager GUI
    unzip
    p7zip
    unrar

    # ── Bluetooth ─────────────────────────────────────────────────────────
    blueman      # Bluetooth manager GUI

    # ── Printing ─────────────────────────────────────────────────────────
    system-config-printer

    # ── Networking helpers ────────────────────────────────────────────────
    networkmanagerapplet  # nm-applet for tray

    # ── Other system utilities ────────────────────────────────────────────
    vim
    git
    wget
    btop
    # libnotify
    xdg-utils    # xdg-open etc.
    gnome-disk-utility

    # ── Helium browser ────────────────────────────────────────────────────
    inputs.helium.packages.${pkgs.system}.default

    # ── File manager ──────────────────────────────────────────────────────
    nautilus
    
    # ── Cursors ──────────────────────────────────────────────────────
    bibata-cursors

    # ── shell ──────────────────────────────────────────────────────
    starship
  ];

  # ─────────────────────────────────────────────────────────────────────────
  # BLUETOOTH
  # ─────────────────────────────────────────────────────────────────────────
  # hardware.bluetooth = {
  #   enable      = true;
  #   powerOnBoot = true;
  # };
  # services.blueman.enable = true;

  # ─────────────────────────────────────────────────────────────────────────
  # DISPLAY / DESKTOP
  # ─────────────────────────────────────────────────────────────────────────
  services.xserver.enable             = true;
  services.displayManager.ly.enable   = true;
  # services.desktopManager.plasma6.enable = true;
  services.flatpak.enable             = true;

  services.xserver.xkb = { layout = "us"; variant = ""; };

  programs.hyprland.enable = true;
  
  services.displayManager.sddm.settings.Theme.CursorTheme = "Bibata-Modern-Ice";
  # ─────────────────────────────────────────────────────────────────────────
  # AUDIO
  # ─────────────────────────────────────────────────────────────────────────
  services.pulseaudio.enable = false;
  security.rtkit.enable      = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;  # needed for 32-bit games
    pulse.enable      = true;
    jack.enable       = true;
    wireplumber.enable = true;
  };

  # ─────────────────────────────────────────────────────────────────────────
  # PRINTING
  # ─────────────────────────────────────────────────────────────────────────
  services.printing = {
    enable  = true;
    drivers = with pkgs; [
      gutenprint        # broad printer support
      hplip             # HP printers
      # brlaser         # uncomment for Brother laser printers
      # cnijfilter2     # uncomment for Canon inkjet printers
    ];
  };
  services.avahi = {
    enable   = true;
    nssmdns4 = true;    # resolve .local hostnames (mDNS / network printers)
  };

  # ─────────────────────────────────────────────────────────────────────────
  # GAMING — system-level programs & drivers
  # ─────────────────────────────────────────────────────────────────────────
  # Steam is enabled system-wide; the gaming *user* gets launchers & tools
  # in users/gaming.nix.  Work and Lab can also launch Steam if they want.
  programs.steam = {
    enable                     = true;
    remotePlay.openFirewall    = true;   # Steam Remote Play LAN ports
    dedicatedServer.openFirewall = true; # Source dedicated server ports
    gamescopeSession.enable    = true;   # gamescope compositor session
    extraCompatPackages = with pkgs; [ proton-ge-bin ]; # community Proton GE
  };

  programs.gamescope = {
    enable      = true;
    capSysNice  = true;   # allows gamescope to raise its own priority
  };

  # GameMode — automatically boosts CPU/GPU scheduler when games run
  programs.gamemode.enable = true;

  # Xbox controller USB dongle firmware
  hardware.xone.enable = true;
  # Nintendo controller support (Switch Pro, Joy-Cons)
  #   hardware.nintendo-switch-controller.enable = true;

  # ─────────────────────────────────────────────────────────────────────────
  # XDG / PORTAL
  # ─────────────────────────────────────────────────────────────────────────
  # xdg-desktop-portal is needed for screen sharing, file pickers, etc.
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "hyprland"  "gtk" ];
      };
      hyprland = {
        default = [ "hyprland" "gtk" ];
      };
    };
  };

  # ─────────────────────────────────────────────────────────────────────────
  # SECURITY / POLKIT
  # ─────────────────────────────────────────────────────────────────────────
  # lxqt polkit agent gives GUI auth prompts under Hyprland
  security.polkit.enable = true;

  # ─────────────────────────────────────────────────────────────────────────
  # USERS
  # ─────────────────────────────────────────────────────────────────────────
  users.users.work = {
    isNormalUser = true;
    extraGroups  = [ "networkmanager" "wheel" "video" "render" "audio" "gamemode" ];
    shell = pkgs.fish;
  };

  # System-wide enable
  programs.fish.enable = true;
  # users.users.lab = {
  #   isNormalUser = true;
  #   extraGroups  = [ "networkmanager" "video" "render" "audio" ];
  # };

  # users.users.gaming = {
  #   isNormalUser = true;
  #   extraGroups  = [ "networkmanager" "video" "render" "audio" "gamemode" "input" ];
  #   # "input" group allows reading raw input devices (controllers, wheels etc.)
  # };

  nix.settings = {
    extra-substituters = [ "https://vicinae.cachix.org" ];
    extra-trusted-public-keys = [ "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" ];
  };

  nixpkgs.config.allowUnfree = true;
  zramSwap.enable = true;
  system.stateVersion = "25.11";
}
