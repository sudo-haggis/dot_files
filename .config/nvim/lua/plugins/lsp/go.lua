-- Go-specific LSP configuration

local M = {}

function M.setup(lspconfig, capabilities)
  -- Go LSP setup
  pcall(function()
    lspconfig.gopls.setup{
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        -- Set keybindings
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
      end
    }
  end)
  
  -- Go-specific autocommand
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'go',
    callback = function()
      -- Start LSP if not running
      local bufnr = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
      if #clients == 0 then
        vim.defer_fn(function()
          pcall(vim.cmd, 'LspStart gopls')
        end, 100)
      end
    end
  })
end

return M
