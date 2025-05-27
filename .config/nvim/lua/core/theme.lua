-- core/theme.lua
-- Basic UI settings and theme fallback
-- ENHANCED: Now includes live tmux theme synchronization!

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

-- NEW: Apply Tokyo Night Dark theme colors
local function apply_dark_theme()
  vim.cmd [[
    highlight Normal guibg=#1a1b26 guifg=#c0caf5
    highlight LineNr guifg=#3b4261
    highlight CursorLine guibg=#24283b
    highlight CursorLineNr guifg=#7aa2f7
    highlight StatusLine guibg=#3b4261 guifg=#7aa2f7
    highlight StatusLineNC guibg=#24283b guifg=#565f89
    highlight VertSplit guifg=#3b4261
    highlight SignColumn guibg=#1a1b26
    highlight Pmenu guibg=#24283b guifg=#c0caf5
    highlight PmenuSel guibg=#414868 guifg=#c0caf5
    highlight Visual guibg=#33467c
    highlight Search guibg=#3d59a1 guifg=#c0caf5
  ]]
  vim.notify("Applied dark theme (synced with tmux)", vim.log.levels.INFO)
end

-- NEW: Apply Tokyo Night Light theme colors  
local function apply_light_theme()
  vim.cmd [[
    highlight Normal guibg=#f5f0e7 guifg=#2c3e50
    highlight LineNr guifg=#5d6d7e
    highlight CursorLine guibg=#e4dfd3
    highlight CursorLineNr guifg=#6c7a89
    highlight StatusLine guibg=#7e8c8d guifg=#f5f0e7
    highlight StatusLineNC guibg=#b8c0ca guifg=#5d6d7e
    highlight VertSplit guifg=#b8c0ca
    highlight SignColumn guibg=#f5f0e7
    highlight Pmenu guibg=#e4dfd3 guifg=#2c3e50
    highlight PmenuSel guibg=#d5cfc3 guifg=#2c3e50
    highlight Visual guibg=#d5cfc3
    highlight Search guibg=#c5bfb3 guifg=#2c3e50
  ]]
  vim.notify("Applied light theme (synced with tmux)", vim.log.levels.INFO)
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
    end, 100) -- Small delay to let tmux switch first
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
