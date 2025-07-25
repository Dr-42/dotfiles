-- Custom configuration (defaults shown)
return {
	"jacob411/Ollama-Copilot",
	opts = {
		model_name = "deepseek-coder:6.7b",
		ollama_url = "", -- URL for Ollama server, Leave blank to use default local instance.
		stream_suggestion = true,
		python_command = "python3",
		filetypes = { "python", "lua", "vim", "markdown", "rust", "c" },
		ollama_model_opts = {
			num_predict = 40,
			temperature = 0.1,
		},
		keymaps = {
			suggestion = "<leader>os",
			reject = "<leader>or",
			insert_accept = "<Tab>",
		},
	},
}
