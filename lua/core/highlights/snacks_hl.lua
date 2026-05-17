-- *************************************************************
-- * core/highlights/snacks_hl.lua                             *
-- *                                                           *
-- * Highlights du module input de snacks.nvim pour NvCrafted. *
-- * Consomme core/highlights/palettes.lua                     *
-- *                                                           *
-- * Groupes couverts :                                        *
-- *   SnacksInputNormal  → fond et texte de la fenêtre        *
-- *   SnacksInputBorder  → bordure                            *
-- *   SnacksInputTitle   → titre du prompt                    *
-- *   SnacksInputIcon    → icône du prompt                    *
-- *                                                           *
-- * Appelé depuis core/highlights/init.lua                    *
-- *************************************************************

local M = {}

function M.setup()
	local p = require("core.highlights.palettes").get()
	local hl = vim.api.nvim_set_hl

	hl(0, "SnacksInputNormal", { fg = p.text.hex, bg = p.surface.hex })
	hl(0, "SnacksInputBorder", { fg = p.info.hex, bg = p.surface.hex })
	hl(0, "SnacksInputTitle", { fg = p.text.hex, bg = p.overlay.hex, bold = true })
	hl(0, "SnacksInputIcon", { fg = p.hint.hex, bg = p.surface.hex })
end

return M
