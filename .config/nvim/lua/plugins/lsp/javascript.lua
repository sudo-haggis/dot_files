-- JavaScript/TypeScript-specific LSP configuration

local M = {}

function M.setup(lspconfig, capabilities)
  -- TypeScript/JavaScript LSP setup
  pcall(function()
    lspconfig.tsserver.setup{
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        -- Disable formatting from tsserver (use null-ls or prettier instead)
        client.server_capabilities.documentFormattingProvider = false
        
        -- Set keybindings
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ji', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>jr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>jt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true })
      end
    }
  end)
  
  -- JavaScript/TypeScript-specific autocommand
  vim.api.nvim_create_autocmd('FileType', {
    pattern = {'javascript', 'typescript', 'javascriptreact', 'typescriptreact'},
    callback = function()
      -- Start LSP if not running
      local bufnr = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
      if #clients == 0 then
        vim.defer_fn(function()
          pcall(vim.cmd, 'LspStart tsserver')
        end, 100)
      end
    end
  })
end

return M
