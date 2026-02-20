require("lazy").setup({

  -- file finder
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- git
  { "lewis6991/gitsigns.nvim", config = true },

  -- lsp helper UI
  { "folke/trouble.nvim", config = true },

  -- file tree
  { "nvim-tree/nvim-tree.lua", config = true },

  -- symbols outline
  { "simrat39/symbols-outline.nvim", config = true },

  -- zen mode
  { "folke/zen-mode.nvim", config = true },

  -- terminal
  { "akinsho/toggleterm.nvim", config = true },

  -- comments
  { "numToStr/Comment.nvim", config = true },

  -- markdown preview
  { "iamcco/markdown-preview.nvim", build = "cd app && npm install" },

})
