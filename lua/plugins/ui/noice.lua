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

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
	opts = {
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
