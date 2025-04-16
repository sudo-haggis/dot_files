-- Main LSP configuration

local M = {}

function M.setup()
  -- Setup LSP
  local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
  if not lspconfig_ok then
    print("nvim-lspconfig not available")
    return
  end
  
  -- Make sure cmp_nvim_lsp is available before setting capabilities
  local capabilities
  local cmp_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if cmp_lsp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities()
  end
  
  -- Set up custom hover handler
  pcall(function()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })
  end)
  
  -- Load language-specific configurations
  local php_ok, php = pcall(require, 'plugins.lsp.php')
  if php_ok then
    php.setup(lspconfig, capabilities)
  end
  
  local js_ok, js = pcall(require, 'plugins.lsp.javascript')
  if js_ok then
    js.setup(lspconfig, capabilities)
  end
  
  local go_ok, go = pcall(require, 'plugins.lsp.go')
  if go_ok then
    go.setup(lspconfig, capabilities)
  end
  
  local yaml_ok, yaml = pcall(require, 'plugins.lsp.yaml')
  if yaml_ok then
    yaml.setup(lspconfig, capabilities)
  end
  
  local svelte_ok, svelte = pcall(require, 'plugins.lsp.svelte')
  if svelte_ok then
    svelte.setup(lspconfig, capabilities)
  end
end

-- Initialize the LSP
M.setup()

return M
