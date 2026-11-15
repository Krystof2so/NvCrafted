-- *************************************************************
-- * lua/plugins/editing/multicursor.lua                       *
-- * GitHub : https://github.com/jake-stewart/multicursor.nvim *
-- *                                                           *
-- * Édition multi-curseurs.                                   *
-- * - Création des curseurs : core/keymaps.lua (<leader>m)    *
-- * - Raccourcis actifs seulement avec plusieurs curseurs :   *
-- *   définis ici (couche de mappings)                        *
-- * - Couleurs : core/highlights/multicursor_hl.lua           *
-- * Aide disponible via :h multicursor                        *
-- *************************************************************

return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	event = "VeryLazy",
	config = function()
		local mc = require("multicursor-nvim")
		mc.setup()

		-- Ces mappings n'existent que lorsqu'il y a plusieurs curseurs
		mc.addKeymapLayer(function(set)
			set("n", "<Esc>", mc.clearCursors, { desc = "Supprimer les curseurs secondaires" })
		end)
	end,
}
