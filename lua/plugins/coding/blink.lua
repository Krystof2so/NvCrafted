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
		"onsails/lspkind-nvim",
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
				draw = {
					components = {
						kind_icon = {
							text = function(ctx)
								return require("lspkind").symbol_map[ctx.kind] or ""
							end,
						},
					},
				},
			},
		},

		signature = { enabled = true },

		sources = { -- Sources de complétion prioritaires
			default = { "lazydev", "lsp", "buffer", "snippets", "path", "cmdline" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100, -- lazydev prioritaire sur les suggestions LSP génériques
				},
			},
		},
	},

	config = function(_, opts)
		require("blink.cmp").setup(opts)

		-- Chargement paresseux des snippets VSCode + snippets locaux
		require("luasnip.loaders.from_vscode").lazy_load({
			paths = {
				vim.fn.stdpath("config") .. "/snippets", -- Répertoire des snippets locaux
			},
		})
	end,
}
