# Home-Manager configuration for the "work" user
{ pkgs, inputs, lib, config, ... }:

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
  # Stylix automatically injects the Base16 palette and font.
  # Only behaviour/layout is configured here.
  programs.kitty = {
    enable = true;
    settings = {
      window_padding_width    = 8;
      confirm_os_window_close = 0;
      tab_bar_style           = "powerline";
      tab_bar_edge            = "bottom";
      # Transparency is set by stylix.opacity.terminal (0.90).
      # Uncomment to override:
      background_opacity = "0.90";
    };
  };

  # ─────────────────────────────────────────────────────────────────────────
  # NEOVIM — configured via programs.neovim (best Stylix integration path)
  # ─────────────────────────────────────────────────────────────────────────
  # Stylix targets.neovim.enable injects a base16 colourscheme directly into
  # Neovim's init — no LazyVim/NixVim conflict.  Plugins are managed by Nix
  # so they are always reproducible and available offline after build.
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    viAlias       = true;
    vimAlias      = true;
    withRuby      = false;
    withPython3    = false;
    # Extra CLI tools available inside Neovim's PATH
    extraPackages = with pkgs; [
      # LSP servers
      lua-language-server
      nil               # Nix LSP
      typescript-language-server
      pyright           # Python LSP
      rust-analyzer
      # Formatters / linters
      stylua            # Lua formatter
      nixfmt-rfc-style  # Nix formatter
      ripgrep           # used by telescope live_grep
      fd                # used by telescope find_files
    ];

    plugins = with pkgs.vimPlugins; [
      # ── Treesitter — syntax highlighting ─────────────────────────────
      { plugin = nvim-treesitter.withAllGrammars;
        type   = "lua";
        config = ''
          require("nvim-treesitter.configs").setup({
            highlight = { enable = true },
            indent    = { enable = true },
          })
        '';
      }

      # ── LSP ───────────────────────────────────────────────────────────
      nvim-lspconfig
      { plugin = nvim-lspconfig;
        type   = "lua";
        config = ''
          local lsp = require("lspconfig")
          lsp.lua_ls.setup({})
          lsp.nil_ls.setup({})
          lsp.ts_ls.setup({})
          lsp.pyright.setup({})
          lsp.rust_analyzer.setup({})
        '';
      }

      # ── Autocompletion ────────────────────────────────────────────────
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      { plugin = nvim-cmp;
        type   = "lua";
        config = ''
          local cmp = require("cmp")
          cmp.setup({
            snippet = {
              expand = function(args)
                require("luasnip").lsp_expand(args.body)
              end,
            },
            mapping = cmp.mapping.preset.insert({
              ["<Tab>"]   = cmp.mapping.select_next_item(),
              ["<S-Tab>"] = cmp.mapping.select_prev_item(),
              ["<CR>"]    = cmp.mapping.confirm({ select = true }),
              ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
              { name = "nvim_lsp" },
              { name = "luasnip" },
              { name = "buffer" },
              { name = "path" },
            }),
          })
        '';
      }

      # ── Telescope — fuzzy finder ──────────────────────────────────────
      telescope-nvim
      plenary-nvim
      { plugin = telescope-nvim;
        type   = "lua";
        config = ''
          local tb = require("telescope.builtin")
          vim.keymap.set("n", "<leader>ff", tb.find_files,  { desc = "Find files" })
          vim.keymap.set("n", "<leader>fg", tb.live_grep,   { desc = "Live grep"  })
          vim.keymap.set("n", "<leader>fb", tb.buffers,     { desc = "Buffers"    })
          vim.keymap.set("n", "<leader>fh", tb.help_tags,   { desc = "Help tags"  })
        '';
      }

      # ── File tree ─────────────────────────────────────────────────────
      nvim-tree-lua
      nvim-web-devicons
      { plugin = nvim-tree-lua;
        type   = "lua";
        config = ''
          require("nvim-tree").setup({})
          vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "File tree" })
        '';
      }

      # ── Status line ───────────────────────────────────────────────────
      { plugin = lualine-nvim;
        type   = "lua";
        config = ''
          require("lualine").setup({ options = { theme = "base16" } })
        '';
      }

      # ── Git signs in gutter ───────────────────────────────────────────
      { plugin = gitsigns-nvim;
        type   = "lua";
        config = ''require("gitsigns").setup({})'';
      }

      # ── Comment toggling ──────────────────────────────────────────────
      { plugin = comment-nvim;
        type   = "lua";
        config = ''require("Comment").setup({})'';
      }

      # ── Auto pairs ────────────────────────────────────────────────────
      { plugin = nvim-autopairs;
        type   = "lua";
        config = ''require("nvim-autopairs").setup({})'';
      }

      # ── Which-key — shows keybind hints ──────────────────────────────
      { plugin = which-key-nvim;
        type   = "lua";
        config = ''require("which-key").setup({})'';
      }
    ];

    extraLuaConfig = ''
      -- ── General options ───────────────────────────────────────────────
      vim.g.mapleader = " "
      vim.opt.number         = true
      vim.opt.relativenumber = true
      vim.opt.expandtab      = true
      vim.opt.tabstop        = 2
      vim.opt.shiftwidth     = 2
      vim.opt.smartindent    = true
      vim.opt.wrap           = false
      vim.opt.swapfile       = false
      vim.opt.backup         = false
      vim.opt.undofile       = true
      vim.opt.hlsearch       = false
      vim.opt.incsearch      = true
      vim.opt.termguicolors  = true   -- required for base16 colours from Stylix
      vim.opt.scrolloff      = 8
      vim.opt.signcolumn     = "yes"
      vim.opt.updatetime     = 50
      vim.opt.splitright     = true
      vim.opt.splitbelow     = true

      -- ── Keymaps ───────────────────────────────────────────────────────
      vim.keymap.set("n", "<C-h>", "<C-w>h")
      vim.keymap.set("n", "<C-l>", "<C-w>l")
      vim.keymap.set("n", "<C-j>", "<C-w>j")
      vim.keymap.set("n", "<C-k>", "<C-w>k")
      vim.keymap.set("n", "<leader>w", ":w<CR>",  { desc = "Save" })
      vim.keymap.set("n", "<leader>q", ":q<CR>",  { desc = "Quit" })
      vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")  -- move selection down
      vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")  -- move selection up
    '';
  };

  # Let Stylix theme Neovim with the wallpaper-extracted base16 palette
#   stylix.targets.neovim.enable = true;


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
    # ── Fonts (beyond what Stylix sets system-wide) ───────────────────────
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    candy-icons

    # ── Screenshot tools ─────────────────────────────────────────────────
    flameshot
    grim
    slurp
    swappy
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
    
    # ── Screenshot ──────────────────────────────────────────────────────────────
    
  ];

sservices.flameshot = {
  enable = true;
  settings = {
    General = {
        
      # More settings may be found on the Flameshot Github

      # Save Path
      savePath = "/home/user/Screenshots";
      # Tray
      disabledTrayIcon = true;
      # Greeting message   
      showStartupLaunchMessage = false;
      # Default file extension for screenshots (.png by default)
      saveAsFileExtension = ".png";
      # Desktop notifications
      showDesktopNotification = true;
      # Notification for cancelled screenshot
      showAbortNotification = false;
      # Whether to show the info panel in the center in GUI mode
      showHelp = true;
      # Whether to show the left side button in GUI mode
      showSidePanelButton = true;


      # Color Customization
      uiColor = "#740096";
      contrastUiColor = "#270032";
      drawColor = "#ff0000";

      # For Wayland (Install Grim seperately)
      useGrimAdapter = true;
      # Stops warnings for using Grim
      disabledGrimWarning = true;
    };
  };
};

home.file.".config/wlr-which-key/config.yaml".text = ''
  # Theming to match your setup
  font: "JetBrainsMono Nerd Font 12"
  background: "#191724d0" # Rose Pine dark background with transparency
  color: "#e0def4"
  border: "#ebbcba"
  separator: " ➜ "
  
  menu:
    - key: "s"
      desc: "Screenshot (Flameshot)"
      submenu:
        - key: "s"
          desc: "Select Region"
          # The 'sway' variable is a trick to make Flameshot play nice with Hyprland
          cmd: "XDG_CURRENT_DESKTOP=sway flameshot gui"
        - key: "f"
          desc: "Full Screen"
          cmd: "XDG_CURRENT_DESKTOP=sway flameshot full"
        - key: "c"
          desc: "Capture and Copy to Clipboard"
          cmd: "XDG_CURRENT_DESKTOP=sway flameshot gui --raw | wl-copy"
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
