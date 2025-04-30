-- plugins/lsp/common.lua
-- Central shared LSP functionality for all language servers

local M = {}

-- Get standardized capabilities for all language servers
function M.get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  
  -- Enhance with nvim-cmp capabilities if available
  local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if has_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  
  -- Ensure completion capabilities explicitly enabled
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
  }
  
  return capabilities
end

-- Common on_attach function for all language servers
function M.on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  
  -- Mappings all LSPs should have
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
  
  -- Diagnostic navigation
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  
  -- Enable code lens if supported
  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = bufnr,
      callback = vim.lsp.codelens.refresh
    })
  end
  
  -- Print confirmation
  print(client.name .. " attached to buffer " .. bufnr)
end

-- Setup diagnostic display (shared across all LSPs)
function M.setup_diagnostics()
  -- Configure diagnostics display
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
  
  -- Set diagnostic signs
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

-- Setup handlers (shared across all LSPs)
function M.setup_handlers()
  -- Nicer hover window
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      border = "rounded",
      width = 60
    }
  )
  
  -- Nicer signature help
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
      border = "rounded",
      width = 60
    }
  )
end

-- Helper to create language-specific server setup
function M.make_config(server_name, extra_settings, extra_on_attach)
  -- Get standard capabilities
  local capabilities = M.get_capabilities()
  
  -- Base configuration all servers should have
  local config = {
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    on_attach = function(client, bufnr)
      -- Call common on_attach first
      M.on_attach(client, bufnr)
      
      -- Call language-specific on_attach if provided
      if extra_on_attach then
        extra_on_attach(client, bufnr)
      end
    end
  }
  
  -- Merge in any extra settings
  if extra_settings then
    config.settings = extra_settings
  end
  
  return config
end

return M
