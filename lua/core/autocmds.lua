-- ****************************************************************
-- * lua/core/autocmds.lua                                        *
-- * Auto-commandes globales de NvCrafted                         *
-- *                                                              *
-- * Ce fichier définit les comportements automatiques            *
-- * fondamentaux de Neovim, indépendants des plugins.            *
-- *                                                              *
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
		-- guard clause : si pour un message de commit ou buffer non reconnu
		local ft = vim.bo.filetype
		if ft == "gitcommit" or ft == "" then
			return
		end
		-- Valable pour tous les autres types de fichiers.
		local mark = api.nvim_buf_get_mark(0, '"')
		local line_count = api.nvim_buf_line_count(0)
		-- Vérifie que la position enregistrée est valide
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Ouvre les buffers d'aide en split vertical à droite
api.nvim_create_autocmd("FileType", {
	group = general_group,
	pattern = "help", -- Spécifique aux buffers d'aide
	callback = function()
		vim.cmd("wincmd L") -- déplace le split en vertical à droite
		vim.api.nvim_win_set_width(0, 85) -- largeur fixe, lisible sans être envahissante
	end,
})

-- Neutralise le _highlighter_ natif (cf. 'docs/architecture')
api.nvim_create_autocmd("FileType", {
	group = general_group,
	pattern = "markdown",
	callback = function(args)
		vim.treesitter.stop(args.buf)
	end,
})

-- Mise en évidence du texte copié (feedback visuel après un yank)
api.nvim_create_autocmd("TextYankPost", {
	group = general_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
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
		if vim.bo.buftype ~= "" then -- guard clause
			-- buffers spéciaux qui n'ont pas de folder (Trouble, Alpha...)
			return
		end
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

-- ===============================================================
-- = GROUPE : ui_group
-- ===============================================================
local ui_group = api.nvim_create_augroup("NvCraftedUI", { clear = true })

-- Redimensionnement des splits à la redimension du terminal
api.nvim_create_autocmd("VimResized", {
	group = ui_group,
	pattern = "*",
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Fermeture rapide des buffers utilitaires ('q' au lieu de ':q')
api.nvim_create_autocmd("FileType", {
	group = ui_group,
	pattern = { "man", "qf", "lspinfo", "checkhealth", "help*" },
	callback = function()
		vim.keymap.set("n", "q", "<cmd>close<CR>", {
			buffer = true,
			silent = true,
			desc = "Fermer le buffer utilitaire",
		})
	end,
})

-- =================================================================
-- = GROUPE : number_group
-- =================================================================
local number_group = api.nvim_create_augroup("NvCraftedNumber", { clear = true })

-- Désactivation de relativenumber dans les buffers en mode InsertEnter
api.nvim_create_autocmd("InsertEnter", {
	group = number_group,
	pattern = "*",
	callback = function()
		if vim.wo.relativenumber then
			vim.wo.relativenumber = false
		end
	end,
})

-- Désactivation de relativenumber dans les buffers en mode InsertLeave
api.nvim_create_autocmd("InsertLeave", {
	group = number_group,
	pattern = "*",
	callback = function()
		if vim.wo.number then
			vim.wo.relativenumber = true
		end
	end,
})
