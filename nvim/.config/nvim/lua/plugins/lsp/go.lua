-- lua/plugins/lsp/go.lua
-- Go Language Server Configuration using gopls
-- Google's official Go LSP - top tier performance and features

-- Load LSP config and common setup
local utils = require("core.utils")
local lspconfig = utils.safe_require("lspconfig")
local lsp_common = utils.safe_require("plugins.lsp-common")

if not lspconfig or not lsp_common then
	return
end

-- Go/gopls specific configuration
local go_config = {
	-- Use common LSP setup (keybindings, capabilities, etc.)
	on_attach = function(client, bufnr)
		-- Call common setup first
		lsp_common.on_attach(client, bufnr)

		-- Go-specific keybindings
		local opts = { noremap = true, silent = true, buffer = bufnr }

		-- Go-specific mappings
		vim.keymap.set("n", "<leader>gt", ":GoTest<CR>", vim.tbl_extend("force", opts, { desc = "Run Go tests" }))
		vim.keymap.set(
			"n",
			"<leader>gT",
			":GoTestFile<CR>",
			vim.tbl_extend("force", opts, { desc = "Run current file tests" })
		)
		vim.keymap.set(
			"n",
			"<leader>gc",
			":GoCoverage<CR>",
			vim.tbl_extend("force", opts, { desc = "Show test coverage" })
		)
		vim.keymap.set(
			"n",
			"<leader>gi",
			":GoImports<CR>",
			vim.tbl_extend("force", opts, { desc = "Organize imports" })
		)
		vim.keymap.set("n", "<leader>gf", ":GoFillStruct<CR>", vim.tbl_extend("force", opts, { desc = "Fill struct" }))
		vim.keymap.set("n", "<leader>ge", ":GoIfErr<CR>", vim.tbl_extend("force", opts, { desc = "Add if err != nil" }))

		print("Go LSP (gopls) attached with Go-specific keybindings")
	end,

	capabilities = lsp_common.get_capabilities(),

	-- Gopls specific settings
	settings = {
		gopls = {
			-- Analysis settings
			analyses = {
				unusedparams = true,
				shadow = true,
				nilness = true,
				unusedwrite = true,
				useany = true,
			},

			-- Static check analyzers (like golint)
			staticcheck = true,

			-- Experimental features
			experimentalPostfixCompletions = true,

			-- Code lens settings
			codelenses = {
				gc_details = true, -- Show GC optimization details
				generate = true, -- Show "go generate" lenses
				regenerate_cgo = true, -- Show "go generate" for cgo
				test = true, -- Show "run test" lenses
				tidy = true, -- Show "go mod tidy" lenses
				upgrade_dependency = true, -- Show dependency upgrade options
				vendor = true, -- Show "go mod vendor" lenses
			},

			-- Completion settings
			usePlaceholders = true, -- Use placeholders in completions
			completeUnimported = true, -- Complete unimported packages
			deepCompletion = true, -- Deep completion analysis

			-- Import organization
			gofumpt = true, -- Use gofumpt for formatting (stricter than gofmt)

			-- Semantic tokens (better syntax highlighting)
			semanticTokens = true,

			-- Hints and inlays
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},

	-- File types to attach to
	filetypes = { "go", "gomod", "gowork", "gotmpl" },

	-- Root directory detection - Go projects
	root_dir = lspconfig.util.root_pattern(
		"go.work", -- Go workspace
		"go.mod", -- Go module
		".git" -- Fallback to git repo
	),

	-- Single file support
	single_file_support = true,

	-- Initialization options
	init_options = {
		usePlaceholders = true,
	},
}

-- Setup Go LSP
lspconfig.gopls.setup(go_config)

-- Go-specific autocommands
local go_group = vim.api.nvim_create_augroup("GoLSP", { clear = true })

-- Auto-organize imports on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = go_group,
	pattern = "*.go",
	callback = function()
		-- Use goimports through LSP
		local params = vim.lsp.util.make_range_params(nil, "utf-16")
		params.context = { only = { "source.organizeImports" } }

		local timeout_ms = 1000
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)

		if result and result[1] and result[1].result then
			for _, action in ipairs(result[1].result) do
				if action.edit then
					vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
				end
			end
		end
	end,
})

-- Auto-format on save (handled by conform.nvim, but backup here)
vim.api.nvim_create_autocmd("BufWritePre", {
	group = go_group,
	pattern = "*.go",
	callback = function()
		-- Only format if no external formatter (conform.nvim should handle this)
		local conform_available = pcall(require, "conform")
		if not conform_available then
			vim.lsp.buf.format({ async = false })
		end
	end,
})

-- Custom Go commands
vim.api.nvim_create_user_command("GoTest", function()
	vim.cmd("!go test ./...")
end, { desc = "Run all Go tests" })

vim.api.nvim_create_user_command("GoTestFile", function()
	local file = vim.fn.expand("%:t:r")
	vim.cmd("!go test -run " .. file)
end, { desc = "Run tests for current file" })

vim.api.nvim_create_user_command("GoCoverage", function()
	vim.cmd("!go test -cover ./...")
end, { desc = "Run Go tests with coverage" })

vim.api.nvim_create_user_command("GoImports", function()
	-- Trigger organize imports
	vim.lsp.buf.code_action({
		context = { only = { "source.organizeImports" } },
		apply = true,
	})
end, { desc = "Organize Go imports" })

vim.api.nvim_create_user_command("GoFillStruct", function()
	-- Request fill struct code action
	vim.lsp.buf.code_action({
		context = { only = { "refactor.rewrite" } },
		apply = false,
	})
end, { desc = "Fill Go struct" })

vim.api.nvim_create_user_command("GoIfErr", function()
	-- Simple if err != nil snippet (basic implementation)
	local line = vim.api.nvim_get_current_line()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local indent = string.match(line, "^%s*") or ""

	local err_block = {
		indent .. "if err != nil {",
		indent .. "\treturn err",
		indent .. "}",
	}

	vim.api.nvim_buf_set_lines(0, cursor[1], cursor[1], false, err_block)
end, { desc = "Add if err != nil block" })

-- Go file type specific settings
vim.api.nvim_create_autocmd("FileType", {
	group = go_group,
	pattern = "go",
	callback = function()
		-- Go-specific vim settings
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = false -- Go uses tabs, not spaces
		vim.opt_local.textwidth = 100 -- Go community standard

		-- Enable inlay hints if available
		if vim.lsp.inlay_hint then
			vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
		end
	end,
})

-- Success notification
vim.notify("Go LSP (gopls) configured successfully! 🐹", vim.log.levels.INFO)
