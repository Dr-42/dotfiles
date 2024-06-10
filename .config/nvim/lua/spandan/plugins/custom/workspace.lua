local M = {}

local find_project_language = function(path)
  -- Get the language of the project
  local project_language = "unknown"
  local project_files = vim.fn.glob("`find " .. path .. " -type f`", false, true)
  for _, file in ipairs(project_files) do
    if string.match(file, "%.py$") then
      project_language = "python"
      break
    elseif string.match(file, "%.rs$") then
      project_language = "rust"
      break
    elseif string.match(file, "%.go$") then
      project_language = "go"
      break
    elseif string.match(file, "%.js$") or string.match(file, "%.ts$") then
      project_language = "javascript"
      break
    elseif string.match(file, "%.java$") then
      project_language = "java"
      break
    elseif string.match(file, "%.c$") or string.match(file, "%.h$") then
      project_language = "c"
      break
    elseif string.match(file, "%.cpp$") or string.match(file, "%.hpp$") then
      project_language = "cpp"
      break
    end
  end
  return project_language
end

local function get_language_icon(language)
  local webdevicons = require("nvim-web-devicons")
  local python, py_color = webdevicons.get_icon("some.py", "py")
  local rust, rust_color = webdevicons.get_icon("some.rs", "rs")
  local go, go_color = webdevicons.get_icon("some.go", "go")
  local javascript, js_color = webdevicons.get_icon("some.js", "js")
  local java, java_color = webdevicons.get_icon("some.java", "java")
  local c, c_color = webdevicons.get_icon("some.c", "c")
  local cpp, cpp_color = webdevicons.get_icon("some.cpp", "cpp")

  local icons = {
    python = { python, py_color },
    rust = { rust, rust_color },
    go = { go, go_color },
    javascript = { javascript, js_color },
    java = { java, java_color },
    c = { c, c_color },
    cpp = { cpp, cpp_color },
    unknown = { "", "#eeeeee" },
  }
  return icons[language]
end

local open_project_i = function(root_path)
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
    if name == "probe" or name == "third_pary" then
      goto continue
    end
    local language = find_project_language(project_dir)
    local icon = get_language_icon(language)
    -- Prepend the language icon to the project name and color the icon
    name = icon[1] .. " " .. name
    table.insert(project_names, { project_dir .. "/README.md", name })
    table.insert(project_paths, project_dir)
    ::continue::
  end
  local get_readme = function(path)
    local readme = path .. "/README.md"
    if vim.fn.filereadable(readme) == 1
    then
      return vim.fn.readfile(readme)
    else
      return ""
    end
  end
  pickers.new({}, {
    prompt_title = "Project",
    finder = finders.new_table {
      results = project_names,
      entry_maker = function(entry)
        return {
          value = entry[1],
          display = entry[2],
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
