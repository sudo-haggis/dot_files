-- Svelte-specific LSP configuration

local M = {}

function M.setup(lspconfig, capabilities)
  -- Svelte LSP setup
  pcall(function()
    lspconfig.svelte.setup{
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        -- Set keybindings
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>si', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>sr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
      end
    }
  end)
  
  -- Svelte-specific autocommand
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'svelte',
    callback = function()
      -- Start LSP if not running
      local bufnr = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
      if #clients == 0 then
        vim.defer_fn(function()
          pcall(vim.cmd, 'LspStart svelte')
        end, 100)
      end
    end
  })
end

return M
