{ pkgs, inputs, ... }: {
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
              }
              {
                type = "button";
                val = "    Find files";
                on_press.__raw = "function() require('fff').find_files() end";
                opts.shortcut = "f";
              }
              {
                type = "button";
                val = "    Recent files";
                on_press.__raw = "function() require('fff').find_files() end";
                opts.shortcut = "r";
              }
              {
                type = "button";
                val = "    Quit";
                on_press.__raw = "function() vim.cmd[[qa]] end";
                opts.shortcut = "q";
              }
            ];
            opts.position = "center";
          }
        ];
      };

      luasnip.enable = true;

      cmp-luasnip.enable = true;

      cmp-nvim-lsp-signature-help.enable = true;

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
                elseif require("luasnip").expand_or_jumpable() then
                  require("luasnip").expand_or_jump()
                else fallback()
                end
              end, { "i", "s" })
            '';
          };
          "<S-Tab>" = {
            __raw = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then cmp.select_prev_item()
                elseif require("luasnip").jumpable(-1) then
                  require("luasnip").jump(-1)
                else fallback()
                end
              end, { "i", "s" })
            '';
          };
        };
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
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

      tmux-navigator.enable = true;

      lazygit.enable = true;
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

      # Windows
      {
        key = "<leader>wv";
        action = "<cmd>vsplit<CR>";
        options.desc = "Vertical split";
      }
      {
        key = "<leader>ws";
        action = "<cmd>split<CR>";
        options.desc = "Horizontal split";
      }
      {
        key = "<leader>wc";
        action = "<cmd>close<CR>";
        options.desc = "Close window";
      }
      {
        key = "<leader>wo";
        action = "<cmd>only<CR>";
        options.desc = "Close others";
      }
      {
        key = "<leader>w=";
        action = "<C-w>=";
        options.desc = "Balance windows";
      }

      # Find
      {
        key = "<leader>ff";
        action.__raw = "function() require('fff').find_files() end";
        options.desc = "Find files";
      }
      {
        key = "<leader>fg";
        action.__raw = "function() require('fff').live_grep() end";
        options.desc = "Live grep";
      }
      {
        key = "<leader>fz";
        action.__raw = "function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end";
        options.desc = "Fuzzy grep";
      }
      {
        key = "<leader>fc";
        action.__raw = "function() require('fff').live_grep({ query = vim.fn.expand('<cword>') }) end";
        options.desc = "Search word";
      }

      # Git
      {
        key = "<leader>gg";
        action = "<cmd>LazyGit<CR>";
        options.desc = "Toggle lazygit";
      }

      # Diagnostics
      {
        key = "]d";
        action.__raw = "function() vim.diagnostic.goto_next() end";
        options.desc = "Next diagnostic";
      }
      {
        key = "[d";
        action.__raw = "function() vim.diagnostic.goto_prev() end";
        options.desc = "Previous diagnostic";
      }
      {
        key = "<leader>td";
        action.__raw = "function() require('todo-comments').jump_next() end";
        options.desc = "Next TODO";
      }
    ];

    extraPlugins = [
      inputs.fff-nvim.packages.${pkgs.system}.fff-nvim
    ];

    extraConfigLua = ''
      require("fff").setup({
        layout = {
          height = 0.8,
          width = 0.8,
          prompt_position = "bottom",
        },
        preview = { enabled = true },
        grep = { modes = { "plain", "regex", "fuzzy" } },
        frecency = { enabled = true },
      })
    '';

    extraPackages = with pkgs; [
      prettierd
      phpPackages.php-cs-fixer
      clang-tools
      stylua
      nixpkgs-fmt
      fff
      intelephense
      qt6.qtdeclarative
    ];
  };
}
