-- *************************************************************
-- * lua/plugins/ui/zen_mode.lua                               *
-- *                                                           *
-- * Mode zen : fenêtre flottante plein écran sans distraction *
-- * - Twilight intégré : estompe le code hors du bloc courant *
-- * - Intégration WezTerm : augmentation de police en mode zen *
-- * - Numéros de ligne absolus et relatifs conservés          *
-- *************************************************************

return {
	"folke/zen-mode.nvim",
	cmd = "ZenMode", -- chargement paresseux : uniquement à l'appel de la commande
	dependencies = {
		"folke/twilight.nvim", -- estompe le code hors du bloc courant
	},
	opts = {
		window = {
			backdrop = 0.92, -- légère transparence du fond
			width = 120, -- largeur fixe de la fenêtre zen (en colonnes)
			height = 1, -- hauteur maximale (1 = 100% de la hauteur de l'éditeur)
			options = {
				number = true, -- numéros de ligne conservés
				relativenumber = true, -- numéros relatifs conservés
				signcolumn = "no", -- colonne des signes masquée (moins de bruit visuel)
				foldcolumn = "0", -- colonne de folding masquée
			},
		},
		plugins = {
			options = {
				enabled = true,
				showcmd = false, -- masque la commande en cours
				laststatus = 0, -- masque la statusline (lualine) en mode zen
			},
			twilight = { enabled = false }, -- Désactivation car géré par 'on_open'
			gitsigns = { enabled = false }, -- gitsigns masqué en mode zen
			wezterm = {
				enabled = true,
				font = "+2", -- +2 pas incrémentation ≈ +20% (chaque pas = ~10%)
			},
		},
		on_open = function(_)
            local ft = vim.bo.filetype  -- Récupère le type du fichier ("" si pas de type)
            if ft == "" then return end
            -- Vérifie que le parser Tree-sitter existe pour ce filetype
			local ok = pcall(vim.treesitter.language.inspect, ft)
			if ok then
				require("twilight").enable()
			end
		end,
		on_close = function()
            pcall(function()
                require("twilight").disable()
            end)
		end,
	},
}
