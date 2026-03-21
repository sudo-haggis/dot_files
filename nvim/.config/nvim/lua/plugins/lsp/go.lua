-- lua/plugins/lsp/go.lua
-- Go Language Server Configuration using gopls
-- Google's official Go LSP - top tier performance and features

-- Load LSP config and common setup
local utils = require("core.utils")
local lsp_common = utils.safe_require("plugins.lsp-common")

if not lsp_common then
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
	root_dir = function(fname)
		return vim.fs.root(fname, { "go.work", "go.mod", ".git" })
	end,

	-- Single file support
	single_file_support = true,

	-- Initialization options
	init_options = {
		usePlaceholders = true,
	},
}

-- Setup Go LSP
vim.lsp.config("gopls", go_config)
vim.lsp.enable("gopls")

-- Go-specific autocommands
local go_group = vim.api.nvim_create_augroup("GoLSP", { clear = true })

-- Auto-organize imports on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = go_group,
	pattern = "*.go",
	callback = function()
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
		local conform_available = pcall(require, "conform")
		if not conform_available then
			vim.lsp.buf.format({ async = false })
		end
	end,
})

-- Success notification
vim.notify("Go LSP (gopls) configured successfully! 🐹", vim.log.levels.INFO)
