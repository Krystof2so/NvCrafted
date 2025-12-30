-- *************************************************
-- * ui/trouble.lua                                *
-- *                                               *
-- * Panneau centralisé pour diagnostics LSP      *
-- * Transforme les diagnostics en outil navigable*
-- *************************************************

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- icônes recommandées
  cmd = "Trouble", -- lazy-load : le plugin ne se charge que si nécessaire

  opts = {
    mode = "document_diagnostic",  -- Mode par défaut
    auto_close = true,               -- Ferme automatiquement Trouble lorsqu'il n'y a plus d'éléments
    group = true,                    -- Grouper les diagnostics par fichier
    sort = { "severity", "filename", "pos" }, -- Tri : Error > Warning > Info > Hint
    use_diagnostic_signs = false,    -- Utilise vim.diagnostic (LSP natif)

    -- Configuration des modes
    modes = {
      preview_split = { -- nom du mode, tu peux l'utiliser dans mappings
        mode = "diagnostics",
        preview = {
          type = "split",     -- type split, pas floating
          relative = "win",   -- relatif à la fenêtre Trouble
          position = "right", -- split à droite
          size = 0.3,         -- fraction de la largeur de la fenêtre Trouble (30%)
        },
      },
    },
  },
}

