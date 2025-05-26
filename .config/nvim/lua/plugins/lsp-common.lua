-- LSP Common configuration
-- Shared functionality for all language servers
local M = {}

-- Get capabilities for LSP servers
function M.get_capabilities()
  -- Use pcall to safely get capabilities
  local status, capabilities = pcall(vim.lsp.protocol.make_client_capabilities)
  if not status then
    print("Error getting LSP capabilities")
    return {}
  end
  
  -- Add completion capabilities from nvim-cmp
  local has_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
  if has_cmp and cmp_lsp.default_capabilities then
    local ok, enhanced_capabilities = pcall(cmp_lsp.default_capabilities, capabilities)
    if ok then
      capabilities = enhanced_capabilities
    end
  end
  
  return capabilities
end

-- Common keybindings for all LSP servers
function M.on_attach(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  
  -- Navigation
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  
  -- Leader mappings (these will show in which-key!)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
  
  -- Diagnostics
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  
  print(client.name .. " LSP attached to buffer " .. bufnr)
end

-- Setup diagnostics display
function M.setup_diagnostics()
  -- Only set up if diagnostic config exists
  if vim.diagnostic and vim.diagnostic.config then
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = "always",
      },
    })
  end
end

-- Setup LSP handlers
function M.setup_handlers()
  -- Only set up if handlers exist
  if vim.lsp.handlers then
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, { border = "rounded" }
    )
    
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, { border = "rounded" }
    )
  end
end

function M.setup()
  M.setup_diagnostics()
  M.setup_handlers()
  print("LSP common configuration loaded")
end

-- Call setup
M.setup()

return M
