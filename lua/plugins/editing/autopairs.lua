-- ****************************************************
-- * GitHub: https://github.com/windwp/nvim-autopairs *
-- *                                                  *
-- * Plugin qui insère et gère automatiquement les    *
-- * paires de caractères pendant la saisie.          *
-- ****************************************************

return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = { -- A noter que la configuration par défaut est largement suffisante
			check_ts = true, -- Activation de Tree-sitter pour un auto-pairing contextuel
			-- Table de configuration Tree-sitter par langage (à faire évoluer selon les besoins repérés)
			ts_config = {
				lua = { "string" }, -- désactive l’auto-pairing dans les strings Lua
			},
		},
	},
}
