-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                            GIT INTEGRATION FUNCTIONS                        ║
-- ║                         Lightweight git status for Neovim                   ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local M = {}

-- Cache for performance (avoid repeated git calls)
local cache = {
	is_repo = nil,
	repo_check_time = 0,
	branch = "",
	branch_check_time = 0,
}

-- Cache timeout in seconds
local CACHE_TIMEOUT = 2

-- Check if current directory is a git repository (cached)
function M.is_git_repo()
	local current_time = vim.loop.hrtime() / 1000000000 -- Convert to seconds

	-- Use cache if still valid
	if cache.is_repo ~= nil and (current_time - cache.repo_check_time) < CACHE_TIMEOUT then
		return cache.is_repo
	end

	-- Check git repository
	local git_dir = vim.fn.system("git rev-parse --git-dir 2>/dev/null")
	cache.is_repo = vim.v.shell_error == 0
	cache.repo_check_time = current_time

	return cache.is_repo
end

-- Get current git branch name (fast and simple)
function M.get_git_branch()
	if not M.is_git_repo() then
		return ""
	end

	local current_time = vim.loop.hrtime() / 1000000000

	-- Use cached branch if still valid
	if cache.branch ~= "" and (current_time - cache.branch_check_time) < CACHE_TIMEOUT then
		return cache.branch
	end

	local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
	cache.branch = branch ~= "" and branch or "HEAD"
	cache.branch_check_time = current_time

	return cache.branch
end

-- Get git status indicator (for statusline)
function M.get_git_status_indicator()
	if not M.is_git_repo() then
		return ""
	end

	-- Quick check for changes
	local status = vim.fn.system("git status --porcelain 2>/dev/null")
	if vim.v.shell_error ~= 0 then
		return ""
	end

	-- Enhanced indicators with better pattern matching
	if status:match("^M") or status:match("^ M") then
		return " [+]" -- Modified files
	elseif status:match("^A") or status:match("^ A") then
		return " [*]" -- Added files
	elseif status:match("^D") or status:match("^ D") then
		return " [-]" -- Deleted files
	elseif status:match("^%?%?") then
		return " [?]" -- Untracked files
	elseif status:match("^R") then
		return " [→]" -- Renamed files
	elseif status == "" then
		return " [✓]" -- Clean
	else
		return " [~]" -- Other changes
	end
end
another en 
    

-- Get formatted git info for statusline (branch + status)
function M.get_git_info()
	local branch = M.get_git_branch()
	if branch == "" then
		return ""
	end

	local status = M.get_git_status_indicator()
	return string.format("(%s)%s", branch, status)
end

-- Quick git branch for command line (lightweight)
function M.get_git_branch_simple()
	local handle = io.popen("git branch --show-current 2>/dev/null")
	if handle then
		local result = handle:read("*l")
		handle:close()
		return result and result ~= "" and result or nil
	end
	return nil
end

-- Clear cache (useful when switching branches)
function M.clear_cache()
	cache.is_repo = nil
	cache.branch = ""
	cache.repo_check_time = 0
	cache.branch_check_time = 0
end

-- Get commit ahead/behind info (optional, for advanced users)
function M.get_ahead_behind()
	if not M.is_git_repo() then
		return ""
	end

	local upstream = vim.fn.system("git rev-parse --abbrev-ref @{upstream} 2>/dev/null"):gsub("\n", "")
	if upstream == "" or vim.v.shell_error ~= 0 then
		return ""
	end

	local ahead_behind =
		vim.fn.system(string.format("git rev-list --left-right --count HEAD...%s 2>/dev/null", upstream))
	if vim.v.shell_error ~= 0 then
		return ""
	end

	local ahead, behind = ahead_behind:match("(%d+)%s+(%d+)")
	if ahead and behind then
		if ahead == "0" and behind == "0" then
			return ""
		elseif ahead ~= "0" and behind == "0" then
			return string.format(" ↑%s", ahead)
		elseif ahead == "0" and behind ~= "0" then
			return string.format(" ↓%s", behind)
		else
			return string.format(" ↑%s↓%s", ahead, behind)
		end
	end

	return ""
end

return M
