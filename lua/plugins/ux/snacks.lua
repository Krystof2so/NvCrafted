-- *************************************************************
-- * lua/plugins/ux/snacks.lua                                 *
-- *                                                           *
-- * Déclaration Lazy de snacks.nvim.                          *
-- * Modules activés :                                         *
-- *    - dashboard                                            *
-- *    - input                                                *
-- *    - win                                                  *
-- *                                                           *
-- * Convention spécification / déclaration :                  *
-- *   déclaration  →  ce fichier                              *
-- *   spécification →  core/snacks_config/[nom_module].lua    *
-- *************************************************************

return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	opts = function()
		return {
			-- Tous les modules sont désactivés par défaut, sauf :
			input = { enabled = true },
			win = { enabled = true },
			dashboard = require("core.snacks_config.dashboard").config(),
		}
	end,
}
