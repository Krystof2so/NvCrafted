-- *************************************************************
-- * core/highlights/neo_tree.lua                              *
-- *                                                           *
-- * Highlights de neo-tree.nvim pour NvCrafted.               *
-- * Fenêtres flottantes (preview, popup) adaptées au thème.   *
-- * Consomme core/highlights/palettes.lua                     *
-- *                                                           *
-- * Appelé depuis core/highlights/init.lua                    *
-- *************************************************************

local M = {}

function M.setup()
	local p = require("core.highlights.themes").get()
	local hl = vim.api.nvim_set_hl

	-- Fond du popup de prévisualisation
	hl(0, "NeoTreeFloatNormal", {
		bg = p.surface.hex,
		fg = p.text.hex,
	})

	-- Bordure du popup : couleur d'accentuation du thème
	hl(0, "NeoTreeFloatBorder", {
		bg = p.surface.hex,
		fg = p.warning.hex,
	})

	-- Titre du popup : fond légèrement plus clair
	hl(0, "NeoTreeFloatTitle", {
		bg = p.overlay.hex,
		fg = p.text.hex,
		bold = true,
	})

	-- Barre de titre : fond encore plus clair, couleur info
	hl(0, "NeoTreeTitleBar", {
		bg = p.overlay.hex,
		fg = p.info.hex,
		bold = true,
	})
end

return M
