-- *************************************************************
-- * core/highlights/which_key.lua                             *
-- *                                                           *
-- * Highlights de which-key.nvim pour NvCrafted.              *
-- * Utilise des liens vers les groupes natifs Neovim :        *
-- * adaptation automatique à tout thème sans palette codée.   *
-- *                                                           *
-- * Appelé depuis core/highlights/init.lua                    *
-- *************************************************************

local M = {}

function M.setup()
	local hl = vim.api.nvim_set_hl

	-- Liens vers les groupes natifs Neovim
	-- → s'adaptent automatiquement au thème courant
	hl(0, "WhichKeyDesc", { link = "Identifier" })
	hl(0, "WhichKeyGroup", { link = "Function" })
	hl(0, "WhichKeySeparator", { link = "Comment" })
	hl(0, "WhichKeyValue", { link = "Comment" })
	hl(0, "WhichKeyBorder", { link = "FloatBorder" })
	hl(0, "NormalFloat", { link = "Normal" })
end

return M
