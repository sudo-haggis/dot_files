-- plugins/lsp/php.lua
-- PHP LSP configuration using consistent keybindings

local M = {}

function M.setup(lspconfig, _)
  -- Get common module
  local common = require('plugins.lsp.common')
  
  -- PHP-specific settings
  local settings = {
    intelephense = {
      stubs = {
        "bcmath", "bz2", "calendar", "Core", "curl", "date", 
        "dba", "dom", "enchant", "fileinfo", "filter", "ftp", 
        "gd", "gettext", "hash", "iconv", "imap", "intl", 
        "json", "ldap", "libxml", "mbstring", "mysqli", "mysqlnd", 
        "oci8", "openssl", "pcntl", "pcre", "PDO", "pdo_mysql", 
        "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar", "posix", 
        "pspell", "readline", "Reflection", "session", "shmop", 
        "SimpleXML", "snmp", "soap", "sockets", "sodium", "SPL", 
        "sqlite3", "standard", "superglobals", "sysvmsg", "sysvsem", 
        "sysvshm", "tidy", "tokenizer", "xml", "xmlreader", 
        "xmlrpc", "xmlwriter", "xsl", "Zend OPcache", "zip", "zlib"
      },
      stubsLocation = vim.fn.expand('~/.config/intelephense/stubs'),
      files = {
        maxSize = 5000000
      },
      environment = {
        phpVersion = "8.2.0"  -- Set to your PHP version
      },
      completion = {
        insertUseDeclaration = true,
        fullyQualifyGlobalConstantsAndFunctions = false,
        maxItems = 100
      },
      format = {
        enable = true
      },
      telemetry = {
        enable = false
      },
      diagnostics = {
        enable = true,
        undefinedTypes = false,
        undefinedFunctions = false,
        undefinedConstants = false,
        undefinedMethods = false
      }
    }
  }
  
  -- Configuration options
  local init_options = {
    licenceKey = nil,
    showFunctionSignatures = true,
    showDocumentationInSignatureHelp = true
  }
  
  -- Setup intelephense with consistent configuration
  if lspconfig.intelephense then
    local config = common.make_config("intelephense", settings)
    config.init_options = init_options
    
    lspconfig.intelephense.setup(config)
    
    -- PHP-specific settings via FileType autocommand
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "php",
      callback = function()
        -- Set PHP indentation
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
        vim.bo.expandtab = true
        
        -- Check for LSP connection
        vim.defer_fn(function()
          local clients = vim.lsp.get_active_clients({ bufnr = 0 })
          if #clients == 0 then
            print("No LSP clients attached to PHP file. Starting intelephense...")
            vim.cmd('LspStart intelephense')
          end
        end, 1000)
      end
    })
  else
    print("Intelephense LSP server not available - Please install with: npm install -g intelephense")
  end
end

return M
