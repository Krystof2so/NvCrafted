-- *************************************************************
-- * core/highlights/palettes.lua                              *
-- *                                                           *
-- * Source de vérité des palettes de couleurs par famille     *
-- * de thème pour NvCrafted.                                  *
-- *                                                           *
-- * Consommé par tous les modules core/highlights/*.lua       *
-- * Ne contient aucune logique, uniquement des données.       *
-- *************************************************************

local M = {}

-- ----------------------------------------------------------------
-- Détection de la famille du thème actif
-- Centralisée ici pour éviter la duplication entre modules
-- ----------------------------------------------------------------
function M.current_family()
	local name = vim.g.colors_name or ""
	if name:find("^rose%-pine") then return "rose-pine"
	elseif name == "nordic"     then return "nordic"
	elseif name == "evergarden" then return "evergarden"
	else                             return "default"
	end
end

-- ----------------------------------------------------------------
-- Palettes
-- Chaque entrée peut être consommée par n'importe quel module
-- de highlights selon ses besoins sémantiques.
-- ----------------------------------------------------------------
M.palettes = {
	["rose-pine"] = {
		error   = { group = "DiagnosticError", hex = "#eb6f92" }, -- love
		warning = { group = "DiagnosticWarn",  hex = "#f6c177" }, -- gold
		info    = { group = "DiagnosticInfo",  hex = "#9ccfd8" }, -- foam
		hint    = { group = "DiagnosticHint",  hex = "#c4a7e7" }, -- iris
		default = { group = "Identifier",      hex = "#ebbcba" }, -- rose
		test    = { group = "Identifier",      hex = "#31748f" }, -- pine
		-- Couleurs supplémentaires disponibles pour d'autres modules
		surface = { group = "Normal",          hex = "#1f1d2e" },
		overlay = { group = "NormalFloat",     hex = "#26233a" },
		text    = { group = "Normal",          hex = "#e0def4" },
		muted   = { group = "Comment",         hex = "#6e6a86" },
	},
	["nordic"] = {
		error   = { group = "DiagnosticError", hex = "#BF616A" },
		warning = { group = "DiagnosticWarn",  hex = "#EBCB8B" },
		info    = { group = "DiagnosticInfo",  hex = "#8FBCBB" },
		hint    = { group = "DiagnosticHint",  hex = "#81A1C1" },
		default = { group = "Identifier",      hex = "#B48EAD" },
		test    = { group = "Identifier",      hex = "#88C0D0" },
		surface = { group = "Normal",          hex = "#242933" },
		overlay = { group = "NormalFloat",     hex = "#2e3440" },
		text    = { group = "Normal",          hex = "#D8DEE9" },
		muted   = { group = "Comment",         hex = "#616E88" },
	},
	["evergarden"] = {
		error   = { group = "DiagnosticError", hex = "#e67e80" },
		warning = { group = "DiagnosticWarn",  hex = "#dbbc7f" },
		info    = { group = "DiagnosticInfo",  hex = "#7fbbb3" },
		hint    = { group = "DiagnosticHint",  hex = "#a7c080" },
		default = { group = "Identifier",      hex = "#d699b6" },
		test    = { group = "Identifier",      hex = "#83c092" },
		surface = { group = "Normal",          hex = "#272e33" },
		overlay = { group = "NormalFloat",     hex = "#2e383c" },
		text    = { group = "Normal",          hex = "#d3c6aa" },
		muted   = { group = "Comment",         hex = "#859289" },
	},
	["default"] = {
		error   = { group = "DiagnosticError", hex = "#DC2626" },
		warning = { group = "DiagnosticWarn",  hex = "#FBBF24" },
		info    = { group = "DiagnosticInfo",  hex = "#2563EB" },
		hint    = { group = "DiagnosticHint",  hex = "#10B981" },
		default = { group = "Identifier",      hex = "#7C3AED" },
		test    = { group = "Identifier",      hex = "#FF00FF" },
		surface = { group = "Normal",          hex = "#1e1e2e" },
		overlay = { group = "NormalFloat",     hex = "#313244" },
		text    = { group = "Normal",          hex = "#cdd6f4" },
		muted   = { group = "Comment",         hex = "#6c7086" },
	},
}

--- Retourne la palette du thème actif
--- @return table
function M.get()
	return M.palettes[M.current_family()] or M.palettes["default"]
end

--- Retourne une entrée spécifique de la palette active
--- Pratique pour les modules qui n'ont besoin que d'une couleur
--- @param key string  ex: "error", "info", "surface"
--- @return table  { group = "...", hex = "..." }
function M.get_color(key)
	local palette = M.get()
	return palette[key] or { group = "Normal", hex = "#ffffff" }
end

return M
