-- plugins/lsp/yaml.lua
-- YAML LSP configuration using consistent keybindings

local M = {}

function M.setup(lspconfig, _)
  -- Get common module
  local common = require('plugins.lsp.common')
  
  -- YAML-specific settings
  local settings = {
    yaml = {
      format = {
        enable = true,
        singleQuote = false,
        bracketSpacing = true,
      },
      validate = true,
      hover = true,
      completion = true,
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = {
        kubernetes = {
          "daemon.{yml,yaml}",
          "manager.{yml,yaml}",
          "restapi.{yml,yaml}",
          "role.{yml,yaml}",
          "role_binding.{yml,yaml}",
          "*onfigma*.{yml,yaml}",
          "*ngres*.{yml,yaml}",
          "*ecre*.{yml,yaml}",
          "*eployment*.{yml,yaml}",
          "*ervic*.{yml,yaml}",
          "kubectl-edit*.yaml",
        },
        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
        ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
        ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
        ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
        ["https://json.schemastore.org/helmfile"] = "helmfile.{yml,yaml}",
        ["https://json.schemastore.org/drone"] = ".drone.{yml,yaml}",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
        ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
      },
    },
  }
  
  -- Setup yaml-language-server with consistent configuration
  if lspconfig.yamlls then
    lspconfig.yamlls.setup(common.make_config("yamlls", settings))
    
    -- YAML-specific settings via FileType autocommand
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "yaml",
      callback = function()
        -- Set YAML indentation
        vim.bo.tabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.expandtab = true
        
        -- Check for LSP connection
        vim.defer_fn(function()
          local clients = vim.lsp.get_active_clients({ bufnr = 0 })
          if #clients == 0 then
            print("No LSP clients attached to YAML file. Starting yaml-language-server...")
            vim.cmd('LspStart yamlls')
          end
        end, 1000)
      end
    })
  else
    print("YAML LSP server not available - Please install with: npm install -g yaml-language-server")
  end
end

return M
