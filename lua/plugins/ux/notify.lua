return {
	"rcarriga/nvim-notify",
	opts = { -- Pour des notifications sobres
		render = "default", -- juste le texte, sans encadré
		stages = "slide", -- animation glissante
		timeout = 3000,
		top_down = true, -- notifications empilées depuis le haut à droite
		time_formats = {
			notification = "", -- supprime l'heure dans les notifications
			notification_history = "%H:%M", -- conserve l'heure dans l'historique
		},
	},
}
