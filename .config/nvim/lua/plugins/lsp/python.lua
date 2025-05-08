-- plugins/lsp/python.lua
-- Python LSP configuration using consistent keybindings

local M = {}

function M.setup(lspconfig, _)
  -- Get common module
  local common = require('plugins.lsp.common')
  
  -- Python-specific settings
  local settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",  -- Can be "off", "basic", or "strict"
        completeFunctionParens = true,
        indexing = true,
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
        }
      }
    }
  }
  
  -- Setup pyright with consistent configuration
  if lspconfig.pyright then
    lspconfig.pyright.setup(common.make_config("pyright", settings))
    
    -- Create autocommand to verify LSP connection for Python files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        -- Set Python indentation
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
        vim.bo.expandtab = true
        
        -- Check for LSP connection
        vim.defer_fn(function()
          local clients = vim.lsp.get_active_clients({ bufnr = 0 })
          if #clients == 0 then
            print("No LSP clients attached to Python file. Starting Pyright...")
            vim.cmd('LspStart pyright')
          end
        end, 1000)
      end
    })
  else
    print("Pyright LSP server not available - Please install with: npm install -g pyright")
  end
end

return M
