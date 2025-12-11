-- return {
--   'MeanderingProgrammer/render-markdown.nvim',
--   dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
--   -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
--   -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
--   setup = function(config)
--     require('render-markdown').enable()
--   end
-- }

return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"echasnovski/mini.nvim",
		"3rd/image.nvim", -- 1. Ensure image.nvim is a dependency
	},

	-- 2. Configure render-markdown to play nice with images
	opts = {
		-- This plugin usually handles text concealing, but image.nvim
		-- handles the actual image rendering.
		-- Default settings usually work fine, but you can tweak here.
	},
}
