-- *********************************************************************
-- * lua/core/map_actions/keymaps_picker.lua                           *
-- *                                                                   *
-- * Visualisation des mappings globaux et buffer-local via Telescope. *
-- * Mode consultation uniquement — aucune action n'est exécutée.      *
-- * Accessible via <leader>hm (groupe h = aide).                      *
-- *********************************************************************

local M = {}

-- -----------------------------------------------------------------------
-- Constantes
-- -----------------------------------------------------------------------

local NO_DESC = "Pas de description"
local PROMPT_TITLE = "  Mappings — global & buffer-local"
local DESC = "Description:"
local LINE_UNDER_DESC = string.rep("_", #DESC)
local LUA_FUNCTION = "Type : Fonction Lua"

--- @type table<string, string>
local MODE_LABELS = {
	n = "Normal",
	i = "Insert",
	v = "Visual",
	x = "Block",
	o = "Operator",
	t = "Terminal",
	c = "Command",
}

local SCOPE_GLOBAL = "global"
local SCOPE_LOCAL = "local"

local SCOPE_ORDER = {
	[SCOPE_GLOBAL] = 1,
	[SCOPE_LOCAL] = 2,
}

-- -----------------------------------------------------------------------
-- Types
-- -----------------------------------------------------------------------

--- @class KeymapItem
--- @field lhs        string
--- @field mode_label string
--- @field mode_code  string
--- @field scope      string
--- @field desc_short string
--- @field desc_long  string
--- @field rhs        string|nil
--- @field callback   function|nil

-- -----------------------------------------------------------------------
-- Utilitaires
-- -----------------------------------------------------------------------

--- Traduit les caractères spéciaux du lhs en notation lisible.
--- Exemple : " ff" → "<leader>ff"
--- @param  lhs string
--- @return string
local function display_lhs(lhs)
	return vim.fn.keytrans(lhs)
end

--- Limite l'affichage d'une string
--- @param str string
--- @param len integer
--- @return string
local function truncate(str, len)
	if #str <= len then
		return str
	end
	return str:sub(1, len) .. "..."
end

--- Coupe une chaîne en lignes d'au plus `width` caractères.
--- La coupure se fait sur le dernier espace disponible si possible (évite de couper les mots).
--- @param  text  string
--- @param  width integer
--- @return string[]
local function wrap_text(text, width)
	if not text or text == "" then
		return {}
	end
	local words = {}
	for word in text:gmatch("%S+") do -- Extrait tous les mots
		table.insert(words, word)
	end
	local lines = {}
	local current_line = ""
	local space_left = width
	for _, word in ipairs(words) do
		local word_width = #word -- Récupère la longueur de la chaîne word
		-- Si le mot ne tient pas sur la ligne courante (en tenant compte de l'espace)
		if (word_width + 1) > space_left then
			-- On insère un saut de ligne avant ce mot
			table.insert(lines, current_line)
			current_line = word
			space_left = width - word_width
		else
			-- Le mot tient, on l'ajoute
			if current_line == "" then
				current_line = word
			else
				current_line = current_line .. " " .. word
			end
			space_left = space_left - (word_width + 1)
		end
	end
	-- Ne pas oublier la dernière ligne
	if current_line ~= "" then
		table.insert(lines, current_line)
	end
	return lines
end

-- -----------------------------------------------------------------------
-- Collecte
-- -----------------------------------------------------------------------

--- Collecte les mappings d'un mode et d'une portée donnés.
--- @param  mode  string
--- @param  scope string   SCOPE_GLOBAL ou SCOPE_LOCAL
--- @param  bufnr integer|nil  Requis si scope == SCOPE_LOCAL
--- @return KeymapItem[]
local function collect(mode, scope, bufnr)
	local raw = (scope == SCOPE_LOCAL) and vim.api.nvim_buf_get_keymap(bufnr --[[@as integer]], mode)
		or vim.api.nvim_get_keymap(mode)

	--- @type KeymapItem[]
	local items = {}
	for _, m in ipairs(raw) do
		if m.lhs and m.lhs ~= "" then
			local raw_desc = m.desc or NO_DESC
			-- On décompose la descrition ('desc') avec '|' comme séparateur
			-- { desc = "Description courte | Description longue" } - Cf. dans la définition des mappings
			local desc_short, desc_long = raw_desc:match("^(.-)%s*|%s*(.+)$")
			if not desc_short then -- Si pas de décomposition de la description
				desc_short = raw_desc
				desc_long = raw_desc
			end
			--- @type KeymapItem
			local item = { -- Informations qui nous seront nécessaires
				lhs = m.lhs,
				mode_label = MODE_LABELS[mode] or mode,
				mode_code = mode,
				scope = scope,
				desc_short = desc_short,
				desc_long = desc_long,
				rhs = m.rhs,
				callback = m.callback,
			}
			-- On reconstruit une table avec tous les éléments dont nous avons besoin pour la visualisation
			table.insert(items, item)
		end
	end
	return items
end

--- Collecte tous les mappings (globaux + buffer-local) pour tous les modes.
--- @return KeymapItem[]
local function collect_all()
	-- Récupération de l'identifiant du buffer courant
	--- @type integer|nil
	local bufnr = vim.api.nvim_get_current_buf()
	-- Construction de la table des mappings
	--- @type KeymapItem[]
	local all = {}
	-- On boucle sur tous les modes à la fois pour les mappings globaux et locaux
	for mode in pairs(MODE_LABELS) do
		vim.list_extend(all, collect(mode, SCOPE_GLOBAL, nil))
		vim.list_extend(all, collect(mode, SCOPE_LOCAL, bufnr))
	end
	return all
end

-- -----------------------------------------------------------------------
-- Tri
-- -----------------------------------------------------------------------

--- Trie en place les items : scope (global en premier) → mode → lhs.
--- @param items KeymapItem[]
local function sort_items(items)
	table.sort(items, function(a, b)
		local sa = SCOPE_ORDER[a.scope]
		local sb = SCOPE_ORDER[b.scope]
		if sa ~= sb then
			return sa < sb -- Tri des scopes
		end
		if a.mode_code ~= b.mode_code then
			return a.mode_code < b.mode_code -- Tri alphabétique des modes
		end
		return a.lhs < b.lhs -- Tri alphabétique des commandes
	end)
end

-- -----------------------------------------------------------------------
-- Picker Telescope
-- -----------------------------------------------------------------------

--- Ouvre le picker Telescope en mode consultation.
--- @param items KeymapItem[]
local function open_picker(items)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local previewers = require("telescope.previewers")
	local conf = require("telescope.config").values
	pickers
		.new({}, {
			prompt_title = PROMPT_TITLE,
			sorting_strategy = "ascending",
			layout_config = { prompt_position = "top" },
			finder = finders.new_table({
				results = items,
				entry_maker = function(entry)
					--- @cast entry KeymapItem  -- requalifie le type générique (inféré par lua_ls, via entry_maker)
					local lhs_display = display_lhs(entry.lhs)
					return {
						value = entry,
						display = string.format( -- ce qui sera affiché dans le 'finder'
							"[%s] %-20s  %s",
							entry.mode_code,
							truncate(lhs_display, 15),
							entry.desc_short
						),
						-- ordinal : utilisé par l'algorithme de fuzzy matching (formatage en minuscule recommandé)
						ordinal = string.format(
							"%s %s %s %s",
							entry.scope,
							entry.mode_label:lower(),
							lhs_display:lower(),
							entry.desc_short:lower()
						),
					}
				end,
			}),
			sorter = conf.generic_sorter({}), -- Tri en place de la recherche
			previewer = previewers.new_buffer_previewer({
				define_preview = function(self, entry)
					--- @cast entry {value: KeymapItem}
					local item = entry.value
					-- Récupère 70% de la taille de la fenêtre avec une limite fixée à 80 caractères
					--- @type integer
					local width = math.min(80, math.floor(vim.api.nvim_win_get_width(0) * 0.7))
					-- Formatage des chaînes de caractères en plusieurs lignes (adapté à la taille de la fenêtre)
					local desc_lines = wrap_text(item.desc_long, width)
					local hls_lines = wrap_text(string.format("Touches  : %s", display_lhs(item.lhs)), width)
					local rhs_lines = wrap_text(string.format("Commande : %s", item.rhs), width)
					local lines = { "", DESC, LINE_UNDER_DESC, "" }
					vim.list_extend(lines, desc_lines)
					vim.list_extend(lines, {
						"",
						string.format("Portée   : %s", item.scope),
						string.format("Mode     : %s", item.mode_label),
					})
					vim.list_extend(lines, hls_lines)
					table.insert(lines, "")
					if item.rhs then
						vim.list_extend(lines, rhs_lines)
					end
					if item.callback then
						table.insert(lines, LUA_FUNCTION)
					end
					vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
				end,
			}),
			-- Aucune action possible avec Telescope
			attach_mappings = function(_, map)
				local msg = "Mode consultation uniquement — aucune action ne sera exécutée"
				map({ "i", "n" }, "<CR>", function()
					vim.notify(msg, vim.log.levels.INFO, { title = "Keymaps Picker" })
				end)
				return true
			end,
		})
		:find()
end

-- -----------------------------------------------------------------------
-- Point d'entrée public
-- -----------------------------------------------------------------------

function M.open()
	--- @type KeymapItem
	local items = collect_all() -- récupération des mappings globaux et locaux
	sort_items(items) -- tri alphabétique en place
	open_picker(items) -- Visualisation dans Telescope
end

return M
