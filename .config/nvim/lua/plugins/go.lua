-- Go plugin configuration

local M = {}

function M.setup()
  -- Set up go.nvim if available
  pcall(function()
    require('go').setup()
  end)
end

-- Initialize go configuration
M.setup()

return M
