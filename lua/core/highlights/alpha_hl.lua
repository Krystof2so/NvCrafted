-- *************************************************************
-- * core/highlights/alpha_hl.lua                              *
-- *                                                           *
-- * Highlights de alpha-nvim pour NvCrafted.                  *
-- * Consomme core/highlights/palettes.lua                     *
-- *                                                           *
-- * Appelé depuis core/highlights/init.lua                    *
-- *************************************************************

local M = {}

function M.setup()
	local p = require("core.highlights.themes").get()
	local hl = vim.api.nvim_set_hl

	hl(0, "MyAsciiHeader", { fg = p.test.hex })
	hl(0, "NvCraftedHeader", { fg = p.warning.hex })
	hl(0, "NvCraftedWelcome", { fg = p.warning.hex })
	hl(0, "NvCraftedButton", { fg = p.warning.hex, bg = p.surface.hex })
	hl(0, "NvCraftedButtonShortcut", { fg = p.info.hex, bold = true })
	hl(0, "NvCraftedFooter", { fg = p.muted.hex })
end

return M
