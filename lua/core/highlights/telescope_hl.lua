-- *************************************************************
-- * core/highlights/telescope_hl.lua                          *
-- *                                                           *
-- * Highlights adaptatifs pour Telescope.                     *
-- * Consomme core/highlights/palettes.lua                     *
-- *                                                           *
-- * Appelé depuis core/highlights/init.lua                    *
-- *************************************************************

local M = {}

function M.setup()
	local p = require("core.highlights.themes").get()
	local hl = vim.api.nvim_set_hl

	-- Entrée sélectionnée (survolée) dans Telescope
	hl(0, "TelescopeSelection", {
		fg = p.surface.hex, -- Couleur du texte (héritée de la palette)
		bg = p.warning.hex, -- Fond léger (comme dans blink_hl.lua)
		bold = true,
	})

	-- Autres highlights Telescope (optionnels)
	hl(0, "TelescopeBorder", { fg = p.muted.hex, bg = p.surface.hex })
	hl(0, "TelescopePromptBorder", { fg = p.info.hex, bg = p.surface.hex })
	hl(0, "TelescopeResultsBorder", { fg = p.info.hex, bg = p.surface.hex })
	hl(0, "TelescopePreviewBorder", { fg = p.muted.hex, bg = p.surface.hex })
end

return M
