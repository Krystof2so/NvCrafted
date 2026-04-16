-- *************************************************************
-- * plugins/ui/noice.lua                                      *
-- *                                                           *
-- * Remplacement complet de l'UI Neovim pour :                *
-- * - la cmdline (popup centré avec icônes et coloration)     *
-- * - les messages (routage vers vues configurables)          *
-- * - le popupmenu                                            *
-- * - la progression LSP                                      *
-- *                                                           *
-- * Dépendance : nui.nvim (déjà présent via neo-tree)         *
-- *************************************************************

-- Pour un affichage des sorties de commandes dans un popup
local joint_instruction = { view = "popup", opts = { enter = false, format = "details" } }

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			opts = { -- Pour des notifications sobres
				render = "default", -- juste le texte, sans encadré
				stages = "fade", -- animation de fondu
				timeout = 3000,
				top_down = false, -- notifications empilées depuis le bas à droite
				time_formats = {
					notification = "", -- supprime l'heure dans les notifications
					notification_history = "%H:%M", -- conserve l'heure dans l'historique
				},
			},
		},
	},
	opts = {
		-- Application de la vue personnalisée aux commandes Noice
		commands = {
			history = joint_instruction,
			last = joint_instruction,
			errors = joint_instruction,
			stats = joint_instruction,
		},
		-- Configuration de la cmdline avec icône de stylo
		cmdline = {
			format = {
				cmdline = { icon = "" }, -- Stylo (U+F040)
				search_down = { icon = " " },
				search_up = { icon = " " },
				lua = { icon = "" },
			},
		},
		lsp = {
			override = {
				-- Rendu markdown enrichi via Tree-sitter pour les docs LSP
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				-- Ne pas activer : en raison de l'absence nvim-cmp, NvCrafted utilise blink.cmp
				["cmp.entry.get_documentation"] = false,
			},
		},
		presets = {
			bottom_search = true, -- Recherche (/ et ?) en bas, classique
			command_palette = true, -- cmdline et popupmenu regroupés
			long_message_to_split = true, -- Longs messages dans un split plutôt qu'un popup
			lsp_doc_border = true, -- Bordure sur hover et signature (cohérent avec blink.cmp)
		},
	},
}
