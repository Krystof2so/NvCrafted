-- *******************************************************************************
-- * init.lua                                                                    *
-- *                                                                             *
-- * Point d'entrée de NvCrafted :                                               *
-- * 1. Charge le bootstrap (vérification installation + installation lazy.nvim) *
-- * 2. Configure les providers, PATH, leader keys, etc.                         *
-- * 3. Charge les modules core (options, keymaps, autocmds, spell)              *
-- * 4. Initialise lazy.nvim avec la configuration des plugins                   *
-- *******************************************************************************

-- ======================================================================
-- 1. Bootstrap : Vérification de la version + installation de lazy.nvim
-- ======================================================================
require("core.bootstrap")

-- ========================================================
-- 2. Configuration de base (providers, PATH, leader keys)
-- ========================================================
-- Désactiver les providers inutiles
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
-- Python dédié Neovim
vim.g.python3_host_prog = vim.fn.expand("~/.venvs/neovim/bin/python")
-- Ajouter Mason au PATH pour que les binaires soient trouvables
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"
-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- ===================================================================
-- 3. Chargement des modules core (options, keymaps, autocmds, spell)
-- ===================================================================
require("core.spell")
require("core.options")
require("core.theme")
require("core.keymaps")
require("core.autocmds")

-- ========================================================
-- 4. setup de lazy.nvim avec la configuration des plugins
-- ========================================================
-- Lit la spec de lazy dans 'lua/plugins/init.lua'
require("lazy").setup("plugins")
