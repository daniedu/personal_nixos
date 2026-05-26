{ pkgs, inputs, ... }: {
  programs.nixvim = {
    enable = true;

    globals.mapleader = " ";

    opts = {
      number = true;
    };

    diagnostics = {
      virtual_text = true;
      signs = true;
      underline = true;
      update_in_insert = true;
      severity_sort = true;
    };

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
            val = 2;
          }
          {
            type = "text";
            val = [
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣤⣤⣤⣤⣄⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠶⣻⠝⠋⠠⠔⠛⠁⡀⠀⠈⢉⡙⠓⠶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠞⢋⣴⡮⠓⠋⠀⠀⢄⠀⠀⠉⠢⣄⠀⠈⠁⠀⡀⠙⢶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠞⢁⣔⠟⠁⠀⠀⠀⠀⠀⠈⡆⠀⠀⠀⠈⢦⡀⠀⠀⠘⢯⢢⠙⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡼⠃⠀⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠸⠀⠀⠀⠀⠀⢳⣦⡀⠀⠀⢯⠀⠈⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠆⡄⢠⢧⠀⣸⠀⠀⠀⠀⠀⠀⠀⢰⠀⣄⠀⠀⠀⠀⢳⡈⢶⡦⣿⣷⣿⢉⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣯⣿⣁⡟⠈⠣⡇⠀⠀⢸⠀⠀⠀⠀⢸⡄⠘⡄⠀⠀⠀⠈⢿⢾⣿⣾⢾⠙⠻⣾⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⡿⣮⠇⢙⠷⢄⣸⡗⡆⠀⢘⠀⠀⠀⠀⢸⠧⠀⢣⠀⠀⠀⡀⡸⣿⣿⠘⡎⢆⠈⢳⣽⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⢠⡟⢻⢷⣄⠀⠀⠀⠀⠀⠀⣾⣳⡿⡸⢀⣿⠀⠀⢸⠙⠁⠀⠼⠀⠀⠀⠀⢸⣇⠠⡼⡤⠴⢋⣽⣱⢿⣧⠀⢳⠈⢧⠀⢻⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⢀⡿⣠⡣⠃⣿⠃⠀⠀⠀⠀⣸⣳⣿⠇⣇⢸⣿⢸⣠⠼⠀⠀⠀⡇⠀⡀⠉⠒⣾⢾⣆⢟⣳⡶⠓⠶⠿⢼⣿⣇⠈⡇⠘⢆⠈⢿⡘⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠈⢷⣍⣤⡶⣿⡄⠀⠀⠀⢠⣿⠃⣿⠀⡏⢸⣿⣿⠀⢸⠀⠀⢠⡗⢀⠇⠀⢠⡟⠀⠻⣾⣿⠀⠀⠀⠀⡏⣿⣿⡀⢹⡀⠈⢦⠈⢷⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢁⣤⣄⠁⠀⠀⠀⣼⡏⢰⣟⠀⣇⠘⣿⣿⣾⣾⣆⢀⣾⠃⣼⢠⣶⣿⣭⣷⣶⣾⣿⣤⠀⠀⠀⡇⡯⣍⣧⠀⣷⠄⠈⢳⡀⢻⡁⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠺⣿⡿⠀⠀⠀⠀⡿⢀⣾⣧⠀⡗⡄⢿⣿⡙⣽⣿⣟⠛⠚⠛⠙⠉⢹⣿⣿⣦⠀⢸⡿⠀⠀⠀⢰⡯⣌⢻⡀⢸⢠⢰⡄⠹⡷⣿⣦⣤⠤⣶⡇⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⣇⣾⣿⢸⢠⣧⢧⠘⣿⡇⠸⣿⢿⡆⠀⠀⠀⠀⠘⣯⠇⣿⠂⣸⢰⠀⠀⢀⣸⡧⣊⣼⡇⢸⣼⣸⣷⢣⢻⣄⠉⠙⠛⠉⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣳⣤⣴⣿⣏⣿⣾⢸⣿⡘⣧⣘⢿⣀⡙⣞⠁⠀⠀⠀⠀⢀⡬⢀⣉⢠⣧⡏⠀⠀⡎⣿⣿⣿⣿⠃⣸⡏⣿⣿⡎⢿⡘⡆⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⣠⣼⣿⣿⣿⣼⣿⣧⢿⣿⣿⣯⡻⠟⠀⠀⠀⠀⠀⠐⢯⠣⡽⢟⣽⠀⠀⢘⡇⣿⣿⣿⡟⣴⣿⣷⣿⣿⣧⣿⣷⡽⠀⠀⠀⠀⠀⠀⠀"
              "⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣼⣹⣿⣇⣸⣿⣿⣿⣻⣚⣿⡿⣿⣿⣦⣤⣀⡉⠃⠀⢀⣀⣤⡶⠛⡏⠀⢀⣼⢸⣿⣿⣿⣿⣿⣿⣿⢋⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀"
              "⣿⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠒⠒⠒⢭⢻⣽⣿⣿⣿⣿⣿⣿⢿⠿⣿⡏⠀⡼⠁⣀⣾⣿⣿⣿⣿⡿⣿⣿⣟⡻⣿⣿⡿⠣⠟⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠸⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⢿⣯⡽⠿⠛⠋⣵⢟⣋⣿⣶⣞⣤⣾⣿⣿⡟⢉⡿⢋⠻⢯⡉⢻⡟⢿⡅⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⢻⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡞⣿⣆⡀⠀⡼⡏⠉⠚⠭⢉⣠⠬⠛⠛⢁⡴⣫⠖⠁⠀⠀⣩⠟⠁⣸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠈⢷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣽⣿⣿⣾⠳⡙⣦⡤⠜⠊⠁⠀⣀⡴⠯⠾⠗⠒⠒⠛⠛⠛⠛⠛⠓⠿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠘⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢷⣻⣿⣿⠔⢪⠓⠬⢍⠉⣩⣽⢻⣤⣶⣦⠀⠀⠀⢀⣀⣤⣴⣾⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠹⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣾⡏⢦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣯⣿⣿⠀⠀⣇⠀⣠⠎⠁⢹⡎⡟⡏⣷⣶⠿⠛⡟⠛⠛⣫⠟⠉⢿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⢻⡄⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣷⠈⢷⡤⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣾⣷⡀⣀⣀⣷⡅⠀⠀⠈⣷⢳⡇⣿⠀⠀⣸⠁⢠⡾⣟⣛⣻⣟⡿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢯⢻⣏⡵⠿⠿⢤⣄⠀⢀⣿⢸⣹⣿⣀⣴⣿⣴⣿⣛⠋⠉⠉⡉⠛⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠘⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡎⣿⣥⣶⠖⢉⣿⡿⣿⣿⡿⣿⣟⠿⠿⣿⣿⣿⡯⠻⣿⣿⣿⣷⡽⣿⡗⠀⠀⠀⠀⠀⠀⠀"
              "⠀⠀⠀⠀⠀⠀⠸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡘⣿⣩⠶⣛⣋⡽⠿⣷⢬⣙⣻⣿⣿⣿⣯⣛⠳⣤⣬⡻⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀"
              "⠀⣿⣛⣻⣿⡿⠿⠟⠗⠶⠶⠶⠶⠤⠤⢤⠤⡤⢤⣤⣤⣤⣤⣄⣀⣀⣀⣀⣀⣀⣀⣀⣣⢹⣷⣶⣿⣿⣦⣴⣟⣛⣯⣤⣿⣿⣿⣿⣿⣷⣌⣿⣿⣿⣿⣿⣿⣿⣤⣤⣤⣤⣤⣤⣄"
              "⠀⠉⠙⠛⠛⠛⠛⠛⠻⠿⠿⠿⠷⠶⠶⢶⣶⣶⣶⣶⣤⣤⣤⣤⣤⣥⣬⣭⣭⣉⣩⣍⣙⣏⣉⣏⣽⣶⣶⣶⣤⣤⣬⣤⣤⣾⣿⠶⠾⠿⠿⠿⠿⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠃"
              "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠛⠛⠛⠛⠛⠛⠋⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            ];
            opts = {
              position = "center";
              hl = "Type";
            };
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
          go = [ "gofumpt" ];
          qml = [ "qmlformat" ];
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
            gr = "references";
            gi = "implementation";
            gy = "type_definition";
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
          gopls.enable = true;
          nil_ls.enable = true;
          qmlls.enable = true;
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

      gitsigns.enable = true;
      flash.enable = true;
      fidget.enable = true;
      noice.enable = true;
      visual-multi.enable = true;
      navic.enable = true;
      rainbow-delimiters.enable = true;
      colorizer.enable = true;

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

      # LSP info
      {
        key = "<leader>li";
        action = "<cmd>LspInfo<CR>";
        options.desc = "LSP Info";
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

      # Undo/redo in insert mode
      {
        key = "<C-z>";
        action = "<cmd>undo<CR>";
        options.desc = "Undo";
        mode = "i";
      }
      {
        key = "<C-y>";
        action = "<cmd>redo<CR>";
        options.desc = "Redo";
        mode = "i";
      }

      # Run qmllint on current QML file
      {
        key = "<leader>lq";
        action = "<cmd>!qmllint %<CR>";
        options.desc = "Run qmllint";
      }

      # Save
      {
        key = "<C-s>";
        action = "<cmd>w<CR>";
        options.desc = "Save file";
        mode = [ "i" "n" ];
      }

      # Quit (replaces C-w)
      {
        key = "<leader>wq";
        action = "<cmd>q<CR>";
        options.desc = "Quit";
      }

      # Clear search highlights
      {
        key = "<leader>h";
        action = "<cmd>nohlsearch<CR>";
        options.desc = "Clear search highlights";
      }

      # Buffer navigation
      {
        key = "]b";
        action.__raw = "function() vim.cmd.bnext() end";
        options.desc = "Next buffer";
      }
      {
        key = "[b";
        action.__raw = "function() vim.cmd.bprevious() end";
        options.desc = "Previous buffer";
      }
      {
        key = "<leader>bd";
        action.__raw = "function() vim.cmd('bprevious | bdelete #') end";
        options.desc = "Close buffer";
      }

      # System clipboard
      {
        key = "<leader>y";
        action.__raw = "function() vim.fn.setreg('+', vim.fn.getreg('\"')) end";
        options.desc = "Yank to system clipboard";
      }
      {
        key = "<leader>p";
        action.__raw = "function() vim.cmd('normal! \"+p') end";
        options.desc = "Paste from system clipboard";
      }

      # Tab navigation
      {
        key = "<leader>t";
        action = "<cmd>tabnew<CR>";
        options.desc = "New tab";
      }
      {
        key = "<leader><Tab>";
        action = "<cmd>tabnext<CR>";
        options.desc = "Next tab";
      }
      {
        key = "<leader><S-Tab>";
        action = "<cmd>tabprevious<CR>";
        options.desc = "Previous tab";
      }
      {
        key = "<leader>1";
        action = "<cmd>tabnext 1<CR>";
        options.desc = "Tab 1";
      }
      {
        key = "<leader>2";
        action = "<cmd>tabnext 2<CR>";
        options.desc = "Tab 2";
      }
      {
        key = "<leader>3";
        action = "<cmd>tabnext 3<CR>";
        options.desc = "Tab 3";
      }
      {
        key = "<leader>4";
        action = "<cmd>tabnext 4<CR>";
        options.desc = "Tab 4";
      }
      {
        key = "<leader>5";
        action = "<cmd>tabnext 5<CR>";
        options.desc = "Tab 5";
      }
      {
        key = "<leader>6";
        action = "<cmd>tabnext 6<CR>";
        options.desc = "Tab 6";
      }
      {
        key = "<leader>7";
        action = "<cmd>tabnext 7<CR>";
        options.desc = "Tab 7";
      }
      {
        key = "<leader>8";
        action = "<cmd>tabnext 8<CR>";
        options.desc = "Tab 8";
      }
      {
        key = "<leader>9";
        action = "<cmd>tabnext 9<CR>";
        options.desc = "Tab 9";
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
      gofumpt
      gopls
      nil
      qt6.qtdeclarative
    ];
  };
}
