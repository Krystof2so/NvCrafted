-- ***************************************************
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
			},
			spec = {
				{ "gc", group = "Commentaires", mode = { "n", "v" } },
				{ "gb", group = "Commentaires (bloc)", mode = { "n", "v" } },
                { "gr", group = "LSP références", mode = "n" },
                { "gd", desc = "Aller à la définition", mode = "n" },
                { "gD", desc = "Aller à la déclaration", mode = "n" },
                { "K",  desc = "Documentation (hover)", mode = "n" },
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
			local wk = require("which-key")
			local hl = vim.api.nvim_set_hl
			wk.setup(opts)
			-- fond global du popup
			hl(0, "NormalFloat", { bg = "#3b4252", fg = "#D8DEE9" })
			-- bordure
			hl(0, "WhichKeyBorder", { bg = "#3b4252", fg = "#b48ead" })
			-- description et texte
			hl(0, "WhichKeyDesc", { fg = "#81A1C1" })
			hl(0, "WhichKeyGroup", { fg = "#8FBCBB", bold = true })
			hl(0, "WhichKeySeparator", { fg = "#d08770" })
			hl(0, "WhichKeyValue", { fg = "#d08770" })
		end,
	},
}
