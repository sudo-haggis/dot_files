-- lua/core/statusline.lua
-- Simple, clean statusline with git integration - FIXED VERSION
-- Add this to your init.lua: utils.safe_require("core.statusline")

local M = {}

-- Try to get the git module - with fallback
local function get_git_module()
	local success, git = pcall(require, "core.git")
	if success then
		return git
	end
	return nil
end

-- Colors for statusline elements
local colors = {
	git_branch = "#7aa2f7", -- Nice blue for git branch
	git_clean = "#9ece6a", -- Green for clean status
	git_dirty = "#f7768e", -- Red for dirty status
	file_path = "#c0caf5", -- Light blue for file path
	file_modified = "#e0af68", -- Orange for modified indicator
	normal = "#c0caf5", -- Default text color
}

-- Create highlight groups
local function setup_highlights()
	vim.cmd(string.format("highlight StatusLineGitBranch guifg=%s guibg=#414868", colors.git_branch))
	vim.cmd(string.format("highlight StatusLineGitClean guifg=%s guibg=#414868", colors.git_clean))
	vim.cmd(string.format("highlight StatusLineGitDirty guifg=%s guibg=#414868", colors.git_dirty))
	vim.cmd(string.format("highlight StatusLineFilePath guifg=%s guibg=#414868", colors.file_path))
	vim.cmd(string.format("highlight StatusLineModified guifg=%s guibg=#414868", colors.file_modified))
end

-- Get file path relative to git root or cwd
local function get_relative_path()
	local file_path = vim.fn.expand("%:p")
	if file_path == "" then
		return "[No File]"
	end

	-- Try to get path relative to git root
	local git = get_git_module()
	if git and git.is_git_repo() then
		local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
		if git_root ~= "" and file_path:find(git_root, 1, true) == 1 then
			return file_path:sub(#git_root + 2) -- +2 to skip the trailing slash
		end
	end

	-- Fallback to relative path from cwd
	return vim.fn.expand("%:.")
end

-- Build the statusline
local function build_statusline()
	local parts = {}

	-- File path
	local file_path = get_relative_path()
	table.insert(parts, "%#StatusLineFilePath#" .. file_path)

	-- Git branch and status
	local git = get_git_module()
	if git then
		local git_info = git.get_git_info()
		if git_info ~= "" then
			-- Determine color based on git status
			local git_color = git_info:match("%[✓%]") and "StatusLineGitClean" or "StatusLineGitDirty"
			table.insert(parts, "%#" .. git_color .. "# " .. git_info)
		end
	end

	-- Modified indicator
	if vim.bo.modified then
		table.insert(parts, "%#StatusLineModified#")
	end

	-- Right side - line info
	table.insert(parts, "%=%l/%L:%c") -- line/total:column

	return table.concat(parts)
end

-- Update statusline
local function update_statusline()
	vim.o.statusline = build_statusline()
end

-- Setup function
function M.setup()
	-- Setup highlight groups
	setup_highlights()

	-- Enable statusline
	vim.o.laststatus = 2

	-- Set initial statusline
	update_statusline()

	-- Auto-update statusline on various events
	local statusline_group = vim.api.nvim_create_augroup("GitStatusline", { clear = true })

	vim.api.nvim_create_autocmd({
		"BufEnter",
		"BufWritePost",
		"TextChanged",
		"TextChangedI",
		"WinEnter",
		"CmdlineLeave",
		"VimResized",
	}, {
		group = statusline_group,
		callback = update_statusline,
	})

	-- Update on git operations (if using fugitive or similar)
	vim.api.nvim_create_autocmd("User", {
		group = statusline_group,
		pattern = "FugitiveChanged",
		callback = update_statusline,
	})

	vim.notify("Git statusline loaded! 🏴‍☠️", vim.log.levels.INFO)
end

-- Manual refresh command
vim.api.nvim_create_user_command("StatuslineRefresh", function()
	update_statusline()
	vim.notify("Statusline refreshed! 🔄", vim.log.levels.INFO)
end, { desc = "Refresh git statusline" })

-- Initialize
M.setup()

return M
