local M = {}

function M.open_neovim_config()
  vim.cmd("cd " .. vim.env.HOME .. "/.config/nvim")
  vim.cmd("e init.lua")
end

function M.open_hyprland_config()
  vim.cmd("cd " .. vim.env.HOME .. "/.config/hypr")
  vim.cmd("e hyprland.conf")
end

return M
