-- ********************************************************************************
-- * core/spell.lua                                                               *
-- *                                                                              *
-- * Spellcheck pour NvCrafted : COMMENT fonctionne l'orthographe.                *
-- * Le QUAND (quels filetypes) est décidé dans core/autocmds.lua (groupe         *
-- * NvCraftedSpell), qui appelle require("core.spell").enable_buffer().          *
-- *                                                                              *
-- * - dictionnaires : en, fr, code                                               *
-- * - dictionnaire code créé et compilé automatiquement dès le premier démarrage *
-- * - ajout automatique des mots validés                                         *
-- * - portée locale (vim.opt_local) : jamais de contamination globale            *
-- * - dans les fichiers de code, Tree-sitter (capture @spell) limite la          *
-- *   vérification aux commentaires et aux strings                               *
-- *                                                                              *
-- * Cf. //neovim.io/doc/user/spell.html                                          *
-- ********************************************************************************

local M = {}

local spell_dir = vim.fn.stdpath("data") .. "/spell"
local code_add = spell_dir .. "/code.utf-8.add"
local code_spl = spell_dir .. "/code.utf-8.spl"

-- ================================================================
-- = 1. Préparation des dictionnaires (exécutée au chargement)    =
-- ================================================================

-- Crée le dossier spell s'il n'existe pas
if vim.fn.isdirectory(spell_dir) == 0 then
	vim.fn.mkdir(spell_dir, "p")
end

-- Crée le fichier code.utf-8.add s'il n'existe pas et compile le .spl
if vim.fn.filereadable(code_add) == 0 then
	vim.fn.writefile({ "NvCrafted" }, code_add)
	-- Compile immédiatement le .spl localement
	vim.cmd(string.format("silent! mkspell! %s", code_add))
end

-- ================================================================
-- = 2. Activation pour le buffer courant                         =
-- ================================================================

--- Active et configure la correction orthographique pour le buffer courant.
--- Appelée depuis core/autocmds.lua (qui décide QUAND l'appeler).
--- vim.opt_local = :setlocal → n'affecte ni la valeur globale,
--- ni les autres buffers/fenêtres.
function M.enable_buffer()
	local langs = { "en", "fr" }
	if vim.fn.filereadable(code_spl) == 1 then
		table.insert(langs, "code")
	end

	vim.opt_local.spell = true
	vim.opt_local.spelllang = langs
	vim.opt_local.spellfile = code_add -- indique explicitement le fichier .add pour 'code'
end

-- ================================================================
-- = 3. Ajout automatique des mots validés                        =
-- ================================================================
-- FIX : Gestion de l'évènement SpellGood
-- (à ma connaissance, 'zg' ne déclenche pas d'évènement User SpellGood :
--  cet autocmd ne s'exécute probablement jamais — à vérifier, cf. :h zg)
vim.api.nvim_create_autocmd("User", {
	pattern = "SpellGood",
	callback = function()
		local w = vim.fn.expand("<cword>")
		local add_file = code_add
		local lines = vim.fn.readfile(add_file)
		local exists = false
		for _, line in ipairs(lines) do
			if line == w then
				exists = true
				break
			end
		end
		if not exists then
			vim.fn.writefile({ w }, add_file, "a")
			-- recompile le .spl localement
			vim.cmd(string.format("silent! mkspell! %s", add_file))
		end
	end,
})

return M
