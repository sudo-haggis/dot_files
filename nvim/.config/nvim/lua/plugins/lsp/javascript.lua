-- lua/plugins/lsp/javascript.lua
-- JavaScript/TypeScript Language Server Configuration using typescript-language-server

-- Load LSP config and common setup
local utils = require("core.utils")
local lspconfig = utils.safe_require("lspconfig")
local lsp_common = utils.safe_require("plugins.lsp-common")

if not lspconfig or not lsp_common then
	return
end

-- JavaScript/TypeScript specific configuration
local js_ts_config = {
	-- Use common LSP setup (keybindings, capabilities, etc.)
	on_attach = lsp_common.on_attach,
	capabilities = lsp_common.get_capabilities(),

	-- TypeScript Language Server specific settings
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
			suggest = {
				includeCompletionsForModuleExports = true,
			},
			preferences = {
				disableSuggestions = false,
				quotePreference = "auto",
				includePackageJsonAutoImports = "auto",
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
			suggest = {
				includeCompletionsForModuleExports = true,
			},
			preferences = {
				disableSuggestions = false,
				quotePreference = "auto",
				includePackageJsonAutoImports = "auto",
			},
		},
	},

	-- File types to attach to
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},

	-- Root directory detection (finds project root)
	root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),

	-- Single file support
	single_file_support = true,

	-- Additional initialization options
	init_options = {
		preferences = {
			disableSuggestions = false,
		},
	},
}

-- Setup TypeScript Language Server (using modern ts_ls)
lspconfig.ts_ls.setup(js_ts_config)

-- JavaScript/TypeScript-specific autocommands
local js_ts_group = vim.api.nvim_create_augroup("JavaScriptTypeScriptLSP", { clear = true })

-- Auto-organize imports on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = js_ts_group,
	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
	callback = function()
		-- Only organize imports if LSP is active
		local clients = vim.lsp.get_active_clients({ bufnr = 0 })
		for _, client in ipairs(clients) do
			if client.name == "ts_ls" then
				-- Organize imports
				vim.lsp.buf.execute_command({
					command = "_typescript.organizeImports",
					arguments = { vim.api.nvim_buf_get_name(0) },
				})
			end
		end
	end,
})

-- Enhanced JavaScript/TypeScript-specific keybindings
vim.api.nvim_create_autocmd("FileType", {
	group = js_ts_group,
	pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	callback = function()
		local opts = { noremap = true, silent = true, buffer = true }

		-- TypeScript/JavaScript specific mappings
		vim.keymap.set(
			"n",
			"<leader>oi",
			":TSLspOrganizeImports<CR>",
			vim.tbl_extend("force", opts, { desc = "Organize imports" })
		)

		vim.keymap.set(
			"n",
			"<leader>ru",
			":TSLspRemoveUnused<CR>",
			vim.tbl_extend("force", opts, { desc = "Remove unused variables" })
		)

		vim.keymap.set(
			"n",
			"<leader>rf",
			":TSLspRenameFile<CR>",
			vim.tbl_extend("force", opts, { desc = "Rename file and update imports" })
		)

		vim.keymap.set(
			"n",
			"<leader>ai",
			":TSLspAddMissingImports<CR>",
			vim.tbl_extend("force", opts, { desc = "Add missing imports" })
		)
	end,
})

-- Custom commands for TypeScript features
vim.api.nvim_create_user_command("TSLspOrganizeImports", function()
	vim.lsp.buf.execute_command({
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
	})
end, { desc = "Organize TypeScript/JavaScript imports" })

vim.api.nvim_create_user_command("TSLspRemoveUnused", function()
	vim.lsp.buf.execute_command({
		command = "_typescript.removeUnused",
		arguments = { vim.api.nvim_buf_get_name(0) },
	})
end, { desc = "Remove unused TypeScript/JavaScript variables" })

vim.api.nvim_create_user_command("TSLspRenameFile", function()
	local current_file = vim.api.nvim_buf_get_name(0)
	local new_name = vim.fn.input("New filename: ", vim.fn.expand("%:t"))
	if new_name ~= "" then
		vim.lsp.buf.execute_command({
			command = "_typescript.renameFile",
			arguments = {
				{
					sourceUri = current_file,
					targetUri = vim.fn.expand("%:h") .. "/" .. new_name,
				},
			},
		})
	end
end, { desc = "Rename TypeScript/JavaScript file and update imports" })

vim.api.nvim_create_user_command("TSLspAddMissingImports", function()
	vim.lsp.buf.execute_command({
		command = "_typescript.addMissingImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
	})
end, { desc = "Add missing TypeScript/JavaScript imports" })

-- Diagnostic configuration specific to JS/TS
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		source = "if_many",
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		source = "always",
		border = "rounded",
	},
}, vim.api.nvim_create_namespace("js_ts_diagnostics"))

-- Success notification
vim.notify("JavaScript/TypeScript LSP (tsserver) configured successfully! ⚡", vim.log.levels.INFO)
