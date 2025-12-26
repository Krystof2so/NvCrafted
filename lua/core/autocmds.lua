-- ****************************************************************
-- * lua/core/autocmds.lua                                        *
-- * Auto-commandes globales de NvCrafted                         *
-- *                                                              *
-- * Ce fichier définit les comportements automatiques            *
-- * fondamentaux de Neovim, indépendants des plugins.            *
-- *                                                             *
-- * Principe :                                                   *
-- * - une règle = une intention claire                           *
-- * - un groupe = une responsabilité                             *
-- ****************************************************************

local api = vim.api

-- ================================================================
-- = GROUPE : Général (socle NvCrafted)
-- ================================================================
local general_group = api.nvim_create_augroup("NvCraftedGeneral", { clear = true })

-- Restaurer la position du curseur à la réouverture d’un fichier
api.nvim_create_autocmd("BufReadPost", {
  group = general_group,
  pattern = "*",
  callback = function()
    local mark = api.nvim_buf_get_mark(0, '"')
    local line_count = api.nvim_buf_line_count(0)
    -- Vérifie que la position enregistrée est valide
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ================================================================
-- = GROUPE : Folding
-- ================================================================
local fold_group = api.nvim_create_augroup("NvCraftedFolding", { clear = true })

-- Ouvre tous les folds à l’entrée d’un buffer dans une fenêtre
-- Garantit une lecture initiale non repliée
-- Le folding reste ensuite entièrement manuel
api.nvim_create_autocmd("BufWinEnter", {
  group = fold_group,
  pattern = "*",
  callback = function()
    -- normal! : ignore les mappings utilisateur
    vim.cmd("normal! zR")
  end,
})

-- ================================================================
-- = GROUPE : Orthographe (activation contextuelle minimale)
-- ================================================================
local spell_group = api.nvim_create_augroup("NvCraftedSpell", { clear = true })

-- Active le spellcheck uniquement pour les fichiers rédactionnels
-- La logique avancée (dictionnaires, SpellGood, etc.)
-- est volontairement déléguée à core.spell.lua
api.nvim_create_autocmd("FileType", {
  group = spell_group,
  pattern = { "markdown", "text", "rst" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

