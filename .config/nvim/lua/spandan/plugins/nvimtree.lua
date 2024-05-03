return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require("nvim-tree").setup {
      disable_netrw = true,
      hijack_netrw = true,
      view = {
        width = 30,
        side = 'right',
      },
    }
  end,
}
