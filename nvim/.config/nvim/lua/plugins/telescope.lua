-- lua/plugins/telescope.lua
-- Telescope fuzzy finder configuration
-- The ultimate fuzzy finder for buffers, files, and everything else!

local M = {}
local utils = require("core.utils")

function M.setup()
	local telescope = utils.safe_require("telescope")
	local actions = utils.safe_require("telescope.actions")

	if not telescope or not actions then
		return
	end

	telescope.setup({
		defaults = {
			-- Appearance
			prompt_prefix = "🔍 ",
			selection_caret = "➤ ",
			entry_prefix = "  ",

			-- Behavior
			sorting_strategy = "ascending",
			layout_strategy = "horizontal",
			layout_config = {
				horizontal = {
					prompt_position = "top",
					preview_width = 0.55,
					results_width = 0.8,
				},
				vertical = {
					mirror = false,
				},
				width = 0.87,
				height = 0.80,
				preview_cutoff = 120,
			},

			-- File ignore patterns
			file_ignore_patterns = {
				"node_modules",
				".git/",
				"dist/",
				"build/",
				"coverage/",
				"*.pyc",
				"__pycache__/",
				".pytest_cache/",
				".venv/",
				"venv/",
			},

			-- Default mappings
			mappings = {
				i = {
					-- Insert mode mappings
					["<C-n>"] = actions.cycle_history_next,
					["<C-p>"] = actions.cycle_history_prev,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<C-c>"] = actions.close,
					["<Down>"] = actions.move_selection_next,
					["<Up>"] = actions.move_selection_previous,
					["<CR>"] = actions.select_default,
					["<C-x>"] = actions.select_horizontal,
					["<C-v>"] = actions.select_vertical,
					["<C-t>"] = actions.select_tab,
					["<C-u>"] = actions.preview_scrolling_up,
					["<C-d>"] = actions.preview_scrolling_down,
					["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				},
				n = {
					-- Normal mode mappings
					["<esc>"] = actions.close,
					["<CR>"] = actions.select_default,
					["<C-x>"] = actions.select_horizontal,
					["<C-v>"] = actions.select_vertical,
					["<C-t>"] = actions.select_tab,
					["j"] = actions.move_selection_next,
					["k"] = actions.move_selection_previous,
					["H"] = actions.move_to_top,
					["M"] = actions.move_to_middle,
					["L"] = actions.move_to_bottom,
					["<C-u>"] = actions.preview_scrolling_up,
					["<C-d>"] = actions.preview_scrolling_down,
					["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
					["?"] = actions.which_key,
				},
			},
		},

		-- Picker-specific configuration
		pickers = {
			-- Buffer picker (your main request!)
			buffers = {
				theme = "dropdown",
				previewer = false,
				initial_mode = "normal",
				sort_lastused = true,
				sort_mru = true,
				mappings = {
					i = {
						["<C-d>"] = actions.delete_buffer + actions.move_to_top,
					},
					n = {
						["dd"] = actions.delete_buffer + actions.move_to_top,
					},
				},
			},

			-- File finder
			find_files = {
				theme = "ivy",
				hidden = false,
			},

			-- Live grep
			live_grep = {
				theme = "ivy",
			},

			-- Git files
			git_files = {
				theme = "ivy",
			},

			-- Recent files
			oldfiles = {
				theme = "dropdown",
				previewer = false,
			},

			-- Help tags
			help_tags = {
				theme = "ivy",
			},
		},

		-- Extensions configuration
		extensions = {
			-- Add fzf extension for faster sorting (if available)
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
		},
	})

	-- Load extensions (will load if available, fail gracefully if not)
	pcall(telescope.load_extension, "fzf")
end

-- Setup keybindings
function M.setup_keybindings()
	local builtin = utils.safe_require("telescope.builtin")
	if not builtin then
		return
	end

	-- Buffer management (your main request!)
	vim.keymap.set("n", "<leader>bb", builtin.buffers, { desc = "Find buffers (fuzzy)" })
	vim.keymap.set("n", "<leader>br", builtin.oldfiles, { desc = "Recent files" })

	-- File finding
	vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
	vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Find word under cursor" })

	-- Git integration
	vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Find git files" })
	vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
	vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
	vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })

	-- LSP integration (works with your existing LSP setup!)
	vim.keymap.set("n", "<leader>lr", builtin.lsp_references, { desc = "LSP references" })
	vim.keymap.set("n", "<leader>ld", builtin.lsp_definitions, { desc = "LSP definitions" })
	vim.keymap.set("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "LSP symbols" })
	vim.keymap.set("n", "<leader>lw", builtin.lsp_workspace_symbols, { desc = "LSP workspace symbols" })

	-- Help and misc
	vim.keymap.set("n", "<leader>hh", builtin.help_tags, { desc = "Help tags" })
	vim.keymap.set("n", "<leader>hk", builtin.keymaps, { desc = "Show keymaps" })
	vim.keymap.set("n", "<leader>hc", builtin.commands, { desc = "Show commands" })

	-- Quick access to config files
	vim.keymap.set("n", "<leader>fc", function()
		builtin.find_files({ cwd = vim.fn.stdpath("config") })
	end, { desc = "Find config files" })
end

-- Initialize everything
M.setup()
M.setup_keybindings()

return M
