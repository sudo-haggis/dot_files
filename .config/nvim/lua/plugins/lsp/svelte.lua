-- plugins/lsp/svelte.lua
-- Svelte LSP configuration using consistent keybindings

local M = {}

function M.setup(lspconfig, _)
  -- Get common module
  local common = require('plugins.lsp.common')
  
  -- Svelte-specific settings
  local settings = {
    svelte = {
      plugin = {
        html = {
          completions = {
            enable = true,
            emmet = true,
          },
        },
        svelte = {
          diagnostics = {
            enable = true,
          },
          format = {
            enable = true,
          },
          completions = {
            enable = true,
          },
          codeActions = {
            enable = true,
          },
          hover = {
            enable = true,
          },
        },
        css = {
          completions = {
            enable = true,
            emmet = true,
          },
          hover = {
            enable = true,
          },
          diagnostics = {
            enable = true,
          },
          format = {
            enable = true,
          },
        },
        typescript = {
          hover = {
            enable = true,
          },
          diagnostics = {
            enable = true,
          },
          completions = {
            enable = true,
          },
          codeActions = {
            enable = true,
          },
          selectionRange = {
            enable = true,
          },
          signatureHelp = {
            enable = true,
          },
        },
      },
    },
  }
  
  -- Setup svelte with consistent configuration
  if lspconfig.svelte then
    lspconfig.svelte.setup(common.make_config("svelte", settings))
    
    -- Svelte-specific settings via FileType autocommand
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "svelte",
      callback = function()
        -- Set Svelte indentation
        vim.bo.tabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.expandtab = true
        
        -- Check for LSP connection
        vim.defer_fn(function()
          local clients = vim.lsp.get_active_clients({ bufnr = 0 })
          if #clients == 0 then
            print("No LSP clients attached to Svelte file. Starting svelte-language-server...")
            vim.cmd('LspStart svelte')
          end
        end, 1000)
      end
    })
  else
    print("Svelte LSP server not available - Please install with: npm install -g svelte-language-server")
  end
end

return M
