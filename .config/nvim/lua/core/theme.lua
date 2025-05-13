-- core/theme.lua
-- Basic UI settings and theme fallback

-- Enable 24-bit RGB color in the TUI
vim.opt.termguicolors = true

-- Other UI settings
vim.opt.cursorline = true      -- Highlight current line
vim.opt.showmatch = true       -- Highlight matching brackets
vim.opt.signcolumn = "yes"     -- Always show sign column

-- Note: Main theming is handled by tmux
-- This only serves as a fallback if tmux theme isn't detected
local function apply_fallback_theme()
  -- Check if we're in tmux
  local in_tmux = os.getenv("TMUX") ~= nil
  
  if not in_tmux then
    -- Apply a minimal dark theme fallback if not in tmux
    vim.cmd [[
      highlight Normal guibg=#1a1b26 guifg=#c0caf5
      highlight LineNr guifg=#3b4261
      highlight CursorLine guibg=#24283b
      highlight StatusLine guibg=#3b4261 guifg=#7aa2f7
    ]]
  end
  -- When in tmux, we let tmux control the theme
end

apply_fallback_theme()

return {
  -- Empty theme module that documents the tmux theme dependency
  setup = function()
    -- No additional setup needed as theme is controlled by tmux
  end
}
