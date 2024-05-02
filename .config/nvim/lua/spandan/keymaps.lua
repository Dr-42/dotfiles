local M = {}

function M.keymaps()
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Keymaps for better default experience
  -- See `:help vim.keymap.set()`
  vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

  -- Remap for dealing with word wrap
  vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- See `:help telescope.builtin`
  vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
  vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer]' })

  vim.keymap.set('n', '<leader><esc>', require('notify').dismiss, { desc = '[ ] Close all notifications' })

  --[[ vim.keymap.set('n', '<leader>sa', function()
  vim.ui.input({prompt = ' Search For > ', cancelreturn = '', completion = 'dir', history = 'search'}, function(input)
  require('telescope.builtin').grep_string({ search = input })
  end)
  end, { desc = '[S]earch [A]ll' }) ]]

  vim.keymap.set('n', '<leader>lg', require('telescope.builtin').live_grep, { desc = '[L]ive [G]rep' })

  vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>fb', ':Telescope file_browser<CR>', { desc = '[F]ile [B]rowser' })
  vim.keymap.set('n', '<leader>tl', ":botright split | resize 7 | terminal<CR>", { desc = '[T]ermina[L]' })

  -- Keymaps for better tab management
  vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = '[T]ab [N]ew' })
  vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = '[T]ab [C]lose' })

  vim.keymap.set('n', '<leader>es', require('error-jump').jump_to_error, { desc = '[E]rror [S]ource' })
  vim.keymap.set('n', '<leader>en', require('error-jump').next_error, { desc = '[E]rror [N]ext' })
  vim.keymap.set('n', '<leader>eN', require('error-jump').next_error, { desc = '[E]rror [N]previous' })

  -- Diagnostic keymaps
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

  vim.keymap.set('n', '<leader>pb', require('telescope.builtin').buffers, { desc = '[P]ick [B]uffer' })
  vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = '[G]it [F]iles' })
  vim.keymap.set('n', '<leader>G', ":Git<CR>", { desc = '[G]it' })

  -- Return to normal mode from terminal
  vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })

  -- Pane navigation
  vim.keymap.set('n', '<leader>P<up>', ':split<CR><C-w><up>', { desc = '[P]ane [U]p' })
  vim.keymap.set('n', '<leader>P<down>', ':split<CR><C-w><down>', { desc = '[P]ane [D]own' })
  vim.keymap.set('n', '<leader>P<left>', ':vsplit<CR><C-w><left>', { desc = '[P]ane [L]eft' })
  vim.keymap.set('n', '<leader>P<right>', ':vsplit<CR><C-w><right>', { desc = '[P]ane [R]ight' })

  vim.keymap.set('n', '<leader>pc', '<C-w>c', { desc = '[P]ane [C]lose' })

  vim.keymap.set('n', '<C-up>', '<C-w><up>', { desc = '[P]ane [U]p' })
  vim.keymap.set('n', '<C-down>', '<C-w><down>', { desc = '[P]ane [D]own' })
  vim.keymap.set('n', '<C-left>', '<C-w><left>', { desc = '[P]ane [L]eft' })
  vim.keymap.set('n', '<C-right>', '<C-w><right>', { desc = '[P]ane [R]ight' })
end

return M
