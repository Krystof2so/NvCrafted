-- *************************************************************
-- * core/highlights/multicursor_hl.lua                        *
-- *                                                           *
-- * Highlights adaptatifs pour multicursor.nvim.              *
-- * - Curseur principal : curseur natif (groupe Cursor,       *
-- *   couleur 'error', cf. core/highlights/init.lua)          *
-- * - Curseurs secondaires : groupe MultiCursorCursor,        *
-- *   couleur 'hint' → distincte du principal                 *
-- * Consomme core/highlights/themes/                          *
-- *                                                           *
-- * Appelé depuis core/highlights/init.lua                    *
-- *************************************************************

local M = {}

function M.setup()
	local p = require("core.highlights.themes").get()
	local hl = vim.api.nvim_set_hl

	-- Curseurs secondaires actifs
	hl(0, "MultiCursorCursor", { fg = p.surface.hex, bg = p.hint.hex, bold = true })
	hl(0, "MultiCursorVisual", { link = "Visual" })
	hl(0, "MultiCursorSign", { link = "SignColumn" })

	-- Curseurs désactivés (toggleCursor) : discrets
	hl(0, "MultiCursorDisabledCursor", { fg = p.surface.hex, bg = p.muted.hex })
	hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
	hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
end

return M
