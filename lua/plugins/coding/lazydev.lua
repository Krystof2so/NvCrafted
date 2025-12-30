-- ************************************************************************************
-- * lua/plugins/coding/lazydev.lua                                                   *
-- *                                                                                  *
-- * Lazydev est un plugin plus moderne que Neodev.nvim qui améliore l'expérience LSP *
-- * Lua, spécialement pour éditer des fichiers de configuration Neovim ou des        *
-- * plugins Lua.                                                                     *
-- *                                                                                  *
-- * Intégration de lazydev.nvim pour enrichir la complétion Lua dans NvCrafted.      *
-- * - Complétion Lua rapide et pertinente pour l’édition des fichiers NvCrafted.     *
-- * - Intégration avec blink.cmp.                                                    *
-- * - Chargement paresseux : ce plugin ne s’active que pour les fichiers Lua.        *
-- * - Modularité : seules les librairies réellement utilisées sont prises en compte, *
-- *   incluant le code core et les modules plugins de NvCrafted.                     *
-- ************************************************************************************

return {
  "folke/lazydev.nvim",
  ft = "lua",  -- ne se charge que pour les fichiers Lua (Réduction consommation mémoire et temps de démarrage)
  opts = {
    library = {
      -- Charger les modules utilisés dans NvCrafted pour enrichir l'auto-complétion 
      "lazy.nvim",                  -- gestionnaire de plugins
      "core",                       -- dossier core de NvCrafted
      "plugins",                    -- tous les plugins NvCrafted
      -- Auto-complétion et vérification de type pour vim.uv
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
    -- activation par défaut
    enabled = true
  },

  -- Intégration avec Blink pour la complétion (chargé avant lazydev)
  dependencies = {
    "saghen/blink.cmp",
  },

  config = function(_, opts)
    -- Initialisation de lazydev
    require("lazydev").setup(opts)

    -- Ajouter Lazydev à Blink comme source prioritaire
    local blink = require("blink.cmp")
    blink.setup({
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,  -- Prioriser Lazydev
          },
        },
      },
    })
  end,
}

