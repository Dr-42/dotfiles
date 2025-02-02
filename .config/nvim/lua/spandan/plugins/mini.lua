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
    starter.setup({
      items = {
        --starter.sections.telescope(),
        function()
          return {
            { name = 'Open Workspaces',            action = "lua require('spandan.plugins.custom.workspace').open_project()",          section = 'Workspaces' },
            { name = 'Open Workspace Probe',       action = "lua require('spandan.plugins.custom.workspace').open_probe()",            section = 'Workspaces' },
            { name = 'Open WorkSpace Third Party', action = "lua require('spandan.plugins.custom.workspace').open_third_party()",      section = 'Workspaces' },

            { name = 'Open Recent Files',          action = 'Telescope oldfiles',                                                      section = 'Files' },
            { name = 'Open File',                  action = 'Telescope find_files',                                                    section = 'Files' },
            { name = 'Open Git Files',             action = 'Telescope git_files',                                                     section = 'Files' },

            { name = 'Open Neovim Config',         action = 'lua require("spandan.plugins.custom.config_utils").open_neovim_config()', section = 'Configs' },
            { name = 'Open Hyprland Config',       action = 'lua require("spandan.plugins.custom.config_utils").open_dotfiles()',      section = 'Configs' },

            { name = 'Play Snake',                 action = 'SnakeStart',                                                              section = 'Games' },
            { name = 'Play 2048',                  action = 'Play2048',                                                                section = 'Games' },
            { name = 'Play Tetris',                action = 'Tetris',                                                                  section = 'Games' },
          }
        end
      },
      content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.aligning('center', 'center'),
      },
      header =
      -- '░▒▓███████▓▒░░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░  \n' ..
      -- '░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░ \n' ..
      -- '░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░ \n' ..
      -- '░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓████████▓▒░░▒▓██████▓▒░  \n' ..
      -- '░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░        \n' ..
      -- '░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░        \n' ..
      -- '░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓████████▓▒░ \n',

      -- '__/\\\\\\\\\\\\\\\\\\\\\\\\___________________________________________/\\\\\\_______/\\\\\\\\\\\\\\\\\\_____        \n' ..
      -- ' _\\/\\\\\\////////\\\\\\                                       /\\\\\\\\\\     /\\\\\\///////\\\\\\          \n' ..
      -- '  _\\/\\\\\\______\\//\\\\\\____________________________________/\\\\\\/\\\\\\____\\///______\\//\\\\\\__      \n' ..
      -- '   _\\/\\\\\\       \\/\\\\\\  /\\\\/\\\\\\\\\\\\\\   /\\\\\\\\\\\\\\\\\\\\\\      /\\\\\\/\\/\\\\\\              /\\\\\\/        \n' ..
      -- '    _\\/\\\\\\_______\\/\\\\\\_\\/\\\\\\/////\\\\\\_\\///////////_____/\\\\\\/__\\/\\\\\\___________/\\\\\\//_____    \n' ..
      -- '     _\\/\\\\\\       \\/\\\\\\ \\/\\\\\\   \\///                 /\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\     /\\\\\\//           \n' ..
      -- '      _\\/\\\\\\_______/\\\\\\__\\/\\\\\\_______________________\\///////////\\\\\\//____/\\\\\\/___________  \n' ..
      -- '       _\\/\\\\\\\\\\\\\\\\\\\\\\\\/   \\/\\\\\\                                 \\/\\\\\\     /\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\  \n' ..
      -- '        _\\////////////_____\\///__________________________________\\///_____\\///////////////__\n',


          '█░░░░░░░░░░░░███░░░░░░░░░░░░░░░░██████████████████░░░░░░██░░░░░░█░░░░░░░░░░░░░░█\n' ..
          '█░░▄▀▄▀▄▀▄▀░░░░█░░▄▀▄▀▄▀▄▀▄▀▄▀░░██████████████████░░▄▀░░██░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█\n' ..
          '█░░▄▀░░░░▄▀▄▀░░█░░▄▀░░░░░░░░▄▀░░██████████████████░░▄▀░░██░░▄▀░░█░░░░░░░░░░▄▀░░█\n' ..
          '█░░▄▀░░██░░▄▀░░█░░▄▀░░████░░▄▀░░██████████████████░░▄▀░░██░░▄▀░░█████████░░▄▀░░█\n' ..
          '█░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░░░▄▀░░███░░░░░░░░░░░░░░█░░▄▀░░░░░░▄▀░░█░░░░░░░░░░▄▀░░█\n' ..
          '█░░▄▀░░██░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀▄▀░░███░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█\n' ..
          '█░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░▄▀░░░░███░░░░░░░░░░░░░░█░░░░░░░░░░▄▀░░█░░▄▀░░░░░░░░░░█\n' ..
          '█░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░████████████████████████████░░▄▀░░█░░▄▀░░█████████\n' ..
          '█░░▄▀░░░░▄▀▄▀░░█░░▄▀░░██░░▄▀░░░░░░████████████████████████░░▄▀░░█░░▄▀░░░░░░░░░░█\n' ..
          '█░░▄▀▄▀▄▀▄▀░░░░█░░▄▀░░██░░▄▀▄▀▄▀░░████████████████████████░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█\n' ..
          '█░░░░░░░░░░░░███░░░░░░██░░░░░░░░░░████████████████████████░░░░░░█░░░░░░░░░░░░░░█\n',
      footer = 'Hesitation is defeat',
    })
    local tabline = require('mini.tabline')
    tabline.setup()
  end,
}
