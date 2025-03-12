local M = {}

function M.create_implementation()
  local file_extension = vim.fn.expand('%:e')
  if file_extension == 'h' then
    -- Get the absolute header file path.
    local header_path = vim.fn.expand('%:p')
    -- For the C file, remove the first occurrence of "/include" from the path and change the extension from .h to .c.
    local c_file_path = header_path:gsub('/include', '', 1):gsub('%.h$', '.c')

    -- Determine the header file's path relative to the /include directory.
    -- Look for "/include/" in the absolute header path.
    local include_marker = "/include/"
    local include_index = header_path:find(include_marker, 1, true) -- plain search for exact substring
    local relative_header = header_path                             -- fallback if not found
    if include_index then
      -- The relative path is the substring after "/include/".
      relative_header = header_path:sub(include_index + #include_marker)
    else
      print("Warning: '/include/' not found in header file path. Using full path in #include directive.")
    end

    -- Open the C file for writing.
    local c_file = io.open(c_file_path, 'w')
    if not c_file then
      print("Could not open file for writing: " .. c_file_path)
      return
    end

    -- Write the include directive using the relative header path.
    c_file:write('#include "' .. relative_header .. '"\n\n')

    -- Define a pattern that matches typical C function declarations.
    -- For example, it will match lines like:
    --    int my_function(char* arg);
    --
    -- Explanation of the pattern:
    --   ^%s*                                  -> optional leading whitespace at the start of the line
    --   [a-zA-Z_][a-zA-Z0-9_%s%*]*             -> the return type (letters, digits, underscores, spaces, and pointers)
    --   %s+                                   -> at least one space between the return type and function name
    --   [a-zA-Z_][a-zA-Z0-9_]*                 -> the function name
    --   %s*                                   -> optional whitespace
    --   %b()                                  -> a balanced pair of parentheses for the parameter list
    --   %s*;                                  -> optional whitespace followed by a semicolon
    --   %s*$                                  -> optional whitespace until the end of the line
    local func_pattern = '^%s*[a-zA-Z_][a-zA-Z0-9_%s%*]*%s+[a-zA-Z_][a-zA-Z0-9_]*%s*%b()%s*;%s*$'

    -- Open the header file for reading.
    local header_file = io.open(header_path, 'r')
    if not header_file then
      print("Could not open header file: " .. header_path)
      c_file:close()
      return
    end

    -- Read through the header and create blank implementations for each function declaration.
    for line in header_file:lines() do
      if string.match(line, func_pattern) then
        -- Remove the trailing semicolon and add a function body.
        local func_def = line:gsub(';%s*$', '')
        c_file:write(func_def .. " {\n\t// TODO: Implement this function\n}\n\n")
      end
    end

    header_file:close()
    c_file:close()
    print("Implementation file created at: " .. c_file_path)
  else
    print("Not a header file.")
  end
end

function M.create_guard()
  local file_name = vim.fn.expand('%:t')
  local file_extension = vim.fn.expand('%:e')
  if file_extension == 'h' then
    local guard = string.upper(file_name:gsub('%.', '_')):gsub('-', '_')
    local guard_str = string.format('#ifndef %s', guard, guard)
    -- Insert the file
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { guard_str })
    vim.api.nvim_buf_set_lines(0, 1, 1, false, { string.format('#define %s', guard) })
    -- Append the file
    vim.api.nvim_buf_set_lines(0, -1, -1, false, { string.format('#endif // %s', guard) })
    return
  end
end

function M.goto_implementation()
  local file_path = vim.fn.expand('%:p')
  local file_extension = vim.fn.expand('%:e')
  if file_extension == 'h' then
    local c_file_path = file_path:gsub('%.h$', '.c'):gsub('/include', '', 1)
    vim.cmd("e " .. c_file_path)
  end
end

function M.reset_nvim_tabs()
  vim.cmd("set shiftwidth=4")
  vim.cmd("set tabstop=4")
  vim.cmd("set softtabstop=4")
  vim.cmd("set noexpandtab")
end

return M
