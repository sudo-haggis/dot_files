-- Treesitter configuration

local M = {}

function M.setup()
  -- Set up treesitter if available
  pcall(function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { 
        "lua", 
        "vim", 
        "go", 
        "php", 
        "yaml", 
        "json", 
        "javascript", 
        "typescript", 
        "svelte" 
      },
      auto_install = true,
      highlight = {
        enable = true,
      },
    }
  end)
end

-- Initialize treesitter
M.setup()

return M
