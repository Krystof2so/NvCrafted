-- ****************************************************************
-- * lua/core/autocmds.lua                                        *
-- * Auto commandes globales de NvCrafted                         *
-- * Ce fichier contient toutes les réactions automatiques        *
-- * aux événements Neovim (ouverture de buffer, insertion, etc.) *
-- ****************************************************************

local api = vim.api

-- Création d'un groupe d'auto commandes pour le folding
local fold_group = api.nvim_create_augroup("NvCraftedFolding", { clear = true })
-- À chaque fois qu'un buffer entre dans une fenêtre :
--  - on ouvre tous les folds (zR)
--  - cela garantit que les fichiers s'ouvrent toujours dépliés
--  - Tree-sitter reste actif pour le folding manuel ensuite
api.nvim_create_autocmd("BufWinEnter", {
  group = fold_group,
  pattern = "*",
  callback = function()
    -- normal! : exécute la commande sans tenir compte des mappings utilisateur
    vim.cmd("normal! zR")
  end,
})

