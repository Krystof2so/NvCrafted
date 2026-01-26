-- *********************************************************************
-- * plugins/coding/blink.lua                                          *
-- *                                                                   *
-- * Complétion avec blink.nvim, intégrée avec LuaSnip et snippets     *
-- * Configuration UX : menu et documentation flottante bien délimités *
-- *********************************************************************

return {
	"saghen/blink.cmp",
	version = "*",

	dependencies = {
		"rafamadriz/friendly-snippets",
		"L3MON4D3/LuaSnip",
	},

	event = "InsertEnter", -- Chargement en mode insertion (optimal pour les performances)

	opts = {
		keymap = { -- Personnalisation des raccourcis clavier
			preset = "default", -- important
			["<CR>"] = { "accept", "fallback" }, -- Valider avec Entrée
			["<Tab>"] = { "select_next", "fallback" }, -- Navigation avec Tab
			["<S-Tab>"] = { "select_prev", "fallback" }, -- Navigation inverse
			["<C-Space>"] = { "show" }, -- Déclencher manuellement la complétion
		},

		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 50, -- Délai d'affichage
				window = { -- Aspect des fenêtres popups
					border = "rounded",
					max_width = 80,
					max_height = 40,
				},
			},
			menu = { -- Aspect des fenêtres popups
				border = "rounded",
				max_height = 18,
				min_width = 30,
			},
		},

		signature = { enabled = true },

		sources = { -- Sources de complétion prioritaires
			default = { "lsp", "buffer", "snippets", "path" },
		},
	},

	config = function(_, opts)
		require("blink.cmp").setup(opts)

		-- Chargement paresseux des snippets VSCode
		require("luasnip.loaders.from_vscode").lazy_load()

		-- Couleurs pour les fenêtres flottantes LSP/complétion (Cohérence avec le thème 'Nord')
		vim.cmd([[
      hi LspFloatBorder guifg=#81a1c1 guibg=#2e3440
      hi LspFloatWinNormal guibg=#3b4252 guifg=#d8dee9
    ]])
	end,
}
