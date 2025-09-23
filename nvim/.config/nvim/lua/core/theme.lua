-- core/theme.lua
-- Basic UI settings and theme fallback
-- ENHANCED: Now includes live tmux theme synchronization with TRUE MEDIUM theme support!
-- FIXED: All themes now have complete color definitions with proper medium values

-- Enable 24-bit RGB color in the TUI
vim.opt.termguicolors = true

-- Other UI settings
vim.opt.cursorline = true -- Highlight current line
vim.opt.showmatch = true -- Highlight matching brackets
vim.opt.signcolumn = "yes" -- Always show sign column

-- NEW: Function to read tmux's current theme mode
local function get_tmux_theme_mode()
	local in_tmux = os.getenv("TMUX") ~= nil
	if not in_tmux then
		return "dark" -- Default fallback
	end

	-- Read tmux's @theme_mode option
	local handle = io.popen("tmux show-option -gv @theme_mode 2>/dev/null")
	if handle then
		local result = handle:read("*a")
		handle:close()
		-- Clean up the result and return the actual theme name
		local theme = result:gsub("%s+", "")
		-- FIXED: Return actual theme instead of forcing light/dark
		if theme == "light" then
			return "light"
		elseif theme == "medium" then
			return "medium"
		else
			return "dark" -- default for dark or any other value
		end
	end

	return "dark" -- Fallback if command fails
end

-- DARK THEME: Tokyo Night Dark (deep, rich colors)
function apply_dark_theme()
	vim.cmd([[
    " Base UI colors - Dark
    highlight Normal guibg=#24283b guifg=#c0caf5 ctermfg=15 ctermbg=0
    highlight LineNr guifg=#7aa2f7
    highlight CursorLine guibg=#2f3549
    highlight CursorLineNr guifg=#9ece6a guibg=#2f3549
    highlight StatusLine guibg=#414868 guifg=#c0caf5
    highlight StatusLineNC guibg=#32394a guifg=#737aa2
    highlight VertSplit guifg=#414868
    highlight SignColumn guibg=#24283b
    highlight Pmenu guibg=#32394a guifg=#c0caf5
    highlight PmenuSel guibg=#414868 guifg=#ffffff
    highlight PmenuSbar guibg=#32394a
    highlight PmenuThumb guifg=#7aa2f7
    highlight Visual guibg=#364a82
    highlight Search guibg=#3d59a1 guifg=#ffffff
    highlight IncSearch guibg=#f7768e guifg=#1a1b26
    highlight Comment guifg=#565f89
    highlight String guifg=#9ece6a
    highlight Keyword guifg=#bb9af7
    highlight Function guifg=#7aa2f7
    highlight ErrorMsg guibg=#f7768e guifg=#ffffff
    highlight WarningMsg guibg=#e0af68 guifg=#1a1b26
    highlight Error guifg=#f7768e
    highlight DiagnosticError guifg=#f7768e
    highlight DiagnosticWarn guifg=#e0af68
    highlight DiagnosticInfo guifg=#7dcfff
    highlight DiagnosticHint guifg=#1abc9c
    highlight Title guifg=#7aa2f7
    highlight Question guifg=#9ece6a
    highlight MoreMsg guifg=#9ece6a
    highlight ModeMsg guifg=#c0caf5
    highlight SpecialKey guifg=#565f89
    highlight NonText guifg=#565f89
    highlight Directory guifg=#7aa2f7
    highlight TabLine guibg=#32394a guifg=#c0caf5
    highlight TabLineFill guibg=#24283b
    highlight TabLineSel guibg=#414868 guifg=#ffffff
    
    " Dark theme syntax colors
    highlight Identifier guifg=#c0caf5         
    highlight Type guifg=#7dcfff               
    highlight Constant guifg=#ff9e64           
    highlight PreProc guifg=#bb9af7            
    highlight Special guifg=#7dcfff            
    highlight Delimiter guifg=#c0caf5       
    highlight Operator guifg=#89b4fa       
    highlight @variable guifg=#c0caf5     
    highlight @parameter guifg=#e0af68   
    highlight @property guifg=#7dcfff       
    highlight @field guifg=#7dcfff        
    highlight @method guifg=#7aa2f7        
    highlight @constructor guifg=#bb9af7
    highlight @punctuation guifg=#c0caf5 
    highlight @bracket guifg=#c0caf5    
  ]])
	vim.notify("Applied dark theme (synced with tmux)", vim.log.levels.INFO)
end

-- MEDIUM THEME: White-based, softer than full light theme
function apply_medium_theme()
	vim.cmd([[
    " Base UI colors - Medium (white-based, softer light theme)
    highlight Normal guibg=#f0efff guifg=#4a5568
    highlight LineNr guifg=#8a95a8
    highlight CursorLine guibg=#f0f2f5
    highlight CursorLineNr guifg=#2d3748 guibg=#f0f2f5
    highlight StatusLine guibg=#8a95a8 guifg=#fafafa
    highlight StatusLineNC guibg=#e2e8f0 guifg=#718096
    highlight VertSplit guifg=#e2e8f0
    highlight SignColumn guibg=#fafafa
    highlight Pmenu guibg=#f0f2f5 guifg=#4a5568
    highlight PmenuSel guibg=#8a95a8 guifg=#ffffff
    highlight PmenuSbar guibg=#f0f2f5
    highlight PmenuThumb guibg=#8a95a8
    highlight Visual guibg=#d6e3f0
    highlight Search guibg=#63b3ed guifg=#ffffff
    highlight IncSearch guibg=#f56565 guifg=#ffffff
    highlight Comment guifg=#a0aec0
    highlight String guifg=#68d391
    highlight Keyword guifg=#9f7aea
    highlight Function guifg=#4299e1
    highlight ErrorMsg guibg=#f56565 guifg=#ffffff
    highlight WarningMsg guibg=#ed8936 guifg=#ffffff
    highlight Error guifg=#f56565
    highlight DiagnosticError guifg=#f56565
    highlight DiagnosticWarn guifg=#ed8936
    highlight DiagnosticInfo guifg=#63b3ed
    highlight DiagnosticHint guifg=#68d391
    highlight Title guifg=#4299e1
    highlight Question guifg=#68d391
    highlight MoreMsg guifg=#68d391
    highlight ModeMsg guifg=#4a5568
    highlight SpecialKey guifg=#a0aec0
    highlight NonText guifg=#a0aec0
    highlight Directory guifg=#4299e1
    highlight TabLine guibg=#e2e8f0 guifg=#4a5568
    highlight TabLineFill guibg=#fafafa
    highlight TabLineSel guibg=#8a95a8 guifg=#ffffff
    
    " Medium theme syntax colors (white-based, softer than full light)
    highlight Identifier guifg=#4a5568         
    highlight Type guifg=#3182ce               
    highlight Constant guifg=#d69e2e           
    highlight PreProc guifg=#805ad5            
    highlight Special guifg=#3182ce            
    highlight Delimiter guifg=#4a5568       
    highlight Operator guifg=#4299e1       
    highlight @variable guifg=#4a5568     
    highlight @parameter guifg=#d69e2e   
    highlight @property guifg=#3182ce       
    highlight @field guifg=#3182ce        
    highlight @method guifg=#4299e1        
    highlight @constructor guifg=#805ad5
    highlight @punctuation guifg=#4a5568 
    highlight @bracket guifg=#4a5568    
  ]])
	vim.notify("Applied medium theme (synced with tmux)", vim.log.levels.INFO)
end

-- LIGHT THEME: High contrast light theme
function apply_light_theme()
	vim.cmd([[
    " Base UI colors - Light
    highlight Normal guibg=#f7f7f7 guifg=#3760bf
    highlight LineNr guifg=#6f7bb6
    highlight CursorLine guibg=#e9e9ed
    highlight CursorLineNr guifg=#1e1e2e guibg=#e9e9ed
    highlight StatusLine guibg=#6f7bb6 guifg=#f7f7f7
    highlight StatusLineNC guibg=#c4c8da guifg=#6c6f85
    highlight VertSplit guifg=#c4c8da
    highlight SignColumn guibg=#f7f7f7
    highlight Pmenu guibg=#e1e2e7 guifg=#3760bf
    highlight PmenuSel guibg=#6f7bb6 guifg=#ffffff
    highlight PmenuSbar guibg=#e1e2e7
    highlight PmenuThumb guibg=#6f7bb6
    highlight Visual guibg=#b6bfe2
    highlight Search guibg=#2ac3de guifg=#ffffff
    highlight IncSearch guibg=#f52a65 guifg=#ffffff
    highlight Comment guifg=#9699b7
    highlight String guifg=#587539
    highlight Keyword guifg=#7847bd
    highlight Function guifg=#166775
    highlight ErrorMsg guibg=#f52a65 guifg=#ffffff
    highlight WarningMsg guibg=#8f5e15 guifg=#ffffff
    highlight Error guifg=#f52a65
    highlight DiagnosticError guifg=#f52a65
    highlight DiagnosticWarn guifg=#8f5e15
    highlight DiagnosticInfo guifg=#2ac3de
    highlight DiagnosticHint guifg=#587539
    highlight Title guifg=#6f7bb6
    highlight Question guifg=#587539
    highlight MoreMsg guifg=#587539
    highlight ModeMsg guifg=#3760bf
    highlight SpecialKey guifg=#9699b7
    highlight NonText guifg=#9699b7
    highlight Directory guifg=#6f7bb6
    highlight TabLine guibg=#c4c8da guifg=#3760bf
    highlight TabLineFill guibg=#f7f7f7
    highlight TabLineSel guibg=#6f7bb6 guifg=#ffffff
    
    " Light theme syntax colors
    highlight Identifier guifg=#3760bf         
    highlight Type guifg=#166775               
    highlight Constant guifg=#8f5e15           
    highlight PreProc guifg=#7847bd            
    highlight Special guifg=#166775            
    highlight Delimiter guifg=#3760bf       
    highlight Operator guifg=#6f7bb6       
    highlight @variable guifg=#3760bf     
    highlight @parameter guifg=#8f5e15   
    highlight @property guifg=#166775       
    highlight @field guifg=#166775        
    highlight @method guifg=#166775        
    highlight @constructor guifg=#7847bd
    highlight @punctuation guifg=#3760bf 
    highlight @bracket guifg=#3760bf    
  ]])
	vim.notify("Applied light theme (synced with tmux)", vim.log.levels.INFO)
end

-- NEW: Main function to sync Neovim theme with tmux
local function sync_with_tmux_theme()
	local theme_mode = get_tmux_theme_mode()

	if theme_mode == "light" then
		apply_light_theme()
	elseif theme_mode == "medium" then
		apply_medium_theme()
	else
		apply_dark_theme()
	end
end

-- ENHANCED: Improved fallback theme application
local function apply_fallback_theme()
	-- Check if we're in tmux
	local in_tmux = os.getenv("TMUX") ~= nil

	if not in_tmux then
		-- Apply a minimal dark theme fallback if not in tmux
		apply_dark_theme()
	else
		-- NEW: When in tmux, sync with tmux theme on startup
		sync_with_tmux_theme()
	end
end

-- NEW: Add keybindings to sync theme (same keys as tmux theme switcher)
local function setup_theme_keybindings()
	-- Function that toggles tmux theme AND syncs Neovim
	local function toggle_and_sync_theme()
		-- First, run the tmux theme toggle script
		vim.fn.system("~/.config/tmux/scripts/toggle_theme.sh")

		-- Then sync Neovim with the new tmux theme
		vim.defer_fn(function()
			sync_with_tmux_theme()
		end, 300) -- Slightly longer delay for 3-theme cycling
	end

	-- Bind the same keys tmux uses: T and F5
	vim.keymap.set("n", "T", toggle_and_sync_theme, {
		desc = "Toggle tmux theme and sync Neovim colors",
		silent = true,
	})

	vim.keymap.set("n", "<F5>", toggle_and_sync_theme, {
		desc = "Toggle tmux theme and sync Neovim colors",
		silent = true,
	})

	-- Also add a manual sync command (useful for troubleshooting)
	vim.keymap.set("n", "<leader>ts", sync_with_tmux_theme, {
		desc = "Sync Neovim theme with tmux (manual)",
		silent = true,
	})
end

-- Initialize theme on startup
apply_fallback_theme()

-- Set up keybindings
setup_theme_keybindings()

-- ENHANCED: Return module with new functionality
return {
	-- Main setup function
	setup = function()
		-- Theme is now actively managed, not just passively inherited
		sync_with_tmux_theme()
	end,

	-- NEW: Expose functions for external use
	sync_with_tmux = sync_with_tmux_theme,
	apply_dark = apply_dark_theme,
	apply_light = apply_light_theme,
	apply_medium = apply_medium_theme, -- NEW!
	get_tmux_mode = get_tmux_theme_mode,
}
