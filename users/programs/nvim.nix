{ pkgs, ... }: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "ols" ''
      export ODIN_ROOT="${pkgs.odin}/share"
      exec ${pkgs.ols}/bin/ols "$@"
    '')
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = false;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      LuaSnip
      nvim-treesitter
    ];

    extraLuaConfig = ''
      vim.g.mapleader = " "
      vim.opt.number = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.expandtab = true

      local lspconfig = require("lspconfig")
      lspconfig.ols.setup({})

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

      local cmp = require("cmp")
      cmp.setup({
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
      })

      require("nvim-treesitter.configs").setup({
        ensure_installed = { "odin" },
        auto_install = true,
        highlight = { enable = true },
      })
    '';
  };
}
