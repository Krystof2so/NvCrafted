-- ******************************************************
-- * lua/core/check_neovim_version.lua                  *
-- *                                                    *
-- * 1. Récupère depuis GitHub le numéro de la dernière *
-- *    version stable de Neovim                        *
-- * 2. Compare avec la version installée               *
-- * 3. Notifie s'il existe une nouvelle version stable * 
-- *    au démarrage de neovim                          *
-- ******************************************************

local M = {}

--- Récupère la dernière version stable de Neovim depuis GitHub
--- @return string|nil : La version sous forme de chaîne (ex: "v0.12.2") ou nil en cas d'erreur
local function get_latest_version_from_github()
	-- Utilise curl pour interroger l'API GitHub
	local handle = io.popen(
		'curl -s https://api.github.com/repos/neovim/neovim/releases/latest 2>/dev/null | grep -oP \'(?<="tag_name": ")v[^"]*\''
	)
	if not handle then
		return nil
	end
	local version_from_github = handle:read("*a")
	handle:close()
	return version_from_github
end

--- Récupère la version courante de Neovim
--- @return string : La version sous forme de chaîne (ex: "v0.12.2")
local function current_version()
    local v = vim.version()
    return string.format("v%d.%d.%d", v.major, v.minor, v.patch)
end

function M.check_version()
	local latest_version = get_latest_version_from_github()
    local current_nvim = current_version()
    if latest_version then
        -- Nettoyage des versions (suppression des espaces, sauts de ligne, etc.)
        latest_version = latest_version:gsub("v", ""):gsub("%s+", ""):gsub("\n", "")
        current_nvim = current_nvim:gsub("v", ""):gsub("%s+", ""):gsub("\n", "")
	    if latest_version ~= current_nvim then
		    print(" Une nouvelle version stable de Neovim est actuellement disponible : "..current_nvim.." 󰜴 "..latest_version.." Source GitHub")
	    end
    end
end

return M
