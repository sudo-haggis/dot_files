-- plugins/autopairs.lua
-- Auto bracket/quote pair completion

local M = {}

function M.setup()
	local ok, autopairs = pcall(require, "mini.pairs")
	if not ok then
		vim.notify("mini.pairs not found!", vim.log.levels.ERROR)
		return
	end

	autopairs.setup(
        -- Example: disable backtick pairing
		-- mappings = {
		-- 	['`'] = false,
		-- },
    )
end

M.setup()

return M
