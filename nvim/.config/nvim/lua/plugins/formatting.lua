-- lua/plugins/formatting.lua
-- Shared formatting configuration using conform.nvim
-- Supports multiple languages with individual formatters
local utils = require("core.utils")

local conform = utils.safe_require("conform")
if not conform then
	return
end

-- Configure conform with formatters for different languages
conform.setup({
	-- Formatters by file type
	formatters_by_ft = {
		-- Python formatting
		python = {
			"isort", -- Import organization (first)
			"black", -- Code formatting (second)
		},

		lua = { "stylua" },

		-- Future language support (ready to uncomment)
		-- go = { "gofmt", "goimports" },
		-- php = { "php_cs_fixer" },
		-- javascript = { "prettier" },
		-- typescript = { "prettier" },
		-- html = { "prettier" },
		-- css = { "prettier" },
		-- json = { "prettier" },
		-- yaml = { "prettier" },
		-- markdown = { "prettier" },
	},

	-- Formatter-specific configuration
	formatters = {
		-- Black configuration
		black = {
			prepend_args = {
				"--line-length=88", -- Standard Black line length
				"--target-version=py38", -- Python version target
			},
		},

		-- isort configuration
		isort = {
			prepend_args = {
				"--profile=black", -- Make isort compatible with Black
				"--multi-line=3",
				"--trailing-comma",
				"--force-grid-wrap=0",
				"--combine-as",
				"--line-width=88",
			},
		},

		-- Style Configurations
		stylua = {
			args = { "--stdin-filepath", "$FILENAME", "-" },
		},

		-- Future formatter configs can go here
		-- prettier = {
		--     prepend_args = { "--tab-width=2", "--single-quote" },
		-- },
	},

	-- Default options
	default_format_opts = {
		lsp_format = "fallback", -- Use LSP if conform formatter not available
		timeout_ms = 3000, -- Timeout for formatting
		async = false, -- Synchronous by default (can be changed per call)
	},

	-- Notification settings
	notify_on_error = true,
	notify_no_formatters = true,
})

-- Enhanced format function that provides feedback
local function format_buffer()
	local buf = vim.api.nvim_get_current_buf()
	local ft = vim.bo[buf].filetype

	-- Check if we have formatters for this filetype
	local formatters = conform.list_formatters(buf)

	if #formatters == 0 then
		-- Fall back to LSP formatting
		vim.lsp.buf.format({ async = false })
		vim.notify("Formatted with LSP (no conform formatters available)", vim.log.levels.INFO)
		return
	end

	-- Use conform formatting
	conform.format({
		bufnr = buf,
		async = false,
		timeout_ms = 3000,
	}, function(err)
		if err then
			vim.notify("Formatting failed: " .. err, vim.log.levels.ERROR)
		else
			local formatter_names = {}
			for _, formatter in ipairs(formatters) do
				table.insert(formatter_names, formatter.name)
			end
			vim.notify("Formatted with: " .. table.concat(formatter_names, ", "), vim.log.levels.INFO)
		end
	end)
end

-- Simple, working format keybinding
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({ async = false })
end, {
	desc = "Format buffer with conform.nvim",
	noremap = true,
	silent = true,
})

-- Format on save (optional - can be enabled per filetype)
local format_on_save_group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })

-- Simple auto-format with graceful error handling
vim.api.nvim_create_autocmd("BufWritePre", {
    group = format_on_save_group,
    pattern = "*",
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local formatters = conform.list_formatters(buf)
        
        if #formatters > 0 then
            local success, err = pcall(conform.format, {
                bufnr = buf,
                async = false,
                timeout_ms = 2000,
            })
            
            if not success then
                vim.notify("Format failed: " .. tostring(err) .. " - saving anyway", vim.log.levels.WARN)
            end
        end
    end,
})

-- Additional formatting commands
vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end

	conform.format({
		async = true,
		range = range,
		timeout_ms = 3000,
	})
end, {
	range = true,
	desc = "Format current buffer or range",
})

-- Command to show available formatters
vim.api.nvim_create_user_command("FormattersInfo", function()
	local buf = vim.api.nvim_get_current_buf()
	local formatters = conform.list_formatters(buf)

	if #formatters == 0 then
		vim.notify("No formatters available for " .. vim.bo.filetype, vim.log.levels.WARN)
		return
	end

	local info = {}
	for _, formatter in ipairs(formatters) do
		table.insert(info, formatter.name .. " (" .. (formatter.available and "available" or "not available") .. ")")
	end

	vim.notify("Available formatters: " .. table.concat(info, ", "), vim.log.levels.INFO)
end, { desc = "Show available formatters for current buffer" })

-- Success notification
vim.notify("Shared formatting system configured! 🛠️", vim.log.levels.INFO)
