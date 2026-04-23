-- ********************************************************************************
-- * Spellcheck pour NvCrafted :                                                  *
-- * - dictionnaires : en, fr, code                                               *
-- * - dictionnaire code créé et compilé automatiquement dès le premier démarrage *
-- * - ajout automatique des mots validés                                         *
-- * - activé uniquement dans commentaires et strings                             *
-- * - Neo-tree compatible                                                        *
-- *                                                                              *
-- * Cf. //neovim.io/doc/user/spell.html                                          *
-- ********************************************************************************

local spell_dir = vim.fn.stdpath("data") .. "/spell"
local code_add = spell_dir .. "/code.utf-8.add"
local code_spl = spell_dir .. "/code.utf-8.spl"

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

-- Active le spellcheck par buffer
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	pattern = "*",
	callback = function()
		local langs = { "en", "fr" }
		if vim.fn.filereadable(code_spl) == 1 then
			table.insert(langs, "code")
		end

		vim.opt.spell = true
		vim.opt.spelllang = langs
		vim.opt.spellfile = code_add -- indique explicitement le fichier .add pour 'code'

		-- Différer les commandes syntax pour éviter le conflit Tree-sitter
		vim.schedule(function()
			pcall(function()
				vim.cmd("syntax spell toplevel NONE")
				vim.cmd("syntax spell default")
				vim.cmd("syn spell Comment")
				vim.cmd("syn spell String")
			end)
		end)
	end,
})

-- 5️⃣ Autocommand pour ajouter automatiquement les mots validés au dictionnaire code
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
