return {
  "github/copilot.vim",
  event = "InsertEnter",
  config = function()
    -- Add current cwd to workspace folder of copilot
    vim.cmd [[
      let g:copilot#workspace_folders = [getcwd()]
    ]]
  end
}
