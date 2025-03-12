return {
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    -- require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    -- require('mini.surround').setup()

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    local macroline = function()
      local macro = vim.fn.reg_recording()
      if macro == '' then
        return ''
      end
      return string.format('󰑋 %s', macro)
    end

    local python_venv = function()
      local venv = vim.env.VIRTUAL_ENV
      if venv == nil then
        return ''
      end
      -- Chop off the cwd
      venv = venv:gsub(vim.fn.getcwd(), '')
      venv = venv:gsub('^/', '')
      return string.format(' %s', venv)
    end

    statusline.setup {
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local git           = MiniStatusline.section_git({ trunc_width = 75 })
          local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
          local macro         = macroline()
          local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
          local python_venv   = python_venv()
          local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
          local location      = MiniStatusline.section_location({ trunc_width = 75 })
          local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

          return MiniStatusline.combine_groups({
            { hl = mode_hl,                 strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diagnostics } },
            { hl = 'MiniStatuslineMacro',   strings = { macro } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename',   strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslinePythonVenv', strings = { python_venv } },
            { hl = 'MiniStatuslineFileinfo',   strings = { fileinfo } },
            { hl = mode_hl,                    strings = { search, location } },
          })
        end
      },
      use_icons = true
    }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end

    local starter = require('mini.starter')
    -- A workaround to centralize everything.
    -- `aligning("center", "center")` will centralize the longest line in
    -- `content`, then left align other items to its beginning.
    -- It causes the header to not be truly centralized and have a variable
    -- shift to the left.
    -- This function will use `aligning` and pad the header accordingly.
    -- It also goes over `justified_sections`, goes over all their items names
    -- and justifies them by padding existing space in them.
    -- Since `item_bullet` are separated from the items themselves, their
    -- width is measured separately and deducted from the padding.
    local centralize = function(justified_sections, centralize_header)
      return function(content, buf_id)
        -- Get max line width, same as in `aligning`
        local max_line_width = math.max(unpack(vim.tbl_map(function(l)
          return vim.fn.strdisplaywidth(l)
        end, starter.content_to_lines(content))))

        -- Align
        content = starter.gen_hook.aligning("center", "center")(content, buf_id)

        -- Iterate over header items and pad with relative missing spaces
        if centralize_header == true then
          local coords = starter.content_coords(content, "header")
          for _, c in ipairs(coords) do
            local unit = content[c.line][c.unit]
            local pad = (max_line_width - vim.fn.strdisplaywidth(unit.string))
                / 2
            if unit.string ~= "" then
              unit.string = string.rep(" ", pad) .. unit.string
            end
          end
        end

        -- Justify recent files and workspaces
        if justified_sections ~= nil and #justified_sections > 0 then
          -- Check if `adding_bullet` has mutated the `content`
          local coords = starter.content_coords(content, "item_bullet")
          local bullet_len = 0
          if coords ~= nil then
            -- Bullet items are defined, compensate for bullet prefix width
            bullet_len = vim.fn.strdisplaywidth(
              content[coords[1].line][coords[1].unit].string
            )
          end

          coords = starter.content_coords(content, "item")
          for _, c in ipairs(coords) do
            local unit = content[c.line][c.unit]
            if vim.tbl_contains(justified_sections, unit.item.section) then
              local one, two = unpack(vim.split(unit.string, "km"))
              unit.string = one
                  .. string.rep(
                    " ",
                    max_line_width
                    - vim.fn.strdisplaywidth(unit.string)
                    - bullet_len
                    + 1
                  )
                  .. two
            end
          end
        end
        return content
      end
    end

    starter.setup({
      items = {
        --starter.sections.telescope(),
        function()
          return {
            {
              name = 'Workspaces km <leader>wso',
              action = require('project-manager').open_projects,
              section = 'Workspaces'
            },
            {
              name = 'Workspace Probe km <leader>wsp',
              action = function()
                require('project-manager').open_project_by_key('probe')
              end,
              section = 'Workspaces'
            },
            {
              name = 'WorkSpace Third Party km <leader>wst',
              action = function()
                require('project-manager').open_project_by_key('third_party')
              end,
              section = 'Workspaces'
            },


            {
              name = 'Recent Files km <leader>? ',
              action = 'Telescope oldfiles',
              section = 'Files'
            },
            {
              name = 'File km <leader>sf',
              action = 'Telescope find_files',
              section = 'Files'
            },
            {
              name = 'Git Files km <leader>gf',
              action = 'Telescope git_files',
              section = 'Files'
            },


            {
              name = 'Neovim Config',
              action = 'lua require("spandan.plugins.custom.config_utils").open_neovim_config()',
              section = 'Configs'
            },
            {
              name = 'Hyprland Config',
              action = 'lua require("spandan.plugins.custom.config_utils").open_dotfiles()',
              section = 'Configs'
            },

            {
              name = 'Snake',
              action = 'SnakeStart',
              section = 'Games'
            },
            {
              name = '2048',
              action = 'Play2048',
              section = 'Games'
            },
            {
              name = 'Tetris',
              action = 'Tetris',
              section = 'Games'
            },
          }
        end
      },
      content_hooks = {
        starter.gen_hook.adding_bullet(' '),
        centralize({ "Workspaces", "Files" }, true),
      },
      header =
          '╔════════════════════════════════════════╗\n' ..
          '║ ██████╗ ██████╗       ██╗  ██╗██████╗  ║\n' ..
          '║ ██╔══██╗██╔══██╗      ██║  ██║╚════██╗ ║\n' ..
          '║ ██║  ██║██████╔╝█████╗███████║ █████╔╝ ║\n' ..
          '║ ██║  ██║██╔══██╗╚════╝╚════██║██╔═══╝  ║\n' ..
          '║ ██████╔╝██║  ██║           ██║███████╗ ║\n' ..
          '║ ╚═════╝ ╚═╝  ╚═╝           ╚═╝╚══════╝ ║\n' ..
          '║          Hesitation is defeat          ║\n' ..
          '╚════════════════════════════════════════╝',
    })
    local tabline = require('mini.tabline')
    tabline.setup()
  end,
}
