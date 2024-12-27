return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Add current cwd to workspace folder of copilot
      vim.cmd [[
      let g:copilot#workspace_folders = [getcwd()]
    ]]
    end
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },                       -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",                          -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
