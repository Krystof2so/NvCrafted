-- *******************************************************
-- * lua/plugins/lsp/config/lua_ls.lua                   *
-- *                                                     *
-- * Surcouche lua_ls pour NvCrafted :                   *
-- * - édition de fichiers config Neovim ET scripts Lua  *
-- * - LuaJIT (Lua 5.1 + extensions) est la cible Neovim *
-- * - Lua 5.4 pour les scripts                          *
-- *******************************************************

return {
	settings = {
		Lua = {
			-- ================================================================
			-- Runtime : LuaJIT comme cible principale (Neovim)
			-- lua_ls cible Lua 5.4 par défaut → faux positifs sans cette ligne
			-- ================================================================
			runtime = { version = "LuaJIT" },
			-- =========
			-- workspace
			-- =========
			workspace = {
				checkThirdParty = false, -- Evite des popups intrusifs
				-- borne l'indexation pour éviter de scanner l'intégralité du runtimepath Neovim
				maxPreload = 5000,
				preloadFileSize = 500,
			},
			-- ===========
			-- Diagnostics
			-- ===========
			diagnostics = {
				-- Pour que le serveur de langage reconnaisse certaines variables globales 
				globals = { "vim", "Snacks" },
				unusedLocalExclude = { "_*" }, -- exclut les variables préfixées _ (convention)
				disable = {}, -- rien de désactivé (tout voir)
			},
			-- ================================================================
			-- Complétion
			-- callSnippet = "Replace" : insère la signature complète d'une
			-- fonction avec ses paramètres lors de la complétion, plutôt que
			-- juste le nom — particulièrement utile pour l'API Neovim
			-- ================================================================
			completion = { callSnippet = "Replace" },
			-- ================================================================
			-- Format
			-- Désactivé : stylua via conform.nvim est le formateur déclaré.
			-- pour éviter un conflit potentiel.
			-- ================================================================
			format = { enable = false },
			-- ================================================================
			-- Télémétrie
			-- lua_ls envoie des données d'usage par défaut.
			-- ================================================================
			telemetry = { enable = false },
		},
	},
}
