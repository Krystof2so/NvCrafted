-- *****************************************************************
-- * lua/plugins/git/diffview.lua                                  *
-- *                                                               *
-- * diffview.nvim : interface simple, unifiée, sur un seul onglet *
-- * qui permet de passer en revue facilement tous les fichiers    *
-- * modifiés pour n'importe quelle révision Git.                  *
-- *                                                               *
-- *                                                               *
-- * GitHub : https://github.com/sindrets/diffview.nvim/tree/main  *
-- *****************************************************************

return {
	"sindrets/diffview.nvim",
	-- Chargement différé : uniquement quand un buffer est ouvert
	event = "BufReadPre",

	-- Options statiques :
	opts = {
		-- Personnalisation de l'interface
		diff_binaries = false, -- Désactive l'utilisation de git/diff externe (diffs plus rapides)
		enhanced_diff_hl = true, -- Surbrillance améliorée des diffs
		git_cmd = { "git" }, -- Commande Git à utiliser

		-- Comportement par défaut
		default_args = {
			DiffviewOpen = {}, -- Ouverture par défaut sur MAIN
			DiffviewFileHistory = { "%" }, -- Historique du fichier courant
		},

		-- Personnalisation du panneau des fichiers
		-- Icônes (compatibilité avec nerdfonts)
		icons = {
			folder_closed = "",
			folder_open = "",
			folder_empty = "",
		},
		-- Signes folders
		signs = {
			fold_closed = "",
			fold_open = "",
			fold_closed_line = "",
			fold_open_line = "",
		},
		use_icons = true, -- Utilise les icônes pour les types de fichiers
		show_untracked = true, -- Affiche les fichiers non suivis

		-- Performances
		watch_index = true, -- Met à jour automatiquement quand l'index change
		follow_files = true, -- Suit les fichiers renommés

		-- Fenêtre de prévisualisation
		file_panel = {
			win_config = {
				position = "right", -- Position du panneau des fichiers
				width = 30, -- Largeur du panneau
				min_width = 15, -- Largeur minimale
			},
		},
	},
}
