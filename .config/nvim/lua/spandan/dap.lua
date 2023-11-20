local dap = require('dap')
require('dap').defaults.fallback.terminal_win_cmd = "50vsplit new"

-- set up nvim-dap-ui
require('dapui').setup()

-- Keymaps 
vim.api.nvim_set_keymap('n', '<leader>dc', '<Cmd>lua require"dap".continue()<CR>', { desc = '[D]AP [C]ontinue'})
vim.api.nvim_set_keymap('n', '<leader>ds', '<Cmd>lua require"dap".step_over()<CR>', {desc = '[D]AP [S]tep over'})
vim.api.nvim_set_keymap('n', '<leader>di', '<Cmd>lua require"dap".step_into()<CR>', {desc = '[D]AP Step [I]nto'})
vim.api.nvim_set_keymap('n', '<leader>do', '<Cmd>lua require"dap".step_out()<CR>', {desc = '[D]AP Step [O]ut'})
vim.api.nvim_set_keymap('n', '<leader>db', '<Cmd>lua require"dap".toggle_breakpoint()<CR>', {desc = '[D]AP [B]reakpoint toggle'})
vim.api.nvim_set_keymap('n', '<leader>dR', '<Cmd>lua require"dap".repl.open()<CR>', {desc = '[D]AP [R]epl'})
vim.api.nvim_set_keymap('n', '<leader>dl', '<Cmd>lua require"dap".run_last()<CR>', {desc = '[D]AP run [L]ast'})

-- DapUI keymaps
vim.api.nvim_set_keymap('n', '<leader>dui', '<Cmd>lua require"dapui".toggle()<CR>', {desc = '[D]AP [U][I]'})

-- set dap icons
vim.fn.sign_define('DapBreakpoint', { text = '🟥' , texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '🟢', texthl = '', linehl = '', numhl = '' })

dap.adapters.python = {
  type = 'executable';
  command = 'python';
  args = {'-m', 'debugpy.adapter'};
}

-- check if cpptools.ad7Engine.json exists
local cppad7EnginePath = vim.fn.stdpath('data') .. '/mason/packages/cpptools/extension/debugAdapters/bin/cppdbg.ad7Engine.json'
local cppad7EngineExists = vim.fn.filereadable(cppad7EnginePath) == 1
local nvimad7EnginePath = vim.fn.stdpath('data') .. '/mason/packages/cpptools/extension/debugAdapters/bin/cpptools.ad7Engine.json'
local nvimad7EngineExists = vim.fn.filereadable(nvimad7EnginePath) == 1

if not nvimad7EngineExists then
  print('nvim-dap.ad7Engine.json not found, copying from cppdbg.ad7Engine.json')
  if cppad7EngineExists then
    print('cppdbg.ad7Engine.json found, copying to nvim-dap.ad7Engine.json')
    -- copy cppdbg.cppad7Engine.json to nvim-dap.ad7Engine.json
    vim.fn.system('cp ' .. cppad7EnginePath .. ' ' .. nvimad7EnginePath)
  else
    print('cppdbg.ad7Engine.json not found, not copying')
  end
end


-- setup cpptools adapter
dap.adapters.cpptools = {
  id = "cpptools",
  type = 'executable',
  command = vim.fn.stdpath('data') .. '/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
  options = {
    detached = false,
  }
}

-- this configuration should start cpptools and the debug the executable main in the current directory when executing :DapContinue
dap.configurations.cpp = {
  {
    name = "Launch",
    type = "cpptools",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
    args = function()
      args = vim.fn.input('Arguments: ', '', 'file')
      return args ~= '' and vim.split(args, ' ', true) or nil
    end,
    runInTerminal = false,
  },
}

-- Re-use the configuration for C
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
