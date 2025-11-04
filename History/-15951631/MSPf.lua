return {
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("everforest").setup({
        background = "medium", -- "soft", "medium", or "hard"
        transparent_background_level = 0,
        italics = false,
      })
      vim.cmd([[colorscheme everforest]])
    end,
  },
}
