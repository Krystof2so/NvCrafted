-- ******************************************************************
-- * plugins/coding/conform.lua                                     *
-- *                                                                *
-- * Déclaration Lazy de conform.nvim.                              *
-- * La configuration réelle est déléguée à                         *
-- * core/format/conform.lua (convention spécification/déclaration) *
-- ******************************************************************
-- FIX: Retour de la configuration ???
return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		-- On utilise la configuration centralisée du module core.format.conform
		opts = function()
			require("core.format.conform").setup()
		end,
	},
}
