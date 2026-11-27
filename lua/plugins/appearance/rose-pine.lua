-- *************************************************************
-- * lua/plugins/themes/rose-pine.lua                          *
-- *                                                           *
-- * Rosé Pine — thème principal de NvCrafted                  *
-- * Trois variantes disponibles :                             *
-- *   - rose-pine       (main, sombre)                        *
-- *   - rose-pine-moon  (sombre, teintes plus froides)        *
-- *   - rose-pine-dawn  (clair)                               *
-- *                                                           *
-- * GitHub : https://github.com/rose-pine/neovim              *
-- *************************************************************

return {
	"rose-pine/neovim",
	name = "rose-pine",
	lazy = false,
	priority = 1000,
	config = function()
		require("rose-pine").setup({
			-- Variante par défaut quand le fond est sombre.
			-- "auto" suit vim.o.background ; on fixe "main" pour rester
			-- cohérent quel que soit l'environnement.
			variant = "auto",
			dark_variant = "main",

			dim_inactive_windows = false,
			extend_background_behind_borders = true,

			enable = {
				terminal = true,
				legacy_highlights = true,
				migrations = true,
			},

			styles = {
				bold = true,
				italic = true,
				transparency = false,
			},

			-- Sémantique des couleurs pour les groupes fonctionnels
			groups = {
				border = "muted",
				link = "iris",
				panel = "surface",

				-- Diagnostics — mappés sur la palette Rosé Pine
				error = "love", -- rouge doux
				hint = "iris", -- violet
				info = "foam", -- bleu-vert
				note = "pine", -- vert
				todo = "rose", -- rose
				warn = "gold", -- or

				-- Git
				git_add = "foam",
				git_change = "rose",
				git_delete = "love",
				git_dirty = "rose",
				git_ignore = "muted",
				git_merge = "iris",
				git_rename = "pine",
				git_stage = "iris",
				git_text = "rose",
				git_untracked = "subtle",

				-- Titres Markdown
				h1 = "iris",
				h2 = "foam",
				h3 = "rose",
				h4 = "gold",
				h5 = "pine",
				h6 = "foam",
			},
		})

		-- Application du colorscheme au démarrage.
		-- La variante est contrôlée par M.default dans core/theme.lua.
		-- Pour utiliser moon ou dawn, changer "rose-pine" par
		-- "rose-pine-moon" ou "rose-pine-dawn" dans les deux fichiers.
		vim.cmd.colorscheme("rose-pine-main")
	end,
}
