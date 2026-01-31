return {
  'nvim-treesitter/nvim-treesitter',
  -- Eager load is correct for the main plugin
  lazy = false,
  priority = 1000,
  build = ":TSUpdate",

  -- COMMENT THIS OUT FOR NOW
  -- We must disable this to stop the crash loop
  -- dependencies = {
  --   'nvim-treesitter/nvim-treesitter-textobjects',
  -- },

  config = function()
    -- 1. Setup Treesitter FIRST
    require('nvim-treesitter').setup {
      ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'vimdoc', 'vim', 'markdown', 'markdown_inline' },
      
      auto_install = true,
      sync_install = false, 
      ignore_install = {},

      highlight = { enable = true },
      indent = { enable = true, disable = { 'python' } },
      
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<c-backspace>',
        },
      },
      
      -- Disable textobjects config temporarily
      -- textobjects = { ... } 
    }
    
    vim.filetype.add({ extension = { bend = "bend" } })
    vim.treesitter.language.register("bend", { "bend" })
  end
}
