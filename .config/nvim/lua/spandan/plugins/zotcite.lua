return {
  "jalvesaq/zotcite",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    "jalvesaq/cmp-zotcite",
  },
  config = function()
    require("zotcite").setup({
      -- your options here (see doc/zotcite.txt)
    })
  end
}
