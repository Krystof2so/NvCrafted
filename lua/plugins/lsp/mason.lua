-- ****************************************************************
-- * lua/plugins/lsp/mason.lua                                    *
-- *                                                              *
-- * Configuration de Mason et Mason-lspconfig.                   *
-- * Mason est responsable de l'installation des binaires LSP.    *
-- * Mason-lspconfig fait le lien entre les serveurs déclarés     *
-- * dans NvCrafted et leur présence effective sur le système.    *
-- * Mason se contente d'installer les serveurs déclarés dans     *
-- * servers.lua.                                                 *
-- ****************************************************************

return {
  -- Mason principal
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed   = "✓",
          package_pending     = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Pont Mason ↔ nvim-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- Liste des serveurs LSP à installer automatiquement.
      -- Elle est dérivée directement de la source de vérité
      ensure_installed = require("core.lsp.servers")
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      -- Installation d'outils complémentaires (linter, formatter, etc.), via mason-tool-installer 
      -- (facultatif mais pratique)
      ensure_installed = require("core.lsp.tools")
    },
    auto_update = true,
  },
}
