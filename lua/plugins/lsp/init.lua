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
      -- Récupération des capabilities propres à NvCrafted 
      local capabilities = require("core.lsp.capabilities").capabilities
      local on_attach = require("core.lsp.on_attach").on_attach

      -- Parcours de chaque serveur déclaré pour qu'il reconnaisse les mappings (on_attach) et les capabilities
      for _, server in pairs(servers) do
        local opts = {
            on_attach = on_attach,
            capabilities = capabilities,
        }

        -- Tentative de chargement d'une configuration spécifique
        -- située dans : lua/plugins/lsp/config/<server_name>.lua
        local ok, server_opts_overlay =
          pcall(require, "plugins.lsp.config." .. server)

        -- Si une surcouche existe, on fusionne ses options
        -- avec les options par défaut
        if ok and type(server_opts_overlay) == "table" then
          opts = vim.tbl_deep_extend("force", opts, server_opts_overlay)
        end

        -- Initialisation du serveur LSP
        vim.lsp.config(server, opts)
      end
    end,
  },
}

