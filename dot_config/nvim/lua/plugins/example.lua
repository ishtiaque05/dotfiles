-- Add your custom plugins here
-- This file is automatically loaded by lazy.nvim

return {
  -- Example: Add a colorscheme
  -- {
  --   "folke/tokyonight.nvim",
  --   opts = {
  --     style = "night",
  --   },
  -- },

  -- Show hidden files in neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true, -- show hidden items (dimmed)
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
  },
}
