-- lua/plugins/lsp/bash.lua
-- BASH Language Server Configuration using bash-language-server
-- Provides real-time syntax checking and error detection

-- Load LSP config and common setup
local utils = require("core.utils")
local lspconfig = utils.safe_require("lspconfig")
local lsp_common = utils.safe_require("plugins.lsp-common")

if not lspconfig or not lsp_common then
	return
end

-- BASH specific configuration
local bash_config = {
	-- Use common LSP setup (keybindings, capabilities, etc.)
	on_attach = lsp_common.on_attach,
	capabilities = lsp_common.get_capabilities(),

	-- BASH Language Server settings
	settings = {
		bashIde = {
			-- Enable shellcheck integration (if installed)
			shellcheckPath = "shellcheck",

			-- Glob pattern for shell script identification
			globPattern = "*@(.sh|.inc|.bash|.command)",
		},
	},

	-- File types to attach to
	filetypes = { "sh", "bash" },

	-- Root directory detection
	root_dir = lspconfig.util.root_pattern(".git", vim.fn.getcwd()),

	-- Single file support
	single_file_support = true,
}

-- Setup BASH LSP
lspconfig.bashls.setup(bash_config)

-- BASH-specific autocommands
local bash_group = vim.api.nvim_create_augroup("BashLSP", { clear = true })

-- BASH file type specific settings
vim.api.nvim_create_autocmd("FileType", {
	group = bash_group,
	pattern = { "sh", "bash" },
	callback = function()
		-- BASH-specific vim settings
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = true
	end,
})

-- Success notification
vim.notify("BASH LSP (bashls) configured successfully! 🐚", vim.log.levels.INFO)
