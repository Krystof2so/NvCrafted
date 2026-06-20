-- *************************************************************
-- * core/highlights/themes/default.lua                        *
-- *                                                           *
-- * Palette fallback pour NvCrafted.                          *
-- * Appliquée pour tout thème non reconnu.                    *
-- * Consommée par core/highlights/themes/init.lua             *
-- *************************************************************

return {
	error = { group = "DiagnosticError", hex = "#DC2626" },
	warning = { group = "DiagnosticWarn", hex = "#FBBF24" },
	info = { group = "DiagnosticInfo", hex = "#2563EB" },
	hint = { group = "DiagnosticHint", hex = "#10B981" },
	default = { group = "Identifier", hex = "#7C3AED" },
	test = { group = "Identifier", hex = "#FF00FF" },
	surface = { group = "Normal", hex = "#1e1e2e" },
	overlay = { group = "NormalFloat", hex = "#313244" },
	text = { group = "Normal", hex = "#cdd6f4" },
	muted = { group = "Comment", hex = "#6c7086" },
}
