#!/bin/bash
# Setup script for modular Neovim configuration

# Create the necessary directories
mkdir -p ~/.config/nvim/lua/core
mkdir -p ~/.config/nvim/lua/plugins/lsp
mkdir -p ~/.config/nvim/after/plugin

# Backup existing configuration
if [ -f ~/.config/nvim/init.lua ]; then
  echo "Backing up existing init.lua"
  mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.bak
fi

# Create the main init.lua file
cat > ~/.config/nvim/init.lua << 'EOF'
-- Main Neovim configuration entry point

-- Load core modules
require('core.options')      -- Basic Vim options
require('core.keymaps')      -- Global keymaps 
require('core.plugins')      -- Plugin definitions with Packer

-- Load plugin configurations
require('plugins.completion') -- Completion setup
require('plugins.lsp')       -- LSP configurations
require('plugins.treesitter') -- Treesitter configuration
require('plugins.go')        -- Go-specific config
EOF

# Create core options file
cat > ~/.config/nvim/lua/core/options.lua << 'EOF'
-- Basic Settings
vim.opt.number = true             -- Show line numbers
vim.opt.relativenumber = true     -- Show relative line numbers
vim.opt.mouse = 'a'               -- Enable mouse support
vim.opt.ignorecase = true         -- Case insensitive searching
vim.opt.smartcase = true          -- Case sensitive if caps used
vim.opt.wrap = false              -- Don't wrap lines
vim.opt.tabstop = 4               -- Tab width
vim.opt.shiftwidth = 4            -- Indent width
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.termguicolors = true      -- Enable true color support
vim.opt.completeopt = 'menu,menuone,noselect'  -- Required for LSP

-- Set leader key to space
vim.g.mapleader = ' '

-- Arduino file detection
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.ino",
  callback = function()
    vim.bo.filetype = "arduino"
  end
})
EOF

# Create core keymaps file
cat > ~/.config/nvim/lua/core/keymaps.lua << 'EOF'
-- Global Keymappings

-- TMUX navigation configuration
-- Set this to 1 to disable default mappings and use our explicit ones below
vim.g.tmux_navigator_no_mappings = 1

-- Set explicit mappings for tmux navigation
vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-\\>', '<cmd>TmuxNavigatePrevious<CR>', { silent = true, noremap = true })

-- The Arduino autocmd (separate call)
vim.api.nvim_create_autocmd('FileType', {
  pattern = "arduino",
  callback = function()
    vim.api.nvim_set_keymap('n', '<F5>', ':!arduino-cli compile --fqbn arduino:avr:uno %:p<CR>', { noremap = true, silent = false })
    vim.api.nvim_set_keymap('n', '<F6>', ':!arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno %:p<CR>', { noremap = true, silent = false })
  end
})

-- General LSP keybindings (available in all LSP enabled buffers)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    -- Set keybindings
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true })
  end,
})
EOF

# Create core plugins file
cat > ~/.config/nvim/lua/core/plugins.lua << 'EOF'
-- Plugin configuration with Packer

-- Bootstrap packer if not installed
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  print "Installing packer.nvim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Initialize packer
vim.cmd [[packadd packer.nvim]]

-- Use protected require for Packer
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  print("Packer not found!")
  return
end

-- Plugin configuration
packer.startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
 
  -- Add vim-tmux-navigator
  use 'christoomey/vim-tmux-navigator'
  
  -- Theme
  use {
    'folke/tokyonight.nvim',
    config = function()
      vim.cmd[[colorscheme tokyonight-storm]]
    end
  }
  
  -- LSP and completion plugins
  use {
    'neovim/nvim-lspconfig',
    tag = 'v0.1.7',  -- Pin to a specific version tag that works with your Neovim
  }
  
  -- Completion framework
  use 'hrsh7th/nvim-cmp'  -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-buffer'  -- Buffer completions
  use 'hrsh7th/cmp-path'    -- Path completions
  use 'L3MON4D3/LuaSnip'    -- Snippet engine
  use 'saadparwaiz1/cmp_luasnip' -- Snippet completions
  
  -- Go specific plugins
  use 'ray-x/go.nvim'
  use 'ray-x/guihua.lua' -- recommended for go.nvim
  
  -- JavaScript/TypeScript support
  use 'jose-elias-alvarez/null-ls.nvim'  -- Additional diagnostics
  use 'jose-elias-alvarez/typescript.nvim'  -- TypeScript enhancements
  
  -- Svelte support
  use 'evanleck/vim-svelte'  -- Svelte syntax highlighting and indentation
  use {
    'leafOfTree/vim-svelte-plugin',
    ft = 'svelte'  -- Only load for Svelte files
  }
  
  -- Treesitter for better syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }
end)
EOF

# Create completion.lua
cat > ~/.config/nvim/lua/plugins/completion.lua << 'EOF'
-- Setup for nvim-cmp and autocompletion

local M = {}

function M.setup()
  -- Set up nvim-cmp
  local cmp_ok, cmp = pcall(require, 'cmp')
  if not cmp_ok then
    print("nvim-cmp not available")
    return
  end
  
  local luasnip_ok, luasnip = pcall(require, 'luasnip')
  if not luasnip_ok then
    print("LuaSnip not available")
    return
  end
  
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
    })
  })
end

-- Initialize the completion system
M.setup()

return M
EOF

# Create LSP main file
cat > ~/.config/nvim/lua/plugins/lsp/init.lua << 'EOF'
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
EOF

# Create PHP LSP file
cat > ~/.config/nvim/lua/plugins/lsp/php.lua << 'EOF'
-- PHP-specific LSP configuration

local M = {}

function M.setup(lspconfig, capabilities)
  -- PHP Language Server setup
  pcall(function()
    lspconfig.intelephense.setup{
      capabilities = capabilities,
      settings = {
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
            phpVersion = "8.2.0"  -- Set to your version of PHP
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
      },
      init_options = {
        licenceKey = nil,
        showFunctionSignatures = true,
        showDocumentationInSignatureHelp = true
      }
    }
  end)
  
  -- PHP-specific autocommand
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'php',
    callback = function()
      -- Set keybindings
      vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>pd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>pr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
      
      -- Start LSP if not running
      local bufnr = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
      if #clients == 0 then
        vim.defer_fn(function()
          pcall(vim.cmd, 'LspStart intelephense')
        end, 100)
      end
    end
  })
end

return M
EOF

# Create JavaScript LSP file
cat > ~/.config/nvim/lua/plugins/lsp/javascript.lua << 'EOF'
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
EOF

# Create Svelte LSP file
cat > ~/.config/nvim/lua/plugins/lsp/svelte.lua << 'EOF'
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
EOF

# Create Go LSP file
cat > ~/.config/nvim/lua/plugins/lsp/go.lua << 'EOF'
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
EOF

# Create YAML LSP file
cat > ~/.config/nvim/lua/plugins/lsp/yaml.lua << 'EOF'
-- YAML-specific LSP configuration

local M = {}

function M.setup(lspconfig, capabilities)
  -- YAML Language Server setup
  pcall(function()
    lspconfig.yamlls.setup{
      capabilities = capabilities,
      settings = {
        yaml = {
          schemas = {
            [vim.fn.expand("~/.config/schemas/docker-compose-schema.json")] = "/*docker-compose*.{yml,yaml}",
            ["https:--json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          },
        },
      }
    }
  end)
end

return M
EOF

# Create Treesitter configuration file
cat > ~/.config/nvim/lua/plugins/treesitter.lua << 'EOF'
-- Treesitter configuration

local M = {}

function M.setup()
  -- Set up treesitter if available
  pcall(function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { 
        "lua", 
        "vim", 
        "go", 
        "php", 
        "yaml", 
        "json", 
        "javascript", 
        "typescript", 
        "svelte" 
      },
      auto_install = true,
      highlight = {
        enable = true,
      },
    }
  end)
end

-- Initialize treesitter
M.setup()

return M
EOF

# Create Go plugin configuration file
cat > ~/.config/nvim/lua/plugins/go.lua << 'EOF'
-- Go plugin configuration

local M = {}

function M.setup()
  -- Set up go.nvim if available
  pcall(function()
    require('go').setup()
  end)
end

-- Initialize go configuration
M.setup()

return M
EOF

echo "Neovim modular configuration has been set up successfully!"
echo "Your previous init.lua has been backed up to ~/.config/nvim/init.lua.bak"
echo "You can now restart Neovim to use the new configuration."
echo "Note: You may need to run :PackerSync the first time to install/update plugins."
