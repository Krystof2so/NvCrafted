-- *************************************************************
-- * lua/core/theme.lua                                        *
-- *                                                           *
-- * Gestion des thèmes de NvCrafted.                          *
-- * Thème principal : Rosé Pine (variante "main" par défaut). *
-- *                                                           *
-- * Variantes Rosé Pine disponibles via le toggle :           *
-- *   rose-pine-main  →  main  (sombre, tons chauds)          *
-- *   rose-pine-moon  →  moon  (sombre, tons froids)          *
-- *   rose-pine-dawn  →  dawn  (clair)                        *
-- *                                                           *
-- * Autres thèmes conservés :                                 *
-- *   nordic, evergarden                                      *
-- *************************************************************

local M = {}

-- ================================================================
-- = Liste des thèmes disponibles dans le picker Telescope        =
-- ================================================================
M.available = {
	-- Variantes Rosé Pine
	"rose-pine-main", -- main  (thème par défaut)
	"rose-pine-moon", -- moon
	"rose-pine-dawn", -- dawn (clair)
	-- Autres thèmes
	"nordic",
	"evergarden",
}

-- ================================================================
-- = Thème appliqué au démarrage de NvCrafted                     =
-- ================================================================
M.default = "rose-pine-main"

-- ================================================================
-- = Application d'un thème                                       =
-- ================================================================
function M.apply(theme)
	vim.cmd.colorscheme(theme)
	-- Rafraîchit les highlights adaptatifs après chaque changement de thème.
	-- ColorScheme autocmd déclenche core.highlights.setup() automatiquement.
	-- L'appel explicite ci-dessous couvre les cas où l'autocmd ne suffit pas
	pcall(function()
		require("core.highlights").setup()
	end)
end

-- ================================================================
-- = Auto-commande pour bénéficier des Highlights au démarrage    =
-- =                                                              =
-- = Déclenché par l'événement ColorScheme, émis par le plugin    =
-- = rose-pine quand il appelle vim.cmd.colorscheme() dans son    =
-- = config. À ce moment, vim.g.colors_name est déjà défini,     =
-- = tous les highlights sont donc appliqués avec le bon thème.   =
-- ================================================================
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		pcall(function()
			require("core.highlights").setup()
		end)
	end,
})

-- ================================================================
-- = Picker Telescope avec prévisualisation temps réel            =
-- =                                                              =
-- = Chaque thème est préfixé de son numéro d'ordre.             =
-- = Saisir un numéro dans le prompt filtre instantanément        =
-- = la liste pour une sélection rapide au clavier.               =
-- = Navigation : j / k  ou  <C-n> / <C-p>                       =
-- = Prévisualisation : temps réel à chaque déplacement           =
-- = Annulation : <Esc> ou q  →  restaure le thème précédent      =
-- = Confirmation : <CR>  →  applique définitivement              =
-- ================================================================
function M.preview_with_telescope()
	local pickers      = require("telescope.pickers")
	local finders      = require("telescope.finders")
	local conf         = require("telescope.config").values
	local actions      = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	-- Thème actif avant l'ouverture du picker — restauré sur annulation
	local current_theme = vim.g.colors_name

	-- -------------------------------------------------------
	-- Construction des entrées numérotées
	-- Chaque entrée expose :
	--   display  → ce qui est affiché  : "1. rose-pine-main"
	--   ordinal  → ce sur quoi Telescope filtre (idem)
	--   value    → le nom du colorscheme à passer à M.apply()
	-- -------------------------------------------------------
	local entries = {}
	for i, name in ipairs(M.available) do
		table.insert(entries, {
			display = string.format("%d. %s", i, name),
			ordinal = string.format("%d. %s", i, name),
			value   = name,
		})
	end

	-- -------------------------------------------------------
	-- Applique le thème de l'entrée courante (prévisualisation)
	-- -------------------------------------------------------
	local function preview_selected()
		local entry = action_state.get_selected_entry()
		if entry then
			M.apply(entry.value)
		end
	end

	-- -------------------------------------------------------
	-- Ferme le picker et restaure le thème d'origine
	-- -------------------------------------------------------
	local function close_and_restore(prompt_bufnr)
		actions.close(prompt_bufnr)
		M.apply(current_theme)
	end

	pickers.new({}, {
		prompt_title     = "Sélection du thème",
		results_title    = "Thèmes disponibles",
		sorting_strategy = "ascending",
		initial_mode     = "normal",
		layout_config    = { prompt_position = "top" },

		finder = finders.new_table({
			results = entries,
			entry_maker = function(entry)
				return {
					value   = entry.value,
					display = entry.display,
					ordinal = entry.ordinal,
				}
			end,
		}),

		-- Tri générique : filtre sur ordinal (numéro + nom)
		sorter = conf.generic_sorter({}),

		attach_mappings = function(prompt_bufnr, map)
			-- --------------------------------------------------
			-- Navigation avec prévisualisation temps réel
			-- --------------------------------------------------
			map({ "n", "i" }, "<C-n>", function()
				actions.move_selection_next(prompt_bufnr)
				preview_selected()
			end)
			map({ "n", "i" }, "<C-p>", function()
				actions.move_selection_previous(prompt_bufnr)
				preview_selected()
			end)
			map("n", "j", function()
				actions.move_selection_next(prompt_bufnr)
				preview_selected()
			end)
			map("n", "k", function()
				actions.move_selection_previous(prompt_bufnr)
				preview_selected()
			end)

			-- --------------------------------------------------
			-- Passage en mode insertion pour saisir un numéro
			-- sans fermer le picker
			-- --------------------------------------------------
			map("i", "<Esc>", function()
				vim.cmd("stopinsert")
			end)

			-- --------------------------------------------------
			-- Annulation avec restauration du thème précédent
			-- --------------------------------------------------
			map("n", "<Esc>", function()
				close_and_restore(prompt_bufnr)
			end)
			map("n", "q", function()
				close_and_restore(prompt_bufnr)
			end)

			-- --------------------------------------------------
			-- Confirmation : applique définitivement le thème
			-- --------------------------------------------------
			actions.select_default:replace(function()
				local entry = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				if entry then
					M.apply(entry.value)
				else
					M.apply(current_theme)
				end
			end)

			return true
		end,
	}):find()
end

return M
