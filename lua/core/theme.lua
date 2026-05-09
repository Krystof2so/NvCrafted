-- *************************************************************
-- * lua/core/theme.lua                                        *
-- *                                                           *
-- * Gestion des thèmes de NvCrafted.                          *
-- * Thème principal : Rosé Pine (variante "main" par défaut). *
-- *                                                           *
-- * Variantes Rosé Pine disponibles via le toggle :           *
-- *   rose-pine       →  main  (sombre, tons chauds)          *
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
M.default = "rose-pine"

-- ================================================================
-- = Application d'un thème                                       =
-- ================================================================
function M.apply(theme)
	vim.cmd.colorscheme(theme)
	-- Rafraîchit les highlights adaptatifs après chaque changement de thème.
	-- pcall évite un crash si le module n'est pas encore chargé.
	pcall(function()
		require("core.highlights").setup()
	end)
end

-- ================================================================
-- = Picker Telescope avec prévisualisation temps réel            =
-- ================================================================
function M.preview_with_telescope()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local current_theme = vim.g.colors_name

	local function preview_selected()
		local entry = action_state.get_selected_entry()
		if entry then
			M.apply(entry[1])
		end
	end

	local function close_and_restore(bufnr)
		actions.close(bufnr)
		M.apply(current_theme)
	end

	pickers
		.new({}, {
			prompt_title = "Sélection du thème",
			initial_mode = "normal",
			finder = finders.new_table({
				results = M.available,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				-- Navigation mode insertion avec prévisualisation
				map("i", "<C-n>", function()
					actions.move_selection_next(prompt_bufnr)
					preview_selected()
				end)
				map("i", "<C-p>", function()
					actions.move_selection_previous(prompt_bufnr)
					preview_selected()
				end)
				-- Navigation mode normal avec prévisualisation
				map("n", "j", function()
					actions.move_selection_next(prompt_bufnr)
					preview_selected()
				end)
				map("n", "k", function()
					actions.move_selection_previous(prompt_bufnr)
					preview_selected()
				end)
				-- Echap : passe en mode normal sans fermer
				map("i", "<Esc>", function()
					vim.cmd("stopinsert")
				end)
				-- Fermeture avec restauration
				map("n", "<Esc>", function()
					close_and_restore(prompt_bufnr)
				end)
				map("n", "q", function()
					close_and_restore(prompt_bufnr)
				end)
				-- Confirmation : applique définitivement le thème sélectionné
				actions.select_default:replace(function()
					local entry = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					if entry then
						M.apply(entry[1])
					else
						M.apply(current_theme)
					end
				end)
				return true
			end,
		})
		:find()
end

return M
