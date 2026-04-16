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
		-- Séparateurs entre les onglets (Powerline)
		separator = { left = "", right = "" },

		-- Séparateurs pour l'onglet actif (peut différer du style général)
		separator_at_end = true, -- affiche un séparateur après le dernier onglet

		-- Animation lors du déplacement / fermeture d'un onglet
		animation = true,

		-- Fermeture automatique de barbar si un seul buffer est ouvert
		auto_hide = false,

		-- Affichage du numéro de buffer dans l'onglet
		-- 'both' = numéro absolu + numéro relatif
		-- false = désactivé
		icons = {
			buffer_index = false, -- numéro de buffer (utile pour les raccourcis)
			buffer_number = true,
			button = "", -- icône du bouton de fermeture
			-- Indicateurs de diagnostic LSP dans chaque onglet
			diagnostics = {
				{ enabled = true, icon = "●" }, -- Error
				{ enabled = true, icon = "●" }, -- Warn
				{ enabled = false }, -- Info  (désactivé)
				{ enabled = false }, -- Hint  (désactivé)
			},
			gitsigns = {
				added = { enabled = true, icon = "+" },
				changed = { enabled = true, icon = "~" },
				deleted = { enabled = true, icon = "-" },
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
				text = "  Explorateur",
			},
		},
	},
}
