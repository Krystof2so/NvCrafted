-- =============================================================================
-- lua/nvcrafted/tutor/init.lua
-- Point d'entrée du module tutoriel de NvCrafted
-- =============================================================================

local M = {}

-- ---------------------------------------------------------------------------
-- Configuration par défaut
-- ---------------------------------------------------------------------------

M.config = {
	-- Répertoire contenant les fichiers de leçons Markdown
	lessons_dir = vim.fn.stdpath("config") .. "/tutor/lessons",
	-- Répertoire contenant la documentation
	docs_dir = vim.fn.stdpath("config") .. "/docs",
	-- Fichier JSON pour sauvegarder la progression
	progress_file = vim.fn.stdpath("data") .. "/nvcrafted_tutor_progress.json",
	-- Largeur de la fenêtre flottante (0 = plein écran / split)
	width = 90,
	-- Keymaps locaux au buffer tutoriel
	keymaps = {
		next_lesson = "]l",
		prev_lesson = "[l",
		hint = "gh",
		quit = "q",
		goto_lesson = "gl",
	},
}

-- ---------------------------------------------------------------------------
-- État interne (réinitialisé à chaque ouverture)
-- ---------------------------------------------------------------------------

local state = {
	buf = nil, -- buffer courant du tutoriel
	win = nil, -- fenêtre courante
	lesson_id = 1, -- index de la leçon affichée
	lessons = {}, -- liste ordonnée des fichiers de leçons trouvés
}

-- ---------------------------------------------------------------------------
-- Utilitaires
-- ---------------------------------------------------------------------------

--- Retourne true si le buffer tutoriel est encore valide et visible
local function is_open()
	return state.buf ~= nil
		and vim.api.nvim_buf_is_valid(state.buf)
		and state.win ~= nil
		and vim.api.nvim_win_is_valid(state.win)
end

--- Charge la liste des fichiers *.md dans lessons_dir, triés par nom
local function load_lesson_list()
	local dir = M.config.lessons_dir
	local files = vim.fn.glob(dir .. "/*.md", false, true) -- retourne une table

	if #files == 0 then
		vim.notify("[NvCrafted Tutor] Aucune leçon trouvée dans : " .. dir, vim.log.levels.WARN)
		return false
	end

	table.sort(files)
	state.lessons = files
	return true
end

--- Lit le contenu d'un fichier et retourne une table de lignes
local function read_file(path)
	local lines = {}
	local f = io.open(path, "r")
	if not f then
		return nil, "Impossible d'ouvrir : " .. path
	end
	for line in f:lines() do
		table.insert(lines, line)
	end
	f:close()
	return lines
end

-- ---------------------------------------------------------------------------
-- Rendu dans le buffer
-- ---------------------------------------------------------------------------

--- Injecte les lignes dans le buffer et applique les highlights de base
local function render_lesson(lesson_path)
	local lines, err = read_file(lesson_path)
	if not lines then
		vim.notify("[NvCrafted Tutor] " .. err, vim.log.levels.ERROR)
		return
	end

	-- Rend le buffer temporairement modifiable pour écrire dedans
	vim.bo[state.buf].modifiable = true
	vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
	vim.bo[state.buf].modifiable = false

	-- Barre de progression en bas (virtual text sur la dernière ligne)
	local ns = vim.api.nvim_create_namespace("nvcrafted_tutor")
	vim.api.nvim_buf_clear_namespace(state.buf, ns, 0, -1)

	local total = #state.lessons
	local current = state.lesson_id
	local bar_full = math.floor((current / total) * 20)
	local bar = string.rep("█", bar_full) .. string.rep("░", 20 - bar_full)
	local label = string.format(" Leçon %d/%d  [%s] ", current, total, bar)

	vim.api.nvim_buf_set_extmark(state.buf, ns, #lines - 1, 0, {
		virt_lines = { { { label, "Comment" } } },
		virt_lines_above = false,
	})

	-- Repositionne le curseur en haut
	vim.api.nvim_win_set_cursor(state.win, { 1, 0 })
end

-- ---------------------------------------------------------------------------
-- Navigation entre leçons
-- ---------------------------------------------------------------------------

function M.next_lesson()
	if state.lesson_id < #state.lessons then
		state.lesson_id = state.lesson_id + 1
		render_lesson(state.lessons[state.lesson_id])
		require("nvcrafted.tutor.progress").save(state.lesson_id)
	else
		vim.notify("[NvCrafted Tutor] Vous avez terminé toutes les leçons ! 🎉", vim.log.levels.INFO)
	end
end

function M.prev_lesson()
	if state.lesson_id > 1 then
		state.lesson_id = state.lesson_id - 1
		render_lesson(state.lessons[state.lesson_id])
	end
end

--- Ouvre un sélecteur pour sauter directement à une leçon
function M.goto_lesson()
	local items = {}
	for i, path in ipairs(state.lessons) do
		table.insert(items, string.format("%d. %s", i, vim.fn.fnamemodify(path, ":t:r")))
	end

	vim.ui.select(items, { prompt = "Aller à la leçon :" }, function(choice, idx)
		if idx then
			state.lesson_id = idx
			render_lesson(state.lessons[idx])
		end
	end)
end

--- Affiche un hint (pour l'instant : ligne de tip en bas)
function M.show_hint()
	vim.notify(
		"[NvCrafted Tutor] Hint : lis attentivement les instructions et essaie la commande indiquée.",
		vim.log.levels.INFO
	)
end

-- ---------------------------------------------------------------------------
-- Keymaps locaux au buffer tutoriel
-- ---------------------------------------------------------------------------

local function setup_keymaps()
	local km = M.config.keymaps
	local buf = state.buf
	local opts = { buffer = buf, noremap = true, silent = true }

	vim.keymap.set("n", km.next_lesson, M.next_lesson, vim.tbl_extend("force", opts, { desc = "Leçon suivante" }))
	vim.keymap.set("n", km.prev_lesson, M.prev_lesson, vim.tbl_extend("force", opts, { desc = "Leçon précédente" }))
	vim.keymap.set("n", km.hint, M.show_hint, vim.tbl_extend("force", opts, { desc = "Afficher un hint" }))
	vim.keymap.set("n", km.goto_lesson, M.goto_lesson, vim.tbl_extend("force", opts, { desc = "Aller à une leçon" }))
	vim.keymap.set("n", km.quit, M.close, vim.tbl_extend("force", opts, { desc = "Fermer le tutoriel" }))
end

-- ---------------------------------------------------------------------------
-- Ouverture / fermeture
-- ---------------------------------------------------------------------------

--- Ouvre le tutoriel dans un nouveau split vertical
function M.open()
	-- Si déjà ouvert, remet le focus dessus
	if is_open() then
		vim.api.nvim_set_current_win(state.win)
		return
	end

	-- Charge la liste des leçons
	if not load_lesson_list() then
		return
	end

	-- Reprend la progression sauvegardée si disponible
	local saved = require("nvcrafted.tutor.progress").load()
	state.lesson_id = saved or 1

	-- Crée le buffer
	state.buf = vim.api.nvim_create_buf(false, true) -- unlisted, scratch
	vim.bo[state.buf].buftype = "nofile"
	vim.bo[state.buf].bufhidden = "wipe"
	vim.bo[state.buf].swapfile = false
	vim.bo[state.buf].filetype = "markdown"
	vim.api.nvim_buf_set_name(state.buf, "NvCrafted Tutor")

	-- Ouvre dans un split vertical à droite de la largeur configurée
	vim.cmd("botright vsplit")
	state.win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(state.win, state.buf)
	vim.api.nvim_win_set_width(state.win, M.config.width)

	-- Options de la fenêtre (pas de numéros de ligne, wrap, etc.)
	local wo = vim.wo[state.win]
	wo.number = false
	wo.relativenumber = false
	wo.signcolumn = "no"
	wo.wrap = true
	wo.linebreak = true
	wo.conceallevel = 2 -- masque les balises Markdown si Treesitter est actif

	-- Keymaps et rendu initial
	setup_keymaps()
	render_lesson(state.lessons[state.lesson_id])

	-- Nettoie l'état quand le buffer est fermé manuellement
	vim.api.nvim_create_autocmd("BufWipeout", {
		buffer = state.buf,
		once = true,
		callback = function()
			state.buf = nil
			state.win = nil
		end,
	})
end

--- Ferme proprement le tutoriel
function M.close()
	if is_open() then
		vim.api.nvim_win_close(state.win, true)
	end
end

-- ---------------------------------------------------------------------------
-- Setup (appelé depuis ton init.lua principal si tu veux personnaliser)
-- ---------------------------------------------------------------------------

--- Permet de surcharger la config par défaut
--- Exemple : require("nvcrafted.tutor").setup({ width = 100 })
function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M
