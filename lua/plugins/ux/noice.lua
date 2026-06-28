-- *************************************************************
-- * plugins/ui/noice.lua                                      *
-- *                                                           *
-- * Noice.nvim dans NvCrafted :                               *
-- *   - Cmdline (popup centré avec icônes)                    *
-- *   - Popupmenu stylisé                                     *
-- *   - Routing des messages système vers nvim-notify         *
-- *                                                           *
-- * Historique des notifications :                            *
-- * - :Telescope notify                                       *
-- * - Rediriger les commandes Noice (history, last, etc.)     *
-- *   vers des popups avec détails                            *
-- *                                                           *
-- * Dépendances :                                             *
-- * - nui.nvim (requis)                                       *
-- * - nvim-notify (installé par ailleurs. Cf. notify.lua)     *
-- *************************************************************

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	---@module 'noice'
	---@type NoiceConfig
	opts = {
		-- ================================================================
		-- Messages : interceptés par Noice, routés vers nvim-notify
		-- l'historique est délégué à Telescope notify
		-- ================================================================
		messages = {
			enabled = true,
			view = "notify", -- messages courants → popup notify
			view_error = "notify", -- erreurs           → popup notify
			view_warn = "notify", -- warnings          → popup notify
			view_history = "messages", -- :messages         → buffer normal
			view_search = false, -- compteur /search  → désactivé
		},
		-- ================================================================
		-- Notify : Noice délègue à nvim-notify
		-- ================================================================
		notify = {
			enabled = true,
			view = "notify",
		},
		-- ================================================================
		-- LSP : aucun override — rendu markdown natif Neovim 0.11+
		-- lsp_doc_border géré via presets ci-dessous
		-- ================================================================
		lsp = {
			override = {},
		},
		-- ================================================================
		-- Cmdline : popup centré avec icônes par type de commande
		-- ================================================================
		cmdline = {
			enabled = true,
			view = "cmdline_popup",
			format = {
				cmdline = { icon = "" }, -- Stylo (U+F040)
				search_down = { icon = " " },
				search_up = { icon = " " },
				lua = { icon = "" },
			},
		},
		-- ================================================================
		-- Popupmenu : stylisé, centré sous la cmdline popup
		-- ================================================================
		popupmenu = {
			enabled = true,
			backend = "nui",
		},
		-- ================================================================
		-- Presets
		-- bottom_search   : / et ? restent en bas (convention Vim)
		-- command_palette : false — position gérée manuellement via views
		-- lsp_doc_border  : bordures arrondies sur hover et signature
		-- ================================================================
		presets = {
			bottom_search = true,
			command_palette = false,
			lsp_doc_border = true,
		},
		-- ================================================================
		-- Vues : position et dimensions de la cmdline popup et du menu
		-- ================================================================
		views = {
			cmdline_popup = {
				position = {
					row = 5,
					col = "50%",
				},
				size = {
					width = 60,
					height = "auto",
				},
			},
			popupmenu = {
				relative = "editor",
				position = {
					row = 8,
					col = "50%",
				},
				size = {
					width = 60,
					height = 10,
				},
				border = {
					style = "rounded",
					padding = { 0, 1 },
				},
				win_options = {
					winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
				},
			},
		},
	},
}
