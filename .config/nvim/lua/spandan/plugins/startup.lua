return {
  "startup-nvim/startup.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim"
  },
  config = function()
    -- ignore git and node_modules
    require "startup".setup {
      theme = "dashboard",
    }
  end
}
