-- *************************************************************
-- * core/highlights/themes/init.lua                           *
-- *                                                           *
-- * Routeur de palettes pour NvCrafted.                       *
-- * Détecte la famille du thème actif et charge              *
-- * le fichier de palette correspondant.                      *
-- *                                                           *
-- * Remplace core/highlights/palettes.lua                     *
-- * Consommé par tous les modules core/highlights/*.lua       *
-- *************************************************************

local M = {}

--- Détecte la famille du thème actif
--- @return string
function M.current_family()
	local name = vim.g.colors_name or ""
	if name:find("^rose%-pine") then
		return "rose_pine"
	elseif name == "nordic" then
		return "nordic"
	elseif name == "evergarden" then
		return "evergarden"
	else
		return "default"
	end
end

--- Retourne la palette du thème actif
--- @return table
function M.get()
	local family = M.current_family()
	local ok, palette = pcall(require, "core.highlights.themes." .. family)
	if not ok then
		return require("core.highlights.themes.default")
	end
	return palette
end

--- Retourne une entrée spécifique de la palette active
--- @param key string  ex: "error", "info", "surface"
--- @return table  { group = "...", hex = "..." }
function M.get_color(key)
	local palette = M.get()
	return palette[key] or { group = "Normal", hex = "#ffffff" }
end

return M
