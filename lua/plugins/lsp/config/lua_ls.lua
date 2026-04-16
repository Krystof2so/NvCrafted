return {
	-- Pour utiliser le wrapper si le binaire de Mason est incompatible avec celui de Binutils pour Debian/testing
	-- (Penser à supprimer lua_ls de la table des LSP dans lsp/init.:
	-- cmd = { vim.fn.expand("~/.local/bin/lua-language-server-wrapper") },
	settings = {
		Lua = {
			workspace = {
				checkThirdParty = false,
			},
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
}
