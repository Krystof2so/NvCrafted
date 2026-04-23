-- ************************************************************************
-- * GitHub: https://github.com/nvim-treesitter/nvim-treesitter/tree/main *
-- *                                                                      *
-- * Tree-sitter analyse le code via un arbre syntaxique pour fournir une *
-- * coloration syntaxique, l'indentation fiable et éventuellement un     *
-- * folding.                                                             *
-- ************************************************************************

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		event = { "BufReadPost", "BufNewFile" }, -- charger après l'ouverture du buffer
		build = ":TSUpdate", -- installe et met à jour les parsers
		config = function()
			local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
			if not ok then
				return
			end -- si plugin pas disponible

			ts_configs.setup({
				ensure_installed = {
					"lua",
					"python",
					"rust",
					"toml",
					"html",
					"css",
					"json",
					"vim", -- utile aussi pour la cmdline Vim
					"regex", -- pour Noice : coloration des patterns de recherche
					"bash", -- pour Noice : coloration des commandes shell
					-- markdown et markdown_inline gérés nativement
					-- par Neovim 0.12 — exclus de nvim-treesitter
					-- pour éviter le conflit de highlighter
				},
				sync_install = false,
				ignore_install = {
					"markdown", -- géré nativement par Neovim 0.12
					"markdown_inline", -- idem
				},
				modules = {},
				highlight = {
					enable = true,
					disable = { "markdown", "markdown_inline" }, -- sécurité supplémentaire
				},
				indent = { enable = true },
				auto_install = true, -- Pour les langages non listés dans ensure_installed
			})
		end,
	},
}
