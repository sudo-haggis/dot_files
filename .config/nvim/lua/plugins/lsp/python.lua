-- Minimal Python LSP configuration
local M = {}

function M.setup(lspconfig, capabilities)
  if lspconfig.pyright then
    lspconfig.pyright.setup{
      capabilities = capabilities or {},
    }
  end
end

return M
