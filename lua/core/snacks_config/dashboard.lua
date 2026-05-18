-- ***********************************************************************
-- * core/snacks_config/dashboard.lua                                    *
-- *                                                                     *
-- * Spécification du dashboard snacks.nvim pour NvCrafted.              *
-- * Séparée de la déclaration Lazy (plugins/ux/snacks.lua).             *
-- *                                                                     *
-- * Convention spécification / déclaration :                            *
-- * Ce fichier contient toute la logique du dashboard :                 *
-- *   - ASCII art header                                                *
-- *   - message de bienvenue                                            *
-- *   - boutons d'action                                                *
-- *   - date et heure dynamique en français                             *
-- *   - temps de démarrage                                              *
-- FIX: Highlights à transférer
-- *                                                                     *
-- * Highlights : délégués à core/highlights/alpha_hl.lua                *
-- * (groupes MyAsciiHeader, NvCraftedWelcome — inchangés)               *
-- ***********************************************************************

local M = {}

-- ==============================================================
-- Utilitaire : date et heure en français
-- ==============================================================
local function datetime_fr(date)
	local fr_days = { "Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi" }
	local fr_months = {
		"janvier",
		"février",
		"mars",
		"avril",
		"mai",
		"juin",
		"juillet",
		"août",
		"septembre",
		"octobre",
		"novembre",
		"décembre",
	}
	return string.format(
		"📅  %s %d %s %d  🕒  %02d:%02d",
		fr_days[date.wday],
		date.day,
		fr_months[date.month],
		date.year,
		date.hour,
		date.min
	)
end

-- ==============================================================
-- Configuration principale — retournée à snacks.lua via opts
-- ==============================================================
function M.config()
	return {
		enabled = true,
		width = 80,

		-- -------------------------------------------------------
		-- Formats
		-- -------------------------------------------------------
		formats = {
			header = { "%s", align = "center" },
			footer = { "%s", align = "center" },
			key = function(item)
				return {
					{ "[", hl = "SnacksDashboardKey" },
					{ item.key, hl = "SnacksDashboardKey" },
					{ "]", hl = "SnacksDashboardKey" },
				}
			end,
		},

		-- -------------------------------------------------------
		-- Boutons
		-- -------------------------------------------------------
		preset = {
			keys = {
				{
					icon = "✅",
					key = "c",
					desc = "Vérifier la configuration",
					action = ":checkhealth",
				},
				{
					icon = "🔄",
					key = "u",
					desc = "Mettre à jour les plugins",
					action = ":Lazy update",
				},
				{
					icon = "🔧",
					key = "m",
					desc = "Gérer les LSP/Tools",
					action = ":Mason",
				},
				{
					icon = "📚",
					key = "h",
					desc = "Documentation NvCrafted",
					action = ":NvCraftedDocs",
				},
				{
					icon = "🗃️",
					key = "e",
					desc = "Ouvrir l'explorateur",
					action = ":Neotree",
				},
				{
					icon = "📄",
					key = "n",
					desc = "Nouveau fichier",
					action = ":ene | startinsert",
				},
				{
					icon = "⌛",
					key = "r",
					desc = "Fichiers récents",
					action = ":lua Snacks.dashboard.pick('oldfiles')",
				},
				{
					icon = "🔍",
					key = "t",
					desc = "Rechercher TODO, FIX, BUG…",
					action = ":TodoTelescope",
				},
				{
					icon = "❌",
					key = "q",
					desc = "Quitter NvCrafted",
					action = ":qa",
				},
			},
		},

		-- -------------------------------------------------------
		-- Layout
		-- -------------------------------------------------------
		sections = {

			-- 1. ASCII Art Header
			{
				header = table.concat({
					"░███    ░██              ░██████                      ░████                           ░██",
					"░████   ░██             ░██   ░██                    ░██      ░██                     ░██",
					"░██░██  ░██ ░██    ░██ ░██        ░██░████ ░██████ ░████████  ░██     ░███████   ░███████",
					"░██ ░██ ░██ ░██    ░██ ░██        ░███          ░██  ░██    ░███████ ░██    ░██ ░██   ░██",
					"░██  ░██░██  ░██  ░██  ░██        ░██      ░███████  ░██      ░██    ░█████████ ░██   ░██",
					"░██   ░████   ░██░██    ░██   ░██ ░██     ░██   ░██  ░██      ░██    ░██        ░██    ██",
					"░██    ░███    ░███      ░██████  ░██      ░███████  ░██       ░████  ░███████   ░████░██",
					"                                                     ░██                                 ",
					"                                                    ░██                                  ",
					"                                                                                         ",
				}, "\n"),
				hl = "MyAsciiHeader",
				padding = 1,
			},

			-- 2. Message de bienvenue
			{
				text = {
					{ "✨  Un Neovim prêt à l'emploi, pensé pour être compris et maîtrisé.  ✨", hl = "NvCraftedWelcome", align = "center" },
				},
				padding = 1,
			},

			-- 3. Boutons
			{
				section = "keys",
				gap = 0,
				padding = 1,
			},

			-- 4. Date et heure
			{
			    text = datetime_fr(os.date("*t")),
				hl = "Function",
				align = "center",
				padding = 1,
				ttl = 0,
			},

			-- 5. Temps de démarrage (lazy.nvim)
			{ section = "startup" },
		},
	}
end

return M
