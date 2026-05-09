-- *************************************************************
-- * core/highlights/blink.lua                                 *
-- *                                                           *
-- * Highlights adaptatifs pour blink.cmp et les fenêtres      *
-- * flottantes LSP.                                           *
-- * Consomme core/highlights/palettes.lua                     *
-- *                                                           *
-- * Appelé depuis core/highlights/init.lua                    *
-- *************************************************************

local M = {}

function M.setup()
	local p = require("core.highlights.palettes").get()
	local hl = vim.api.nvim_set_hl

	-- Fenêtres flottantes LSP (hover, signature, documentation blink.cmp)
	hl(0, "LspFloatBorder", { fg = p.info.hex, bg = p.surface.hex })
	hl(0, "LspFloatWinNormal", { fg = p.text.hex, bg = p.overlay.hex })

	-- Bordure du menu de complétion
	hl(0, "BlinkCmpMenuBorder", { fg = p.info.hex, bg = p.surface.hex })
	-- Bordure de la fenêtre de documentation
	hl(0, "BlinkCmpDocBorder", { fg = p.muted.hex, bg = p.surface.hex })
	-- Élément sélectionné dans le menu
	hl(0, "BlinkCmpMenuSelection", { bg = p.overlay.hex, bold = true })
end

return M
