local M = {}

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

return M
