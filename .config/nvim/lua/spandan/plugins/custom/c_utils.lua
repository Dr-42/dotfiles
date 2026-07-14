local M = {}

-- Given an absolute header path, works out:
--   1. c_file_path      -- where the matching .c implementation file lives
--   2. relative_header  -- the path to use inside the generated #include "..."
--
-- Handles two layouts:
--
--   Namespaced (e.g. builder_cpp libraries shipped for installation):
--     <target_root>/include/<target_name>/<subpath>.h
--     -> c file at <target_root>/<subpath>.c
--     -> #include "<target_name>/<subpath>.h"
--   where <target_name> is exactly the last path component of <target_root>
--   (the directory /include/ itself sits inside) -- this is what makes
--   `#include <libsynovium/core/syn_arena.h>` resolve once installed
--   alongside other libraries' headers.
--
--   Flat (older, less rigorous projects, or any header where that
--   duplication doesn't hold):
--     <root>/include/<subpath>.h -> <root>/<subpath>.c
--
-- Both are handled by the same logic: only strip the duplicated
-- <target_name>/ prefix if it's actually there. If it isn't, nothing is
-- stripped and the flat layout falls out naturally.
local function split_header_path(header_path)
	local include_marker = "/include/"
	local include_index = header_path:find(include_marker, 1, true)

	if not include_index then
		-- No /include/ segment at all -- oldest, flattest case: source and
		-- header live side by side, just swap the extension.
		return header_path, header_path
	end

	local target_root = header_path:sub(1, include_index - 1)
	local after_include = header_path:sub(include_index + #include_marker)
	local relative_header = after_include

	local target_name = target_root:match("([^/]+)$")
	local subpath = after_include
	if target_name and after_include:sub(1, #target_name + 1) == (target_name .. "/") then
		-- Namespaced layout: strip the duplicated <target_name>/ prefix so the
		-- .c file lands back under target_root directly.
		subpath = after_include:sub(#target_name + 2)
	end

	local c_file_path = target_root .. "/" .. subpath
	return c_file_path, relative_header
end

function M.create_implementation()
	local file_extension = vim.fn.expand("%:e")
	if file_extension == "h" then
		local header_path = vim.fn.expand("%:p")
		local c_file_path, relative_header = split_header_path(header_path)
		c_file_path = c_file_path:gsub("%.h$", ".c")

		-- Open the C file for writing.
		local c_file = io.open(c_file_path, "w")
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
		local func_pattern = "^%s*[a-zA-Z_][a-zA-Z0-9_%s%*]*%s+[a-zA-Z_][a-zA-Z0-9_]*%s*%b()%s*;%s*$"

		-- Open the header file for reading.
		local header_file = io.open(header_path, "r")
		if not header_file then
			print("Could not open header file: " .. header_path)
			c_file:close()
			return
		end

		-- Read through the header and create blank implementations for each function declaration.
		for line in header_file:lines() do
			if string.match(line, func_pattern) then
				-- Remove the trailing semicolon and add a function body.
				local func_def = line:gsub(";%s*$", "")
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
	local file_name = vim.fn.expand("%:t")
	local file_extension = vim.fn.expand("%:e")
	if file_extension == "h" then
		local guard = string.upper(file_name:gsub("%.", "_")):gsub("-", "_")
		local guard_str = string.format("#ifndef %s", guard, guard)
		-- Insert the file
		vim.api.nvim_buf_set_lines(0, 0, 0, false, { guard_str })
		vim.api.nvim_buf_set_lines(0, 1, 1, false, { string.format("#define %s", guard) })
		-- Append the file
		vim.api.nvim_buf_set_lines(0, -1, -1, false, { string.format("#endif // %s", guard) })
		return
	end
end

function M.goto_implementation()
	local file_path = vim.fn.expand("%:p")
	local file_extension = vim.fn.expand("%:e")
	if file_extension == "h" then
		local c_file_path = split_header_path(file_path):gsub("%.h$", ".c")
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
