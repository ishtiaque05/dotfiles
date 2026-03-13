-- Custom plugins
-- This file is automatically loaded by lazy.nvim

return {
  -- Colorscheme: tokyonight-night (matches Wezterm + tmux theme)
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = false,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },

  -- GraphQL syntax highlighting + LSP
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "graphql" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        graphql = {},
      },
    },
  },
}
