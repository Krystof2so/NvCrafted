-- **********************************************************
-- * GitHub: https://github.com/nvim-neo-tree/neo-tree.nvim *
-- *                                                        *
-- * Neo-tree est un plugin Neovim qui permet de parcourir  *
-- * le système de fichiers et d'autres structures          * 
-- * arborescentes.                                         *
-- *                                                        *
-- * Pour une liste des commandes utilisables : ?           *
-- * Lancer Neo-tree: :Neotree                              *
-- * Liste des buffers ouverts: :Neotree buffers            *
-- **********************************************************

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",       -- Permet l'analyse du système de fichiers
      "MunifTanjim/nui.nvim",        -- Composants de l'interface utilisateur
      "nvim-tree/nvim-web-devicons", -- Icônes de fichiers
    },
    lazy = false, -- Chargement différé
    config = function()
      -- Configuration du popup
      require("neo-tree").setup({
        window = {
          position = "left",
          width = 30,
        },
        popup = {
          position = "center",
          size = {
            width = 40,
            height = 10,
          },
          border = "rounded",
          title = true,
          highlight = "Normal",         -- fond du popup reprend la couleur normale
          border_highlight = "FloatBorder", -- bordure reprend le style des floats du thème
        },
      })

      -- Définition manuelle des couleurs
      local hl = vim.api.nvim_set_hl

      -- Fond principal du popup
      hl(0, "NeoTreeFloatNormal", { bg = "#3b4252", fg = "#d8dee9" })
      -- Bordure du popup
      hl(0, "NeoTreeFloatBorder", { bg = "#3b4252", fg = "#d08770" })
      -- Barre de titre du popup
      hl(0, "NeoTreeFloatTitle", { bg = "#434c5e", fg = "#d8dee9", bold = true })
    end,
  }
}
