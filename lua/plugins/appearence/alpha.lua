return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- Gestion des couleurs déléguée à 'lua/core/highlights/alpha_hl.lua'

			-- =======================================
			-- Header : Ascii Art + Message d'accueil
			-- =======================================
			dashboard.section.header.val = {
				[[░███    ░██              ░██████                          ░████    ░██                      ░██]],
				[[░████   ░██             ░██   ░██                        ░██       ░██                      ░██]],
				[[░██░██  ░██ ░██    ░██ ░██        ░██░████  ░██████   ░████████ ░████████  ░███████   ░████████]],
				[[░██ ░██ ░██ ░██    ░██ ░██        ░███           ░██     ░██       ░██    ░██    ░██ ░██    ░██]],
				[[░██  ░██░██  ░██  ░██  ░██        ░██       ░███████     ░██       ░██    ░█████████ ░██    ░██]],
				[[░██   ░████   ░██░██    ░██   ░██ ░██      ░██   ░██     ░██       ░██    ░██        ░██   ░███]],
				[[░██    ░███    ░███      ░██████  ░██       ░█████░██    ░██        ░████  ░███████   ░█████░██]],
				[[                                                                                               ]],
			}
			dashboard.section.header.opts = {
				position = "center",
				hl = "MyAsciiHeader", -- Appliquer la couleur définie
			}

			-- =======================================
			-- Section dédiée : Message de bienvenue
			-- =======================================
			dashboard.section.welcome = {
				type = "text",
				val = {
					"⚡ Bienvenue dans NvCrafted ! ⚡",
					"",
					"Un framework IDE-like pour Neovim",
				},
				opts = {
					position = "center",
					hl = "NvCraftedWelcome",
				},
			}

			-- ==============================
			-- Boutons : Actions principales
			-- ==============================
			dashboard.section.buttons.val = {
				dashboard.button("c", "✅ Vérifier la configuration", ":checkhealth<CR>"),
				dashboard.button("u", "🔄 Mettre à jour les plugins", ":Lazy update<CR>"),
				dashboard.button("t", "🔧 Gérer les LSP/Tools", ":Mason<CR>"),
				dashboard.button("h", "📚 Documentation NvCrafted", ":NvCraftedDocs<CR>"),
				dashboard.button("e", "🗃️ Ouvrir l'explorateur", ":Neotree<CR>"),
				dashboard.button("n", "📄 Nouveau fichier", ":ene <BAR> startinsert <CR>"),
				dashboard.button("r", "⌛ Fichiers récents", ":Telescope oldfiles<CR>"),
				dashboard.button("t", "🔍 Rechercher TODO, FIX, BUG, etc.", ":TodoTelescope<CR>"),
				dashboard.button("q", "❌ Quitter NvCrafted", ":qa<CR>"),
			}

			-- ==================================
			-- Section date et heure en français
			-- ==================================
			dashboard.section.datetime = {
				type = "text",
				val = function()
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
					local date = os.date("*t")
					local week_day = fr_days[date.wday]
					local month = fr_months[date.month]
					return string.format(
						"📅  %s %d %s %d  🕒  %02d:%02d",
						week_day,
						date.day,
						month,
						date.year,
						date.hour,
						date.min
					)
				end,
				opts = {
					position = "center",
					hl = "Function",
				},
			}

			-- =========================================================================
			-- Layout du Dashboard
			-- =========================================================================
			dashboard.config.layout = {
				{ type = "group", val = { dashboard.section.header }, opts = { position = "center" } },
				{ type = "padding", val = 2 },
				{ type = "group", val = { dashboard.section.welcome }, opts = { position = "center" } },
				{ type = "padding", val = 2 },
				{ type = "group", val = { dashboard.section.buttons }, opts = { position = "center" } },
				{ type = "padding", val = 2 },
				{ type = "group", val = { dashboard.section.datetime }, opts = { position = "center" } },
				{ type = "padding", val = 1 },
			}

			-- =====================
			-- Options du Dashboard
			-- =====================
			dashboard.config.opts.noautocmd = true
			alpha.setup(dashboard.config)
		end,
	},
}
