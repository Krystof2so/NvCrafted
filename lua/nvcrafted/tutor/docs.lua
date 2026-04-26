-- =============================================================================
-- lua/nvcrafted/tutor/docs.lua
-- Viewer de documentation pour NvCrafted
-- Ouvre les fichiers Markdown de docs/ dans un buffer dédié,
-- avec un picker Telescope (ou vim.ui.select en fallback)
-- =============================================================================

local M = {}

-- ---------------------------------------------------------------------------
-- État interne
-- ---------------------------------------------------------------------------

local state = {
	buf = nil, -- buffer courant du viewer
	win = nil, -- fenêtre courante
	path = nil, -- chemin du fichier affiché
}

-- ---------------------------------------------------------------------------
-- Utilitaires
-- ---------------------------------------------------------------------------

--- Retourne true si le viewer est encore ouvert et valide
local function is_open()
	return state.buf ~= nil
		and vim.api.nvim_buf_is_valid(state.buf)
		and state.win ~= nil
		and vim.api.nvim_win_is_valid(state.win)
end

--- Retourne le dossier docs configuré (avec fallback sur docs/ à la racine)
local function docs_dir()
	local ok, tutor = pcall(require, "nvcrafted.tutor")
	if ok and tutor.config and tutor.config.docs_dir then
		return tutor.config.docs_dir
	end
	return vim.fn.stdpath("config") .. "/docs"
end

--- Lit un fichier et retourne une table de lignes
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

--- Retourne la liste des fichiers *.md dans docs_dir, triés par nom
local function list_docs()
	local dir = docs_dir()
	local files = vim.fn.glob(dir .. "/*.md", false, true)
	if #files == 0 then
		vim.notify("[NvCrafted Docs] Aucun fichier trouvé dans : " .. dir, vim.log.levels.WARN)
		return nil
	end
	table.sort(files)
	return files
end

--- Formate un chemin en label lisible : "lsp-nvcrafted.md" → "LSP NvCrafted"
local function to_label(path)
	local name = vim.fn.fnamemodify(path, ":t:r") -- nom sans extension
	-- Remplace les tirets/underscores par des espaces, met en Title Case
	name = name:gsub("[-_]", " ")
	name = name:gsub("(%a)([%w_']*)", function(first, rest)
		return first:upper() .. rest
	end)
	return name
end

-- ---------------------------------------------------------------------------
-- Keymaps locaux au buffer docs
-- ---------------------------------------------------------------------------

local function setup_keymaps()
	local buf = state.buf
	local opts = { buffer = buf, noremap = true, silent = true }

	-- Fermer
	vim.keymap.set("n", "q", function()
		M.close()
	end, vim.tbl_extend("force", opts, { desc = "Fermer la documentation" }))

	-- Ouvrir un autre fichier de doc sans fermer le viewer
	vim.keymap.set("n", "<Tab>", function()
		M.pick()
	end, vim.tbl_extend("force", opts, { desc = "Changer de page de doc" }))

	-- Ouvrir le fichier courant dans un vrai buffer éditable
	vim.keymap.set("n", "<CR>", function()
		if state.path then
			M.close()
			vim.cmd("edit " .. vim.fn.fnameescape(state.path))
		end
	end, vim.tbl_extend("force", opts, { desc = "Éditer ce fichier" }))

	-- Navigation entre titres Markdown (lignes commençant par #)
	vim.keymap.set("n", "]]", function()
		local cur = vim.api.nvim_win_get_cursor(state.win)[1]
		local lines = vim.api.nvim_buf_get_lines(state.buf, cur, -1, false)
		for i, line in ipairs(lines) do
			if line:match("^#") then
				vim.api.nvim_win_set_cursor(state.win, { cur + i, 0 })
				return
			end
		end
		vim.notify("[NvCrafted Docs] Pas de section suivante", vim.log.levels.INFO)
	end, vim.tbl_extend("force", opts, { desc = "Section suivante" }))

	vim.keymap.set("n", "[[", function()
		local cur = vim.api.nvim_win_get_cursor(state.win)[1] - 2
		if cur < 0 then
			return
		end
		local lines = vim.api.nvim_buf_get_lines(state.buf, 0, cur, false)
		for i = #lines, 1, -1 do
			if lines[i]:match("^#") then
				vim.api.nvim_win_set_cursor(state.win, { i, 0 })
				return
			end
		end
		vim.notify("[NvCrafted Docs] Pas de section précédente", vim.log.levels.INFO)
	end, vim.tbl_extend("force", opts, { desc = "Section précédente" }))
end

-- ---------------------------------------------------------------------------
-- Rendu
-- ---------------------------------------------------------------------------

--- Affiche le contenu d'un fichier Markdown dans le buffer docs
local function render(path)
	local lines, err = read_file(path)
	if not lines then
		vim.notify("[NvCrafted Docs] " .. err, vim.log.levels.ERROR)
		return
	end

	state.path = path

	vim.bo[state.buf].modifiable = true
	vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
	vim.bo[state.buf].modifiable = false

	-- Titre de la fenêtre (Neovim 0.9+)
	vim.wo[state.win].winbar = " 󰈙  " .. to_label(path) .. "  ·  <Tab> changer  ·  <CR> éditer  ·  q fermer"

	-- Repart du haut
	vim.api.nvim_win_set_cursor(state.win, { 1, 0 })
end

-- ---------------------------------------------------------------------------
-- Picker
-- ---------------------------------------------------------------------------

--- Tente d'utiliser Telescope ; retombe sur vim.ui.select
local function pick_with_telescope(files, labels, callback)
	local ok, pickers = pcall(require, "telescope.pickers")
	local ok2, finders = pcall(require, "telescope.finders")
	local ok3, conf = pcall(require, "telescope.config")
	local ok4, actions = pcall(require, "telescope.actions")
	local ok5, astate = pcall(require, "telescope.actions.state")

	if not (ok and ok2 and ok3 and ok4 and ok5) then
		return false
	end

	local entries = {}
	for i, path in ipairs(files) do
		table.insert(entries, { label = labels[i], path = path })
	end

	pickers
		.new({}, {
			prompt_title = "NvCrafted — Documentation",
			finder = finders.new_table({
				results = entries,
				entry_maker = function(entry)
					return {
						value = entry.path,
						display = entry.label,
						ordinal = entry.label,
					}
				end,
			}),
			sorter = conf.values.generic_sorter({}),
			attach_mappings = function(prompt_buf, _)
				actions.select_default:replace(function()
					actions.close(prompt_buf)
					local selection = astate.get_selected_entry()
					if selection then
						callback(selection.value)
					end
				end)
				return true
			end,
		})
		:find()

	return true
end

--- Ouvre le picker de sélection de page de documentation
function M.pick()
	local files = list_docs()
	if not files then
		return
	end

	local labels = {}
	for _, path in ipairs(files) do
		table.insert(labels, to_label(path))
	end

	local function on_select(path)
		if not path then
			return
		end
		if is_open() then
			render(path)
		else
			M.open(path)
		end
	end

	-- Essaie Telescope d'abord, sinon vim.ui.select
	local used_telescope = pick_with_telescope(files, labels, on_select)
	if not used_telescope then
		vim.ui.select(labels, { prompt = "NvCrafted Docs :" }, function(_, idx)
			if idx then
				on_select(files[idx])
			end
		end)
	end
end

-- ---------------------------------------------------------------------------
-- Ouverture / fermeture
-- ---------------------------------------------------------------------------

--- Ouvre le viewer de documentation
--- @param path string|nil  Chemin direct vers un fichier .md (optionnel)
---                         Si nil, ouvre le picker de sélection
function M.open(path)
	-- Si déjà ouvert sans chemin précisé → remet le focus
	if is_open() and not path then
		vim.api.nvim_set_current_win(state.win)
		return
	end

	-- Crée le buffer si nécessaire
	if not is_open() then
		state.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[state.buf].buftype = "nofile"
		vim.bo[state.buf].bufhidden = "wipe"
		vim.bo[state.buf].swapfile = false
		vim.bo[state.buf].filetype = "markdown"
		vim.api.nvim_buf_set_name(state.buf, "NvCrafted Docs")

		-- Split vertical à droite
		vim.cmd("botright vsplit")
		state.win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(state.win, state.buf)
		vim.api.nvim_win_set_width(state.win, 90)

		-- Options fenêtre
		vim.wo[state.win].number = false
		vim.wo[state.win].relativenumber = false
		vim.wo[state.win].signcolumn = "no"
		vim.wo[state.win].wrap = true
		vim.wo[state.win].linebreak = true
		vim.wo[state.win].conceallevel = 2
		vim.wo[state.win].winbar = " 󰈙  NvCrafted Docs"

		setup_keymaps()

		-- Nettoyage quand le buffer est fermé
		vim.api.nvim_create_autocmd("BufWipeout", {
			buffer = state.buf,
			once = true,
			callback = function()
				state.buf = nil
				state.win = nil
				state.path = nil
			end,
		})
	end

	-- Si un chemin est fourni, l'afficher directement ; sinon ouvrir le picker
	if path then
		render(path)
	else
		-- Petit defer pour laisser le split s'initialiser avant d'ouvrir Telescope
		vim.defer_fn(function()
			M.pick()
		end, 10)
	end
end

--- Ferme le viewer de documentation
function M.close()
	if is_open() then
		vim.api.nvim_win_close(state.win, true)
	end
end

--- Retourne le dossier docs (exposé pour d'autres modules)
function M.path()
	return docs_dir()
end

--- Retourne la liste des labels de docs (exposé pour d'autres modules)
function M.list()
	local files = list_docs()
	if not files then
		return {}
	end
	local labels = {}
	for _, path in ipairs(files) do
		table.insert(labels, to_label(path))
	end
	return labels
end

return M
