return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = vim.fn.executable 'make' == 1
      },
      { "nvim-telescope/telescope-file-browser.nvim" }
    },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = require('telescope.actions').delete_buffer,
            },
            n = {
              ['<C-d>'] = require('telescope.actions').delete_buffer,
            }
          },
          preview = {
            mime_hook = function(filepath, bufnr, opts)
              local is_image = function(path)
                local image_extensions = { 'png', 'jpg', 'jpeg' } -- Supported image formats
                local split_path = vim.split(path:lower(), '.', { plain = true })
                local extension = split_path[#split_path]
                return vim.tbl_contains(image_extensions, extension)
              end
              if is_image(filepath) then
                local term = vim.api.nvim_open_term(bufnr, {})
                local function send_output(_, data, _)
                  for _, d in ipairs(data) do
                    vim.api.nvim_chan_send(term, d .. '\r\n')
                  end
                end
                local buffer_width = vim.api.nvim_win_get_width(opts.winid)
                local buffer_height = vim.api.nvim_win_get_height(opts.winid)
                local size = string.format('--size=%dx%d', buffer_width, buffer_height)
                vim.fn.jobstart(
                  {
                    'chafa', size, filepath -- Terminal image viewer command
                  },
                  { on_stdout = send_output, stdout_buffered = true, pty = true })
              else
                require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
              end
            end
          },
        },
        extensions = {
          hijack_netrw = true,
          fzf = {
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
          file_browser = {
            -- disable if you don't want the file browser
            -- the default is true
            enabled = true,
            -- ignored file types
            ignored_file_types = { 'node_modules', 'vendor', '.cache', '.bld_cpp', 'target' },
            -- the command that runs when "open" is called
            open_cmd = 'xdg-open',
            -- the command that runs when "open_all" is called
            open_all_cmd = 'xdg-open',
          },
        },
      }
    end
  }
}
