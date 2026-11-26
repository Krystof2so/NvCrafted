-- *******************************************************************************
-- * lua/plugins/lsp/init.lua                                                    *
-- *                                                                             *
-- * Point d'entrée principal de la gestion des LSP dans NvCrafted.              *
-- * Responsabilités de ce fichier :                                             *
-- * - parcourir les serveurs LSP déclarés                                       *
-- * - charger dynamiquement leurs surcouches de configuration si elles existent *
-- * - initialiser chaque serveur via nvim-lspconfig                             *
-- * Ce fichier ne contient *aucune configuration spécifique* à un serveur, il   *
-- * se contente d'orchestrer proprement l'ensemble.                             *
-- *******************************************************************************
-- FIX: Le fichier applique on_attach et capabilities deux fois,
-- ce qui déclenche les mappings en double et appelle highlights.setup()
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Mason-lspconfig assure la cohérence entre les serveurs déclarés
			-- et leur installation effective via Mason.
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local servers = require("core.lsp.servers")

			-- 1. Socle commune : Configuration définie une seule fois pour tous les serveurs LSP
			vim.lsp.config("*", {
				capabilities = require("core.lsp.capabilities").get(),
				on_attach = require("core.lsp.on_attach").on_attach,
			})

			-- 2. Surcouches optionnelles : uniquement ce qui diffère du socle commun
			for _, server in pairs(servers) do
				local ok, overlay = pcall(require, "plugins.lsp.config." .. server)
				if ok and type(overlay) == "table" then
					vim.lsp.config(server, overlay)
				end
			end

			-- 3. Activation (accepte directement une liste)
			vim.lsp.enable(servers)

			-- 4. Réglage global, hors de la boucle
			vim.lsp.log.set_level("error")
		end,
	},
}
