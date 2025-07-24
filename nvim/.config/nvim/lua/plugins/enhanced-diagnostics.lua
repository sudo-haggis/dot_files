-- lua/plugins/enhanced-diagnostics.lua
-- Enhanced LSP diagnostic display with better formatting
-- Makes error messages appear in readable boxes with proper positioning

local M = {}

function M.setup()
	-- Enhanced diagnostic configuration
	vim.diagnostic.config({
		-- Virtual text settings - show full messages on new line
		virtual_text = {
			enabled = true,
			severity = vim.diagnostic.severity.ERROR, -- Only show errors inline
			source = "if_many",
			format = function(diagnostic)
				-- Show full message with line break
				local message = diagnostic.message
				local severity_icons = {
					[vim.diagnostic.severity.ERROR] = "🔥",
					[vim.diagnostic.severity.WARN] = "⚠️",
					[vim.diagnostic.severity.INFO] = "ℹ️",
					[vim.diagnostic.severity.HINT] = "💡",
				}
				local icon = severity_icons[diagnostic.severity] or "📝"
				-- Force new line for full message visibility, no leading whitespace
				return "\n🔥 " .. message
			end,
			prefix = "", -- Remove default prefix since we add custom formatting
			spacing = 0, -- No extra spacing since we control it
			suffix = "", -- Clean suffix
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
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost", "CursorMovedI" },

			-- Custom formatting function
			format = function(diagnostic)
				local source = diagnostic.source or "LSP"
				local code = diagnostic.code and (" [" .. diagnostic.code .. "]") or ""
				local severity_icons = {
					[vim.diagnostic.severity.ERROR] = "🔥",
					[vim.diagnostic.severity.WARN] = "⚠️",
					[vim.diagnostic.severity.INFO] = "ℹ️",
					[vim.diagnostic.severity.HINT] = "💡",
				}

				local icon = severity_icons[diagnostic.severity] or "📝"
				local severity_name = vim.diagnostic.severity[diagnostic.severity]

				-- Format the message with proper line breaks and no leading whitespace
				local message = diagnostic.message
				-- Break long lines at natural points
				message = message:gsub("(%S+)%s*,%s*", "%1,\n")
				message = message:gsub(" but ", "\nbut ")
				message = message:gsub(" at ", "\nat ")

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
		{ name = "DiagnosticSignError", text = "🔥" },
		{ name = "DiagnosticSignWarn", text = "⚠️" },
		{ name = "DiagnosticSignHint", text = "💡" },
		{ name = "DiagnosticSignInfo", text = "ℹ️" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	-- Custom keybindings for better diagnostic navigation
	local opts = { noremap = true, silent = true }

	-- Show diagnostic in floating window (enhanced with better escape options)
	vim.keymap.set("n", "<leader>e", function()
		vim.diagnostic.open_float(0, {
			scope = "cursor",
			border = "rounded",
			max_width = 80,
			max_height = 20,
			focusable = true,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost", "CursorMovedI" },
		})
	end, vim.tbl_extend("force", opts, { desc = "Show diagnostic details" }))

	-- NEW: Force close any floating diagnostic windows
	vim.keymap.set("n", "<Esc>", function()
		-- Close any floating windows
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local config = vim.api.nvim_win_get_config(win)
			if config.relative ~= "" then -- It's a floating window
				pcall(vim.api.nvim_win_close, win, true)
			end
		end
	end, vim.tbl_extend("force", opts, { desc = "Close floating windows" }))

	-- Alternative close method with 'q' in normal mode
	vim.keymap.set("n", "q", function()
		-- Only close diagnostics if we're not in a special buffer
		if vim.bo.buftype == "" then -- Normal buffer
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local config = vim.api.nvim_win_get_config(win)
				if config.relative ~= "" then -- It's a floating window
					pcall(vim.api.nvim_win_close, win, true)
					return -- Exit after closing
				end
			end
		end
		-- If no floating windows, do normal 'q' behavior (record macro)
		vim.cmd("normal! q")
	end, vim.tbl_extend("force", opts, { desc = "Close diagnostics or record macro" }))

	-- Show all buffer diagnostics in quickfix
	vim.keymap.set("n", "<leader>E", function()
		vim.diagnostic.setqflist()
		vim.cmd("copen")
	end, vim.tbl_extend("force", opts, { desc = "Show all diagnostics" }))

	-- Enhanced navigation with context
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_next({
			float = { border = "rounded", max_width = 100 },
			severity = { min = vim.diagnostic.severity.HINT },
		})
		-- Auto-show detailed diagnostic after jumping
		vim.defer_fn(function()
			vim.diagnostic.open_float(0, {
				scope = "cursor",
				border = "rounded",
				max_width = 100,
			})
		end, 100)
	end, vim.tbl_extend("force", opts, { desc = "Next diagnostic (with details)" }))

	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_prev({
			float = { border = "rounded", max_width = 100 },
			severity = { min = vim.diagnostic.severity.HINT },
		})
		-- Auto-show detailed diagnostic after jumping
		vim.defer_fn(function()
			vim.diagnostic.open_float(0, {
				scope = "cursor",
				border = "rounded",
				max_width = 100,
			})
		end, 100)
	end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic (with details)" }))

	-- NEW: Cycle through ALL diagnostics in document with detailed view
	vim.keymap.set("n", "<leader>dc", function()
		local diagnostics = vim.diagnostic.get(0)
		if #diagnostics == 0 then
			vim.notify("No diagnostics found in current buffer 🎉", vim.log.levels.INFO)
			return
		end

		-- Create a more detailed quickfix list
		local qf_list = {}
		for _, diagnostic in ipairs(diagnostics) do
			local severity_text = vim.diagnostic.severity[diagnostic.severity] or "UNKNOWN"
			local icon = ({
				ERROR = "🔥",
				WARN = "⚠️",
				INFO = "ℹ️",
				HINT = "💡",
			})[severity_text] or "📝"

			table.insert(qf_list, {
				bufnr = diagnostic.bufnr,
				lnum = diagnostic.lnum + 1,
				col = diagnostic.col + 1,
				text = string.format("%s [%s] %s", icon, severity_text, diagnostic.message),
				type = severity_text:sub(1, 1):lower(),
			})
		end

		vim.fn.setqflist(qf_list, "r")
		vim.cmd("copen")
		vim.notify(string.format("Found %d diagnostics - use :cn/:cp to cycle", #diagnostics), vim.log.levels.INFO)
	end, vim.tbl_extend("force", opts, { desc = "Cycle through all diagnostics" }))

	-- NEW: Jump to specific error types only
	vim.keymap.set("n", "]e", function()
		vim.diagnostic.goto_next({
			severity = vim.diagnostic.severity.ERROR,
			float = { border = "rounded", max_width = 100 },
		})
	end, vim.tbl_extend("force", opts, { desc = "Next ERROR only" }))

	vim.keymap.set("n", "[e", function()
		vim.diagnostic.goto_prev({
			severity = vim.diagnostic.severity.ERROR,
			float = { border = "rounded", max_width = 100 },
		})
	end, vim.tbl_extend("force", opts, { desc = "Previous ERROR only" }))

	-- Toggle diagnostics on/off (using config method - most compatible)
	local diagnostics_enabled = true
	vim.keymap.set("n", "<leader>dt", function()
		if diagnostics_enabled then
			-- Disable by turning off all diagnostic features
			vim.diagnostic.config({
				virtual_text = false,
				signs = false,
				underline = false,
				update_in_insert = false,
			})
			diagnostics_enabled = false
			vim.notify("Diagnostics disabled 🙈", vim.log.levels.INFO)
		else
			-- Re-enable with our enhanced config
			M.setup() -- Restore our full config
			diagnostics_enabled = true
			vim.notify("Diagnostics enabled 🔍", vim.log.levels.INFO)
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
            highlight DiagnosticFloatingError guifg=#d73a49 guibg=#f8f8f8
            highlight DiagnosticFloatingWarn guifg=#b08800 guibg=#f8f8f8
            highlight DiagnosticFloatingInfo guifg=#0366d6 guibg=#f8f8f8
            highlight DiagnosticFloatingHint guifg=#28a745 guibg=#f8f8f8
            highlight NormalFloat guibg=#f8f8f8 guifg=#24292e
            highlight FloatBorder guibg=#f8f8f8 guifg=#d1d5da
        ]])
	else
		-- Dark theme diagnostic colors (softer, easier on eyes)
		vim.cmd([[
            highlight DiagnosticError guifg=#f7768e guibg=NONE
            highlight DiagnosticWarn guifg=#e0af68 guibg=NONE
            highlight DiagnosticInfo guifg=#7dcfff guibg=NONE
            highlight DiagnosticHint guifg=#1abc9c guibg=NONE
            highlight DiagnosticFloatingError guifg=#f7768e guibg=#2f3549
            highlight DiagnosticFloatingWarn guifg=#e0af68 guibg=#2f3549
            highlight DiagnosticFloatingInfo guifg=#7dcfff guibg=#2f3549
            highlight DiagnosticFloatingHint guifg=#1abc9c guibg=#2f3549
            
            " Diagnostic floating windows only
            highlight DiagnosticNormalFloat guibg=#2f3549 guifg=#c0caf5
            highlight DiagnosticFloatBorder guibg=#2f3549 guifg=#7aa2f7
            highlight DiagnosticFloatTitle guibg=#2f3549 guifg=#7aa2f7 gui=bold
            
            " Preserve which-key colors (don't override global)
            highlight WhichKeyFloat guibg=#1a1b26 guifg=#c0caf5
            highlight WhichKeyBorder guibg=#1a1b26 guifg=#3b4261
        ]])
	end
end

-- Initialize enhanced diagnostics
M.setup()
M.setup_colors()

return M
