-- which key configuration

local M = {}

function M.setup()
    local which_key = require("which-key")

    which_key.setup({
        --lay down those configurationization here
        window = {
            border = "rounded",
            position = "bottom",
        },
        layout = {
            height = { min = 4, max = 25 },
            width = { min = 20, max = 50},
        },
    })

    --custom colours, not that native PINK!
    vim.cmd([[
        highlight! Title guifg=#7aa2f7 guibg=#1a1b26
        highlight! Pmenu guibg=#1a1b26 guifg=#c0caf5
        highlight! PmenuSel guibg=#3b4261 guifg=#7aa2f7
        highlight! NormalFloat guibg=#1a1b26 guifg=#c0caf5
        highlight! FloatBorder guibg=#1a1b26 guifg=#3b4261
        highlight! Visual guibg=#3b4261 guifg=#c0caf5
    ]])
end

return M
