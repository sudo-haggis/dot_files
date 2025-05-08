-- plugins/lsp/go.lua
-- Go LSP configuration using consistent keybindings

local M = {}

function M.setup(lspconfig, _)
  -- Get common module
  local common = require('plugins.lsp.common')
  
  -- Go-specific settings
  local settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
        nilness = true,
        unusedwrite = true,
        useany = true,
      },
      staticcheck = true,
      usePlaceholders = true,
      completeUnimported = true,
      matcher = "fuzzy",
      diagnosticsDelay = "500ms",
      symbolMatcher = "fuzzy",
      symbolStyle = "dynamic",
      gofumpt = true,  -- Use gofumpt formatting
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    }
  }
  
  -- Setup gopls with consistent configuration
  if lspconfig.gopls then
    lspconfig.gopls.setup(common.make_config("gopls", settings))
    
    -- Go-specific settings via FileType autocommand
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        
        -- Set Go indentation (tabs)
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
        vim.bo.expandtab = false  -- Go uses tabs by convention
        
        -- Go-specific keymaps
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', '<leader>gt', '<cmd>GoTest<CR>', opts)
        vim.keymap.set('n', '<leader>gtf', '<cmd>GoTestFunc<CR>', opts)
        vim.keymap.set('n', '<leader>gi', '<cmd>GoImport<CR>', opts)
        vim.keymap.set('n', '<leader>gim', '<cmd>GoImports<CR>', opts)
        
        -- Check for LSP connection
        vim.defer_fn(function()
          local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
          if #clients == 0 then
            print("No LSP clients attached to Go file. Starting gopls...")
            vim.cmd('LspStart gopls')
          end
        end, 1000)
      end
    })
    
    -- Run goimports on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        for _, res in pairs(result or {}) do
          for _, r in pairs(res.result or {}) do
            if r.edit then
              vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
            else
              vim.lsp.buf.execute_command(r.command)
            end
          end
        end
      end,
    })
  else
    print("Gopls LSP server not available - Please install with: go install golang.org/x/tools/gopls@latest")
  end
end

return M
