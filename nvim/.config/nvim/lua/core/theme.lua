-- core/theme.lua
-- Basic UI settings and theme fallback
-- ENHANCED: Now includes live tmux theme synchronization with improved colors!

-- Enable 24-bit RGB color in the TUI
vim.opt.termguicolors = true

-- Other UI settings
vim.opt.cursorline = true      -- Highlight current line
vim.opt.showmatch = true       -- Highlight matching brackets
vim.opt.signcolumn = "yes"     -- Always show sign column

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
    -- Clean up the result and return, default to dark if empty
    local theme = result:gsub("%s+", "")
    return (theme == "light") and "light" or "dark"
  end
  
  return "dark" -- Fallback if command fails
end

-- IMPROVED: Apply softer Tokyo Night Dark theme colors (less deep, more readable)
local function apply_dark_theme()
  vim.cmd [[
    highlight Normal guibg=#24283b guifg=#c0caf5
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
    highlight helpHeader guifg=#bb9af7
    highlight helpSectionDelim guifg=#7aa2f7
    highlight helpHyperTextJump guifg=#7dcfff
    highlight helpNote guifg=#e0af68
    highlight helpWarning guifg=#f7768e
    highlight helpExample guifg=#9ece6a
    highlight TabLine guibg=#32394a guifg=#c0caf5
    highlight TabLineFill guibg=#24283b
    highlight TabLineSel guibg=#414868 guifg=#ffffff
  ]]
  vim.notify("Applied improved dark theme (synced with tmux)", vim.log.levels.INFO)
end

-- IMPROVED: Apply proper contrast light theme colors (actually visible!)
local function apply_light_theme()
  vim.cmd [[
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
  ]]
  vim.notify("Applied improved light theme (synced with tmux)", vim.log.levels.INFO)
end

-- NEW: Main function to sync Neovim theme with tmux
local function sync_with_tmux_theme()
  local theme_mode = get_tmux_theme_mode()
  
  if theme_mode == "light" then
    apply_light_theme()
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
    vim.fn.system("~/.tmux/scripts/toggle_theme.sh")
    
    -- Then sync Neovim with the new tmux theme
    vim.defer_fn(function()
      sync_with_tmux_theme()
    end, 150) -- Slightly longer delay for smoother transition
  end
  
  -- Bind the same keys tmux uses: T and F5
  vim.keymap.set('n', 'T', toggle_and_sync_theme, { 
    desc = "Toggle tmux theme and sync Neovim colors",
    silent = true 
  })
  
  vim.keymap.set('n', '<F5>', toggle_and_sync_theme, { 
    desc = "Toggle tmux theme and sync Neovim colors", 
    silent = true 
  })
  
  -- Also add a manual sync command (useful for troubleshooting)
  vim.keymap.set('n', '<leader>ts', sync_with_tmux_theme, {
    desc = "Sync Neovim theme with tmux (manual)",
    silent = true
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
  get_tmux_mode = get_tmux_theme_mode
}
