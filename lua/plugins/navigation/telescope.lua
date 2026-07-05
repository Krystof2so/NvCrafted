-- TODO: version + configuration

return {
	"nvim-telescope/telescope.nvim",
	tag = "v0.2.2", -- Vérifier la dernière version stable : https://github.com/nvim-telescope/telescope.nvim/tags
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- optionnel mais recommandé
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	opts = { -- cf. :h telescope.setup()
		-- Configuration par défaut de Telescope
		defaults = {
			sorting_strategy = "ascending", -- Affichage des entrées de haut en bas
			selection_strategy = "reset", -- Le curseur revient toujours sur le premier résultat de la liste filtrée
			layout_config = {
				prompt_position = "top",
			},
			prompt_prefix = "  > ",
			selection_caret = "  ", -- Entrée sélectionnée
			entry_prefix = "- ",
			-- Formate le chemin comme "fichier.txt (chemin/vers/fichier)" moins '/home/user'
			path_display = function(_, path)
				local home = vim.env.HOME
				if home then
					path = path:gsub("^" .. vim.pesc(home) .. "/", "")
				end
				local tail = require("telescope.utils").path_tail(path)
				return string.format("%s (%s)", tail, path)
			end,
			hl_result_eol = false, -- Détermine la longueur de la surbrillance de l'élément sélectionné
			results_title = "Résultats",
            prompt_title = "Rechercher",
            preview_title = "Aperçu du fichier",
            mappings = {
                i = {
                    ["<esc>"] = require('telescope.actions').close,
                },
            },
		},
		-- Configuration par défaut pour les sélecteurs intégrés
		pickers = {},
		-- Configuration des extensions (cf. les README des extensions)
		extensions = {},
	},
}
