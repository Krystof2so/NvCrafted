-- ************************************************************
-- * lua/plugins/editing/render-markdown.lua                  *
-- *                                                          *
-- * Rendu Markdown enrichi directement dans les buffers      *
-- * Neovim. S'active automatiquement sur filetype=markdown.  *
-- *                                                          *
-- * GitHub : https://github.com/MeanderingProgrammer/render-markdown.nvim *
-- ************************************************************

return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown" }, -- chargement uniquement pour les fichiers Markdown
  opts = {
    -- Titres : icône + couleur par niveau
    heading = {
      enabled = true,
      icons   = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    -- Blocs de code : fond coloré
    code = {
      enabled = true,
      style   = "full", -- "full" = fond + langage, "normal" = fond seul
    },
    -- Listes à puces : icônes personnalisées
    bullet = {
      enabled = true,
      icons   = { "●", "○", "◆", "◇" },
    },
    -- Cases à cocher pour les listes de tâches
    checkbox = {
      enabled   = true,
      unchecked = { icon = "󰄱 " },
      checked   = { icon = "󰱒 " },
    },
    -- Tableaux : bordures Unicode
    pipe_table = {
      enabled = true,
      style   = "full",
    },
    -- Liens : icône devant les URLs
    link = {
      enabled    = true,
      hyperlink  = "󰌹 ",
      image      = "󰥶 ",
    },
  },
}
