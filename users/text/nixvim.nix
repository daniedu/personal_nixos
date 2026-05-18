{ pkgs, ... }: {
  programs.nixvim = {
    enable = true;

    globals.mapleader = " ";

    colorschemes.stylix.enable = true;

    plugins = {
      web-devicons.enable = true;

      neo-tree = {
        enable = true;
        settings = {
          window.position = "float";
          enable_git_status = true;
        };
        event = "VeryLazy";
      };

      lualine.enable = true;

      alpha = {
        enable = true;
        settings.layout = [
          {
            type = "padding";
            val = 4;
          }
          {
            type = "text";
            val = [
              "  ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
              "  ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
              "  ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
              "  ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
              "  ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
              "  ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
            ];
            opts = {
              position = "center";
              hl = "Type";
            };
          }
          {
            type = "padding";
            val = 2;
          }
          {
            type = "group";
            val = [
              {
                type = "button";
                val = "    New file";
                on_press.__raw = "function() vim.cmd[[ene]] end";
                opts.shortcut = "n";
                opts.keymap = {
                  n = "n";
                  noremap = true;
                  nowait = true;
                };
              }
              {
                type = "button";
                val = "    Find files";
                on_press.__raw = "function() require('fzf-lua').files() end";
                opts.shortcut = "f";
                opts.keymap = {
                  n = "f";
                  noremap = true;
                  nowait = true;
                };
              }
              {
                type = "button";
                val = "    Recent files";
                on_press.__raw = "function() require('fzf-lua').oldfiles() end";
                opts.shortcut = "r";
                opts.keymap = {
                  n = "r";
                  noremap = true;
                  nowait = true;
                };
              }
              {
                type = "button";
                val = "    Quit";
                on_press.__raw = "function() vim.cmd[[qa]] end";
                opts.shortcut = "q";
                opts.keymap = {
                  n = "q";
                  noremap = true;
                  nowait = true;
                };
              }
            ];
            opts.position = "center";
          }
        ];
      };

      fzf-lua = {
        enable = true;
        profile = "fzf-native";
        keymaps = {
          "<leader>ff" = "files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.mapping = {
          "<C-k>" = "cmp.mapping.select_prev_item()";
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = {
            __raw = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then cmp.select_next_item()
                else fallback()
                end
              end, { "i", "s" })
            '';
          };
        };
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
      };

      conform-nvim = {
        enable = true;
        settings.formatters_by_ft = {
          javascript = [ "prettierd" "prettier" ];
          typescript = [ "prettierd" "prettier" ];
          javascriptreact = [ "prettierd" "prettier" ];
          typescriptreact = [ "prettierd" "prettier" ];
          html = [ "prettierd" "prettier" ];
          css = [ "prettierd" "prettier" ];
          json = [ "prettierd" "prettier" ];
          php = [ "php-cs-fixer" ];
          cpp = [ "clang-format" ];
          c = [ "clang-format" ];
          nix = [ "nixpkgs-fmt" ];
          lua = [ "stylua" ];
          "_" = [ "trim_whitespace" ];
        };
        event = "BufWritePre";
      };

      lsp = {
        enable = true;
        keymaps = {
          lspBuf = {
            gd = "definition";
            K = "hover";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
          };
        };
        servers = {
          ts_ls.enable = true;
          tailwindcss.enable = true;
          intelephense = {
            enable = true;
            package = null;
          };
          clangd.enable = true;
        };
      };

      treesitter = {
        enable = true;
        settings.ensure_installed = [
          "typescript" "tsx" "javascript" "html" "css" "json"
          "php" "php_only" "blade"
          "c" "cpp" "cmake" "make"
          "lua" "nix" "yaml" "toml" "bash" "regex"
        ];
      };

      which-key.enable = true;
      autopairs.enable = true;
      comment.enable = true;
      illuminate.enable = true;
      indent-blankline.enable = true;
      todo-comments.enable = true;
      trouble.enable = true;
    };

    keymaps = [
      {
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle file tree";
      }
      {
        key = "<leader>o";
        action = "<cmd>terminal fff<CR>";
        options.desc = "Open fff";
      }
      {
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<CR>";
        options.desc = "Toggle trouble";
      }
    ];

    extraPackages = with pkgs; [
      prettierd
      phpPackages.php-cs-fixer
      clang-tools
      stylua
      nixpkgs-fmt
      fff
      intelephense
    ];
  };
}
