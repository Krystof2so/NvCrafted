-- lua/plugins/ux/snacks.lua
return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		-- Tous les modules sont désactivés par défaut, sauf :
		-- =======================================
		-- input
		-- =======================================
		input = {
			enabled = true,
		},
	},
}
