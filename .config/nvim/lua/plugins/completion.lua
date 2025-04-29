-- plugins/completion.lua
-- Setup for nvim-cmp completion engine

local has_cmp, cmp = pcall(require, 'cmp')
if not has_cmp then
  print("Warning: nvim-cmp not found")
  return
end

-- Check for snippets support
local has_luasnip, luasnip = pcall(require, 'luasnip')

-- Setup nvim-cmp
cmp.setup {
  snippet = {
    expand = function(args)
      if has_luasnip then
        luasnip.lsp_expand(args.body)
      end
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_luasnip and luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif has_luasnip and luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },  -- LSP completions (most important for our case)
    { name = 'luasnip' },   -- Snippets
    { name = 'buffer' },    -- Buffer text
    { name = 'path' },      -- File paths
  }),
  formatting = {
    format = function(entry, vim_item)
      -- Source indicators
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end
  },
  experimental = {
    ghost_text = true,
  },
}

-- Enable completion specifically for cmdline
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' }
  })
})

-- Make sure nvim-cmp capabilities are exported for LSP use
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Create global variable so other modules can access these capabilities
vim.g.cmp_lsp_capabilities = cmp_capabilities

-- Confirm setup
print("nvim-cmp completion setup complete")
