-- lua/plugins/enhanced-diagnostics.lua
-- Enhanced LSP diagnostic display with better formatting
-- Makes error messages appear in readable boxes with proper positioning

local M = {}

function M.setup()
	-- Enhanced diagnostic configuration
	vim.diagnostic.config({
		-- Virtual text settings - keep it minimal since we'll use float
		virtual_text = {
			enabled = true,
			severity = vim.diagnostic.severity.ERROR, -- Only show errors inline
			source = "if_many",
			format = function(diagnostic)
				-- Truncate long messages for virtual text
				local message = diagnostic.message
				if #message > 50 then
					return "💥 " .. message:sub(1, 47) .. "..."
				end
				return "💥 " .. message
			end,
			prefix = "", -- Remove default prefix since we add emoji
			spacing = 2,
		},

		-- Sign column indicators
		signs = {
			severity = {
				min = vim.diagnostic.severity.HINT,
			},
		},

		-- Underline errors
		underline = {
			severity = {
				min = vim.diagnostic.severity.WARN,
			},
		},

		-- Enhanced floating window configuration
		float = {
			-- Window styling
			border = "rounded",
			source = "always", -- Always show source (LSP name)
			header = "", -- Custom header
			prefix = "", -- Custom prefix per line
			suffix = "",

			-- Positioning - appear above cursor when possible
			focusable = true,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },

			-- Custom formatting function
			format = function(diagnostic)
				local source = diagnostic.source or "LSP"
				local code = diagnostic.code and (" [" .. diagnostic.code .. "]") or ""
				local severity_icons = {
					[vim.diagnostic.severity.ERROR] = "❌",
					[vim.diagnostic.severity.WARN] = "⚠️ ",
					[vim.diagnostic.severity.INFO] = "ℹ️ ",
					[vim.diagnostic.severity.HINT] = "💡",
				}

				local icon = severity_icons[diagnostic.severity] or "📝"
				local severity_name = vim.diagnostic.severity[diagnostic.severity]

				-- Format the message with proper line breaks
				local message = diagnostic.message
				-- Break long lines at natural points
				message = message:gsub("(%S+)%s*,%s*", "%1,\n    ")
				message = message:gsub(" but ", "\n  but ")
				message = message:gsub(" at ", "\n  at ")

				return string.format("%s %s%s\n📍 Source: %s", icon, message, code, source)
			end,
		},

		-- Update diagnostics in insert mode (can be disabled if distracting)
		update_in_insert = false,

		-- Sort by severity
		severity_sort = true,
	})

	-- Define custom diagnostic signs with better icons
	local signs = {
		{ name = "DiagnosticSignError", text = "❌" },
		{ name = "DiagnosticSignWarn", text = "⚠️" },
		{ name = "DiagnosticSignHint", text = "💡" },
		{ name = "DiagnosticSignInfo", text = "ℹ️" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	-- Custom keybindings for better diagnostic navigation
	local opts = { noremap = true, silent = true }

	-- Show diagnostic in floating window (enhanced)
	vim.keymap.set("n", "<leader>e", function()
		vim.diagnostic.open_float(0, {
			scope = "cursor",
			border = "rounded",
			max_width = 80,
			max_height = 20,
		})
	end, vim.tbl_extend("force", opts, { desc = "Show diagnostic details" }))

	-- Show all buffer diagnostics in quickfix
	vim.keymap.set("n", "<leader>E", function()
		vim.diagnostic.setqflist()
		vim.cmd("copen")
	end, vim.tbl_extend("force", opts, { desc = "Show all diagnostics" }))

	-- Enhanced navigation with context
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_next({ float = { border = "rounded" } })
	end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))

	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_prev({ float = { border = "rounded" } })
	end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))

	-- Toggle diagnostics on/off
	vim.keymap.set("n", "<leader>dt", function()
		local current_state = vim.diagnostic.is_disabled()
		if current_state then
			vim.diagnostic.enable()
			vim.notify("Diagnostics enabled 🔍", vim.log.levels.INFO)
		else
			vim.diagnostic.disable()
			vim.notify("Diagnostics disabled 🙈", vim.log.levels.INFO)
		end
	end, vim.tbl_extend("force", opts, { desc = "Toggle diagnostics" }))

	-- Auto-show diagnostics on hover (optional - can be disabled)
	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			local cursor_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
			if #cursor_diagnostics > 0 then
				-- Only auto-show if there are errors or warnings
				for _, diagnostic in ipairs(cursor_diagnostics) do
					if diagnostic.severity <= vim.diagnostic.severity.WARN then
						vim.diagnostic.open_float(0, {
							scope = "cursor",
							border = "rounded",
							focusable = false,
							close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
						})
						break
					end
				end
			end
		end,
	})
end

-- Enhanced diagnostic highlight colors that work with your theme
function M.setup_colors()
	-- Get current background to determine if we're in light/dark mode
	local bg = vim.opt.background:get()

	if bg == "light" then
		-- Light theme diagnostic colors
		vim.cmd([[
            highlight DiagnosticError guifg=#d73a49 guibg=#ffeaea
            highlight DiagnosticWarn guifg=#b08800 guibg=#fff8c5
            highlight DiagnosticInfo guifg=#0366d6 guibg=#e1f5fe
            highlight DiagnosticHint guifg=#28a745 guibg=#e6ffed
            highlight DiagnosticFloatingError guifg=#d73a49 guibg=#ffffff
            highlight DiagnosticFloatingWarn guifg=#b08800 guibg=#ffffff
            highlight DiagnosticFloatingInfo guifg=#0366d6 guibg=#ffffff
            highlight DiagnosticFloatingHint guifg=#28a745 guibg=#ffffff
        ]])
	else
		-- Dark theme diagnostic colors (enhanced for readability)
		vim.cmd([[
            highlight DiagnosticError guifg=#f7768e guibg=#2d2021
            highlight DiagnosticWarn guifg=#e0af68 guibg=#2d2021
            highlight DiagnosticInfo guifg=#7dcfff guibg=#2d2021
            highlight DiagnosticHint guifg=#1abc9c guibg=#2d2021
            highlight DiagnosticFloatingError guifg=#f7768e guibg=#32394a
            highlight DiagnosticFloatingWarn guifg=#e0af68 guibg=#32394a
            highlight DiagnosticFloatingInfo guifg=#7dcfff guibg=#32394a
            highlight DiagnosticFloatingHint guifg=#1abc9c guibg=#32394a
        ]])
	end
end

-- Initialize enhanced diagnostics
M.setup()
M.setup_colors()

return M
