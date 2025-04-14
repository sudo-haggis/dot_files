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

-- Plugin configuration with Packer
vim.cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
 
    -- Add vim-tmux-navigator
    use 'christoomey/vim-tmux-navigator'
    
    -- LSP and completion plugins (order matters)
    use 'neovim/nvim-lspconfig'  -- Must be before cmp
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    
    -- Go specific plugins
    use 'ray-x/go.nvim'
    use 'ray-x/guihua.lua' -- recommended for go.nvim 
    
    -- Treesitter for better syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use {
        'folke/tokyonight.nvim',
        config = function()
            vim.cmd[[colorscheme tokyonight-storm]]  -- Or tokyonight-storm
        end
    }
end)

-- Explicit tmux-navigator configuration
-- Set this to 1 to disable default mappings and use our explicit ones below
vim.g.tmux_navigator_no_mappings = 1

-- Set explicit mappings for tmux navigation
vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-\\>', '<cmd>TmuxNavigatePrevious<CR>', { silent = true, noremap = true })
    
-- LSP Configuration
local lspconfig = require('lspconfig')
-- YAML Language Server setup
lspconfig.yamlls.setup{
    settings = {
        yaml = {
            schemas = {
                [vim.fn.expand("~/.config/schemas/docker-compose-schema.json")] = "/*docker-compose*.{yml,yaml}",
                ["https:--json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            },
        },
    }
}

-- The Go autocmd
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'go',
    callback = function()
        -- print("Go file detected")
        -- Ensure LSP is started for Go files
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
        if #clients == 0 then
            -- print("No LSP client attached, attempting to start gopls...")
            -- Add a small delay to allow LSP to initialize
            vim.defer_fn(function()
                vim.cmd('LspStart gopls')
                -- Check if it started
                local new_clients = vim.lsp.get_active_clients({ bufnr = bufnr })
                -- if #new_clients > 0 then
                    -- print("LSP started successfully")
                -- else
                    -- print("Failed to start LSP")
                -- end
            end, 100)
        else
            print("LSP already attached")
        end
    end
})

-- The Arduino autocmd (separate call)
vim.api.nvim_create_autocmd('FileType', {
    pattern = "arduino",
    callback = function()
        print("Arduino filetype detected!")

        -- Global Arduino mappings (will work with any file)
        vim.api.nvim_set_keymap('n', '<F5>', ':!arduino-cli compile --fqbn arduino:avr:uno %:p<CR>', { noremap = true, silent = false })
        vim.api.nvim_set_keymap('n', '<F6>', ':!arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno %:p<CR>', { noremap = true, silent = false })
    end
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = "*.ino",
    callback = function()
        vim.bo.filetype = "arduino"
    end
})

-- PHP Language Server setup
lspconfig.intelephense.setup{
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
                -- Reduce severity of undefined functions/classes for WordPress
                undefinedTypes = false,       -- Treat undefined types as hints
                undefinedFunctions = false,   -- Treat undefined functions as hints
                undefinedConstants = false,   -- Treat undefined constants as hints
                undefinedMethods = false      -- Treat undefined methods as hints
            }
        }
    },
    init_options = {
        licenceKey = nil,
        showFunctionSignatures = true,
        showDocumentationInSignatureHelp = true
    },
    on_attach = function(client, bufnr)
        print("Intelephense attached to buffer: " .. bufnr)
        
        -- Set keybindings
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(bufnr, 'i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap=true, silent=true})
    end
}
-- PHP-specific autocommand
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'php',
    callback = function()
        -- Set local keybindings for PHP files
        vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>pd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>pr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
        
        -- For function signature help as you type
        vim.api.nvim_buf_set_keymap(0, 'i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
    end
})
-- The PHP autocmd
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'php',
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
        if #clients == 0 then
            vim.defer_fn(function()
                vim.cmd('LspStart intelephense')
            end, 100)
        end
    end
})

-- Add this to your init.lua
vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
    if not result or not result.contents then
        print("No hover information available")
        return
    end
    print("Hover information available")
    -- Call the default handler
    vim.lsp.with(vim.lsp.handlers.hover, config)(_, result, ctx, config)
end
