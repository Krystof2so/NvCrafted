-- ************************************************************************************
-- * lua/plugins/coding/lazydev.lua                                                   *
-- *                                                                                  *
-- * Lazydev configure intelligemment lua_ls pour l'édition des fichiers Lua de      *
-- * configuration Neovim. Contrairement à neodev.nvim, il ne précharge que les      *
-- * modules effectivement requis dans les fichiers ouverts — ce qui accélère         *
-- * significativement la complétion.                                                 *
-- ************************************************************************************

return {
	"folke/lazydev.nvim",
	ft = "lua", -- chargement uniquement pour les fichiers Lua
	opts = {
		library = {
			-- Charge les types de vim.uv uniquement quand le mot-clé "vim.uv" apparaît
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},
}
