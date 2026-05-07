-- *****************************************************************
-- * lua/plugins/coding/todo_comments.lua                          *
-- * Github: https://github.com/folke/todo-comments.nvim/tree/main *
-- *                                                               *
-- * Permet de mettre en évidence et de rechercher dans la base de *
-- * code les commentaires de type `TODO`, `HACK` ou `BUG`.        *
-- *****************************************************************

return {
	{
		"folke/todo-comments.nvim",
		event = "VimEnter", -- A l'ouverture de Neovim
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		-- TODO: higlight adaptatif (selon thème courant) => déléguer
	},
}
