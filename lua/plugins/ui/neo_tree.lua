-- **********************************************************
-- * GitHub: https://github.com/nvim-neo-tree/neo-tree.nvim *
-- *                                                        *
-- * Neo-tree est un plugin Neovim qui permet de parcourir  *
-- * le système de fichiers et d'autres structures          *
-- * arborescentes.                                         *
-- *                                                        *
-- * Pour une liste des commandes utilisables : ?           *
-- * Lancer Neo-tree: :Neotree                              *
-- * Liste des buffers ouverts: :Neotree buffers            *
-- **********************************************************

return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Permet l'analyse du système de fichiers
			"MunifTanjim/nui.nvim", -- Composants de l'interface utilisateur
			"nvim-tree/nvim-web-devicons", -- Icônes de fichiers
		},
		lazy = false, -- Chargement différé
		config = function()
			-- Configuration du popup
			require("neo-tree").setup({
				enable_git_status = true, -- Active l'affichage du statut Git
				enable_diagnostics = true, -- Active l'affichage des diagnostics (erreurs, avertissements, etc.)
				open_files_using_relative_paths = true, -- utilise les chemins relatifs pour ouvrir les fichiers
				window = {
					position = "left",
					width = 30,
					mappings = {
						["P"] = {
							"toggle_preview",
							config = {
								use_float = true, -- Active la fenêtre flottante pour la prévisualisation
								use_snacks_image = false,
								use_image_nvim = false,
							},
						},
					},
				},
				filesystem = {
					filtered_items = {
						hide_dotfiles = false, -- cacher les fichiers/dossiers commençant par un point
						hide_gitignored = false, -- cacher les fichiers ignorés par Git
						hide_ignored = false, -- cacher les fichiers ignorés par d'autres fichiers similaires à .gitignore
					},
				},
				popup = {
					position = "center", -- Position centrale pour un effet flottant
					size = {
						width = 50,
						height = 15,
					},
					border = {
						style = "rounded",
						text = {
							top = " Preview ",
							top_align = "center",
						},
						padding = { 0, 0, 0, 0 }, -- Padding pour la bordure
					},
					title = true, -- Affiche une barre de titre
					highlight = "NeoTreeFloatNormal", -- fond du popup reprend la couleur normale
					border_highlight = "NeoTreeFloatBorder", -- bordure reprend le style des floats du thème
				},
				popup_border_style = "NC", -- Style de bordure "NC" pour un rendu moderne
				use_libuv_file_watcher = true, -- Rafraîchissement automatique de NeoTree
			})

			-- Définition manuelle des couleurs
			local hl = vim.api.nvim_set_hl
			hl(0, "NeoTreeFloatNormal", {
				bg = "#2E3440", -- Fond sombre (Nord1)
				fg = "#D8DEE9", -- Texte clair (Nord4)
			})
			hl(0, "NeoTreeFloatBorder", {
				bg = "#2E3440", -- Fond identique pour un rendu homogène
				fg = "#d08770", -- Orange (Nord12) pour la bordure
			})
			hl(0, "NeoTreeFloatTitle", {
				bg = "#3B4252", -- Fond légèrement plus clair (Nord2)
				fg = "#ECEFF4", -- Texte très clair (Nord6) pour le titre
				bold = true, -- Gras pour le titre
			})
			hl(0, "NeoTreeTitleBar", {
				bg = "#434C5E", -- Fond légèrement plus clair (Nord3)
				fg = "#81a1c1", -- Texte bleu
				bold = true, -- Gras pour le titre
			})
		end,
	},
}
