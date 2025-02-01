local function find_mc_ext(path, allowed_exts)
  -- Build the command: change to the target directory then list non-ignored files.
  local cmd = string.format("cd %q && git ls-files --exclude-standard -co", path)

  -- Run the command; vim.fn.systemlist returns a table of output lines.
  local files = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_err_writeln("Error: 'git ls-files' failed. Is the directory a Git repository?")
    return nil
  end

  -- Count file extensions
  local ext_counts = {}
  for _, file in ipairs(files) do
    -- Extract extension: everything after the last dot.
    local ext = file:match("%.([^%.]+)$")
    for _, allowed_ext in pairs(allowed_exts) do
      if ext == allowed_ext then
        ext_counts[ext] = (ext_counts[ext] or 0) + 1
        goto continue
      end
    end
    ::continue::
  end


  -- Find the most common extension.
  local most_common = nil
  local highest = 0
  for ext, count in pairs(ext_counts) do
    if count > highest then
      most_common = ext
      highest = count
    end
  end
  return most_common
end

local M = {}

local function get_language_icon(language)
  local webdevicons = require("nvim-web-devicons")
  if language == nil then
    return { "", "TelescopeResultsDefaultIcon" }
  else
    local icon, color = webdevicons.get_icon("some." .. language, language)
    return { icon, color }
  end
end

local open_project_i = function(root_path)
  local recognised_exts = { "c", "ts", "rs", "cpp", "vue", "py", "lua", "dart", "js", "cs", "vim", "kt", "qml", "cu",
    "sh", "s" }

  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local conf = require("telescope.config").values
  -- Get names of all folders in the $HOME/Projects directory
  local projects_dir = root_path
  local projects_dir_content = vim.split(vim.fn.glob(projects_dir .. "/*"), '\n', { trimempty = true })
  local project_names = {}
  local project_paths = {}
  for _, project_dir in ipairs(projects_dir_content) do
    local name = string.sub(project_dir, string.len(projects_dir) + 2)
    if name == "probe" or name == "third_party" then
      goto continue
    end
    local ext = find_mc_ext(project_dir, recognised_exts)
    local icon = get_language_icon(ext)
    -- Prepend the language icon to the project name and color the icon
    table.insert(project_names, { project_dir .. "/README.md", name, icon })
    table.insert(project_paths, project_dir)
    ::continue::
  end
  pickers.new({}, {
    prompt_title = "Project",
    finder = finders.new_table {
      results = project_names,
      entry_maker = function(entry)
        local entry_display = require("telescope.pickers.entry_display")
        return {
          value = entry[1],
          display = function()
            local displayer = entry_display.create({
              separator = " ",
              items = {
                { width = 1 },
                { remaining = true },
              },
            })

            return displayer({
              { entry[3][1], entry[3][2] },
              { entry[2],    "TelescopeResultsDescription" },
            })
          end,
          ordinal = entry[2],
        }
      end
    },
    sorter = conf.generic_sorter({}),
    -- Display the README.md file if it exists in the preview window
    previewer = conf.file_previewer({}),
    -- Open the selected project ie make it the current working directory and open it in a new buffer
    attach_mappings = function(prompt_bufnr, map)
      local open_proj = function()
        local selection = require("telescope.actions.state").get_selected_entry()
        vim.cmd("cd " .. project_paths[selection.index])
        vim.cmd("e! .")
      end
      map("i", "<CR>", open_proj)
      map("n", "<CR>", open_proj)
      return true
    end,
  }):find()
end

M.open_project = function()
  open_project_i(vim.env.HOME .. "/Projects")
end

M.open_probe = function()
  open_project_i(vim.env.HOME .. "/Projects/probe")
end

M.open_third_party = function()
  open_project_i(vim.env.HOME .. "/Projects/third_party")
end

return M
