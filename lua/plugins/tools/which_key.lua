-- * GitHub: https://github.com/folke/which-key.nvim *
-- *                                                 *
-- * WhichKey aide à mémoriser les raccourcis        *
-- * clavier Neovim en les affichant dans une        *
-- * fenêtre contextuelle pendant la saisie.         *
-- ***************************************************

return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		dependencies = {
			"echasnovski/mini.icons",
		},
		opts = { -- configuration personnalisée
			presets = "helix",
			win = {
				border = "rounded",
				no_overlap = false,
				padding = { 1, 2 },
				title = false,
				zindex = 1000,
				-- Positionnement flottant
				row = -1, -- -1 = colle au bas de l'écran (valeur négative = depuis le bas)
				col = -1, -- -1 = colle à droite de l'écran
				width = { min = 20, max = 120 }, -- jamais moins de 20, jamais plus de 120 colonnes
				height = { min = 4, max = 40 }, -- jamais moins de 4, jamais plus de 40 lignes
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
		config = function(_, opts)
			require("which-key").setup(opts)
		end,
	},
}
