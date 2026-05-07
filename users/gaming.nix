# Home-Manager configuration for the "gaming" user
# Steam is enabled system-wide in configuration.nix.
#
# This user runs KDE Plasma 6 on X11 instead of Hyprland — much better
# compatibility with old/legacy DirectX games (Touhou, Radio Zonde, etc.)
# and Wine in general. XWayland causes input, fullscreen, and timing issues
# with DX8/DX9-era titles; native X11 via KDE avoids all of that.
#
# Session selection: at the Ly login screen, pick "Plasma (X11)" for gaming.
{ pkgs, config, ... }:

{
  home.username      = "gaming";
  home.homeDirectory = "/home/gaming";
  home.stateVersion  = "25.11";
#   stylix.targets.kde.enable = false;
  # ─────────────────────────────────────────────────────────────────────────
  # KDE / PLASMA SETTINGS
  # ─────────────────────────────────────────────────────────────────────────
  # KDE Plasma is enabled system-wide in configuration.nix
  # (services.desktopManager.plasma6.enable = true).
  # No extra module needed here — the gaming user just logs into
  # the "Plasma (X11)" session at the display manager.


  # ─────────────────────────────────────────────────────────────────────────
  # WINE — X11 native config for best old-game compatibility
  # ─────────────────────────────────────────────────────────────────────────
  # Force Wine to use X11 (not XWayland) when running under KDE X11 session.
  # This is automatic when you log into "Plasma (X11)" rather than Wayland.
  #
  # Per-game Wine tips for old Touhou / doujin games:
  #   - Use Wine Staging (included below) — best DX8/DX9 support
  #   - In Lutris: enable "Enable DXVK" for DX9 games on modern hardware
  #   - For Touhou games specifically: set Wine version to staging, add
  #     "__GL_THREADED_OPTIMIZATIONS=0" to environment if you get GPU glitches
  #   - For window border issues: right-click game in Lutris → Configure →
  #     Runner options → "Windowed (virtual desktop)" and set your resolution

  # ─────────────────────────────────────────────────────────────────────────
  # PACKAGES
  # ─────────────────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    # ── Game launchers ────────────────────────────────────────────────────
    # Steam is system-wide — just launch it from the KDE app menu
    lutris              # open-source launcher — best for old Windows games via Wine
    heroic              # Epic Games Store + GOG native client
    # bottles             # Wine prefix manager with easy per-game isolation

    # ── Proton / Wine ─────────────────────────────────────────────────────
    protonup-qt                    # install Proton-GE builds (better DX9 compat)
    wineWow64Packages.stagingFull    # Wine Staging with 32+64-bit — best for old games
    winetricks                     # vcredist, dxvk, d3dx9, dotnet installs etc.
    dxvk                           # Vulkan-backed Direct3D 9/10/11 translation
    # vkd3d-proton                 # DX12 → Vulkan (uncomment for DX12 titles)

    # ── Touhou / doujin game helpers ─────────────────────────────────────
    # thcrap-launcher is not packaged in nixpkgs; install it inside a Wine
    # prefix with Lutris or Bottles. winetricks + vcrun2019 covers most deps.
    #
    # Quick Lutris script for Touhou:
    #   Runtime: Wine Staging  |  DXVK: enabled  |  DX: 9
    #   env: WINEDLLOVERRIDES="d3d9=n,b"  (let DXVK handle d3d9)

    # ── Performance overlay ───────────────────────────────────────────────
    mangohud    # FPS / GPU / CPU overlay — add "mangohud %command%" in Steam

    # ── Controller tools ─────────────────────────────────────────────────
    gamepad-tool          # deadzone / mapping GUI
    antimicrox            # map controller buttons to keyboard (useful for old games
                          # that don't have controller support)
    # joystickwake        # prevent controller from waking PC from sleep

    # ── Emulators ─────────────────────────────────────────────────────────
    retroarch             # multi-system frontend (SNES, GBA, PS1, arcade…)
    dolphin-emu           # GameCube / Wii
    pcsx2                 # PS2 — plays many doujin/old console ports
    # rpcs3               # PS3 (uncomment — requires BIOS dump)
    # cemu                # Wii U (uncomment)

    # ── Streaming / recording ─────────────────────────────────────────────
    obs-studio            # stream or record gameplay

    # ── Communication ─────────────────────────────────────────────────────
    discord

    # ── KDE apps (complement the Plasma session) ─────────────────────────
    # Konsole is the KDE terminal — already part of plasma6
    #ark                   # KDE archive manager (open game zip/rar/7z files)
    #okular                # KDE document viewer (game manuals, readmes)
    #gwenview              # KDE image viewer (game artwork, screenshots)

    # ── Misc utilities ────────────────────────────────────────────────────
    htop
    btop
    #libnotify
    xclip                 # X11 clipboard utility (X11 session, not wl-clipboard)
    xdotool               # X11 window scripting — handy for old game quirks
    wmctrl                # window manager control — force window positions/sizes

    # ── Fonts ─────────────────────────────────────────────────────────────
    nerd-fonts.jetbrains-mono
    # Japanese fonts — important for Touhou and other doujin games
    noto-fonts-cjk-sans   # CJK (Chinese/Japanese/Korean) sans-serif
    noto-fonts-cjk-serif  # CJK serif
  ];

  # ─────────────────────────────────────────────────────────────────────────
  # MANGOHUD config
  # ─────────────────────────────────────────────────────────────────────────
  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    # MangoHud overlay — https://github.com/flightlessmango/MangoHud#options
    legacy_layout = false
    gpu_stats
    gpu_temp
    gpu_core_clock
    gpu_mem_clock
    gpu_power
    cpu_stats
    cpu_temp
    cpu_mhz
    ram
    vram
    fps
    frametime
    frame_timing
    # Position: top-left | top-right | bottom-left | bottom-right | top-center
    position = top-left
    # toggle_hud = Shift_R+F12
  '';

  # ─────────────────────────────────────────────────────────────────────────
  # ENVIRONMENT — X11-friendly session variables
  # ─────────────────────────────────────────────────────────────────────────
  # These apply to the gaming user's shell and launched applications.
  home.sessionVariables = {
    # Keep Wine on X11 (should be automatic in X11 session, but explicit is safe)
    DISPLAY          = ":0";
    # Disable PulseAudio latency probing — reduces audio stutters in old games
    PULSE_LATENCY_MSEC = "60";
    # Steam extra Proton-GE path (populated by protonup-qt)
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/gaming/.steam/root/compatibilitytools.d";
  };

  fonts.fontconfig.enable = true;

  xdg.userDirs = {
    enable            = true;
    createDirectories = true;
  };
}
