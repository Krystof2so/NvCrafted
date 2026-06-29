-- *************************************************************
-- * plugins/ux/notify.lua                                     *
-- *                                                           *
-- * Configuration des notifications                           *
-- *************************************************************

return {
	"rcarriga/nvim-notify",
	opts = {
		level = vim.log.levels.DEBUG, -- Tout sauf 'TRACE'
		timeout = 3000, -- Durée d'affichage des notifications (3s)
		max_width = 80, -- Largeur fixe (nombre de colones)
		max_height = 8, -- Nombre de ligne maximum
		stages = "slide", -- animation glissante
		icons = {
			ERROR = " ",
			WARN = " ",
			INFO = " ",
			DEBUG = " ",
			TRACE = "󰴓 ",
		},
		time_formats = {
			notification = "%H:%M", -- Heure dans les notifications
			notification_history = "%H:%M", -- Heure dans l'historique
		},
		on_open = function(win)
			-- Désactiver le curseur dans la fenêtre notify
			vim.wo[win].cursorline = false
		end,
		render = "default", -- Icône + titre + message sur plusieurs lignes
        minimum_width = 40, -- Largeur minimale
        fps = 40, -- Images par seconde (animation)
		top_down = true, -- notifications empilées depuis le haut à droite
	},
}
