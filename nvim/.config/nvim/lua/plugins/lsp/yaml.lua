-- lua/plugins/lsp/yaml.lua
-- YAML Language Server Configuration
-- Handles YAML validation, completion, and schema support

-- Load LSP config and common setup
local utils = require("core.utils")
local lspconfig = utils.safe_require("lspconfig")
local lsp_common = utils.safe_require("plugins.lsp-common")

if not lspconfig or not lsp_common then
	return
end

-- YAML specific configuration
local yaml_config = {
	-- Use common LSP setup (keybindings, capabilities, etc.)
	on_attach = lsp_common.on_attach,
	capabilities = lsp_common.get_capabilities(),

	-- YAML Language Server settings
	settings = {
		yaml = {
			-- Schema validation
			validate = true,

			-- Hover information
			hover = true,

			-- Completion support
			completion = true,

			-- Schema store (provides schemas for common files)
			schemaStore = {
				enable = true,
				url = "https://www.schemastore.org/api/json/catalog.json",
			},

			-- Custom schemas for specific file patterns
			schemas = {
				-- Docker Compose schema
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
					"docker-compose*.yml",
					"docker-compose*.yaml",
					"compose*.yml",
					"compose*.yaml",
				},

				-- GitHub Actions schema
				["https://json.schemastore.org/github-workflow.json"] = {
					".github/workflows/*.yml",
					".github/workflows/*.yaml",
				},

				-- Kubernetes schemas
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.0-standalone-strict/all.json"] = {
					"k8s/**/*.yaml",
					"k8s/**/*.yml",
					"kubernetes/**/*.yaml",
					"kubernetes/**/*.yml",
				},
			},

			-- Format settings
			format = {
				enable = true,
				singleQuote = false,
				bracketSpacing = true,
				proseWrap = "preserve",
				printWidth = 80,
			},

			-- Custom tags (useful for docker-compose and other tools)
			customTags = {
				"!reference sequence", -- GitLab CI
				"!reference scalar", -- GitLab CI
			},
		},
	},

	-- File types to attach to
	filetypes = { "yaml", "yml" },

	-- Root directory detection
	root_dir = lspconfig.util.root_pattern(
		".git",
		"docker-compose.yml",
		"docker-compose.yaml",
		"compose.yml",
		"compose.yaml"
	),

	-- Single file support
	single_file_support = true,

	-- Initialize options
	init_options = {
		-- Suggest schemas based on file patterns
		suggest = {
			fromDefaultSchemaStore = true,
		},
	},
}

-- Setup YAML LSP
lspconfig.yamlls.setup(yaml_config)

-- YAML-specific autocommands
local yaml_group = vim.api.nvim_create_augroup("YamlLSP", { clear = true })

-- Enhanced YAML-specific keybindings
vim.api.nvim_create_autocmd("FileType", {
	group = yaml_group,
	pattern = { "yaml", "yml" },
	callback = function()
		local opts = { noremap = true, silent = true, buffer = true }

		-- YAML-specific mappings
		vim.keymap.set(
			"n",
			"<leader>ys",
			":YamlSchema<CR>",
			vim.tbl_extend("force", opts, { desc = "Show YAML schema info" })
		)

		-- Quick schema validation
		vim.keymap.set("n", "<leader>yv", function()
			vim.diagnostic.setqflist()
			vim.cmd("copen")
		end, vim.tbl_extend("force", opts, { desc = "Show YAML validation errors" }))
	end,
})

-- Custom command to show current YAML schema
vim.api.nvim_create_user_command("YamlSchema", function()
	local clients = vim.lsp.get_active_clients({ bufnr = 0, name = "yamlls" })
	if #clients == 0 then
		vim.notify("YAML LSP not active in current buffer", vim.log.levels.WARN)
		return
	end

	-- Request schema information
	local params = vim.lsp.util.make_position_params()
	vim.lsp.buf_request(0, "yaml/get/jsonSchema", params, function(err, result)
		if err then
			vim.notify("Error getting schema: " .. err.message, vim.log.levels.ERROR)
			return
		end

		if result and result.uri then
			vim.notify("Current schema: " .. result.uri, vim.log.levels.INFO)
		else
			vim.notify("No schema detected for this file", vim.log.levels.INFO)
		end
	end)
end, { desc = "Show current YAML schema information" })

-- YAML formatting configuration update needed
-- Add this to your existing formatting.lua file in the formatters_by_ft section:
-- yaml = { "prettier" },
-- yml = { "prettier" },

-- Success notification
vim.notify("YAML LSP (yamlls) configured successfully! 📄", vim.log.levels.INFO)
