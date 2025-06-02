-- Treesitter configuration
local M = {}

function M.setup()
	local treesitter = require("nvim-treesitter.configs")

	treesitter.setup({
		-- Install parsers for these languages
		ensure_installed = {
			"lua",
			"vim",
			"vimdoc",
			"go",
			"php",
			"yaml",
			"json",
			"javascript",
			"typescript",
			"python",
			"bash",
			"markdown",
			"html",
			"css",
		},

		-- Install parsers synchronously (only applied to `ensure_installed`)
		sync_install = false,

		-- Automatically install missing parsers when entering buffer
		auto_install = true,

		-- Enable syntax highlighting
		highlight = {
			enable = true,
			-- Disable slow treesitter highlight for large files
			disable = function(lang, buf)
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
		},

		-- Enable indentation
		indent = {
			enable = true,
		},

		-- Enable incremental selection
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm",
			},
		},
	})
end

-- Call setup
M.setup()

return M
