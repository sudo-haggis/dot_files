-- plugins/lsp/python.lua
-- Python-specific LSP configuration

local M = {}

function M.setup(lspconfig, _)
  -- Get common LSP functionality
  local common = require('plugins.lsp.common')
  
  -- Python-specific settings
  local settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic"
      }
    }
  }
  
  -- Python-specific on_attach additions
  local function on_attach(client, bufnr)
    -- Python-specific keybindings (using the 'p' prefix)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<leader>pd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<leader>pr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>pf', function() vim.lsp.buf.format({async = true}) end, opts)
    
    -- Set Python indentation
    vim.bo[bufnr].tabstop = 4
    vim.bo[bufnr].shiftwidth = 4
    vim.bo[bufnr].expandtab = true
  end
  
  -- Setup pyright with common config
  lspconfig.pyright.setup(common.make_config("pyright", settings, on_attach))
  
  -- Create autocommand to verify LSP connection for Python files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
      vim.defer_fn(function()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if #clients == 0 then
          print("No LSP clients attached to Python file. Starting Pyright...")
          vim.cmd('LspStart pyright')
        end
      end, 1000)
    end
  })
end

return M
