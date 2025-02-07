return {
  {
    "Dr-42/project-manager.nvim",
    -- dir = "~/Projects/project-manager.nvim",
    name = "project-manager",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("project-manager").setup({
        projects_root = vim.env.HOME .. "/Projects", -- or your preferred directory
        ignore_dirs = { "probe", "third_party" },    -- directories to ignore
        extra_mappings = {                           -- additional mappings (if desired)
          probe = vim.env.HOME .. "/Projects/probe",
          third_party = vim.env.HOME .. "/Projects/third_party",
        },
      })
    end,
  },
}
