-- ************************************************************
-- * lua/plugins/ui/barbar.lua                                *
-- *                                                          *
-- * barbar.nvim : gestion des onglets (tabline) de Neovim.   *
-- * - Affichage des buffers ouverts sous forme d'onglets.    *
-- * - Intégration Git via gitsigns.nvim.                     *
-- * - Icônes via nvim-web-devicons.                          *
-- *                                                          *
-- * GitHub : https://github.com/romgrk/barbar.nvim           *
-- ************************************************************

return {
	"romgrk/barbar.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim", -- statut Git dans les onglets
		"nvim-tree/nvim-web-devicons", -- icônes de types de fichiers
	},
	init = function()
		vim.g.barbar_auto_setup = false -- Désactive l'initialisation automatique
	end,
	opts = {
		separator = { left = "", right = "" }, -- Séparateurs entre les onglets (Powerline)
		separator_at_end = true, -- affiche un séparateur après le dernier onglet
		animation = true, -- Animation lors du déplacement / fermeture d'un onglet
		auto_hide = true, -- Fermeture automatique de barbar si un seul buffer est ouvert
		icons = {
			buffer_index = true, -- numéro de buffer (utile pour les raccourcis)
			buffer_number = false,
			button = "", -- icône du bouton de fermeture
			-- Indicateurs de diagnostic LSP dans chaque onglet
			diagnostics = {
				{ enabled = true, icon = "●" }, -- Error
				{ enabled = true, icon = "●" }, -- Warn
				{ enabled = false }, -- Info  (désactivé)
				{ enabled = false }, -- Hint  (désactivé)
			},
			-- Indicateurs Git (visuel chiffré)
			gitsigns = {
				added = { enabled = true, icon = "+" }, -- '+2'
				changed = { enabled = true, icon = "~" }, -- '~5'
				deleted = { enabled = true, icon = "-" }, -- '-6'
			},
			filetype = {
				enabled = true, -- icône de type de fichier (nvim-web-devicons)
			},
			modified = { button = "●" }, -- indicateur de fichier modifié
			pinned = { button = "󰐃", filename = true }, -- onglet épinglé
		},

		sidebar_filetypes = {
			-- Intégration Neo-tree : masque la barre barbar dans le panneau Neo-tree
			["neo-tree"] = {
				event = "BufWipeout",
				text = " Arborescence",
				highlight = "PanelHeading",
			},
		},
	},
}
