-- *************************************************************
-- * core/highlights/snacks_hl.lua                             *
-- *                                                           *
-- * Highlights des modules snacks.nvim pour NvCrafted.        *
-- * Consomme core/highlights/palettes.lua                     *
-- *                                                           *
-- * Groupes couverts :                                        *
-- *   Snacks.input :                                          *
-- *     SnacksInputNormal  → fond et texte de la fenêtre      *
-- *     SnacksInputBorder  → bordure                          *
-- *     SnacksInputTitle   → titre du prompt                  *
-- *     SnacksInputIcon    → icône du prompt                  *
-- *   Snacks.win :                                            *
-- *     SnacksWinNormal    → fond et texte de la fenêtre      *
-- *     SnacksWinBorder    → bordure                          *
-- *     SnacksWinFooter    → footer de la fenêtre             *
-- *     SnacksWinSeparator → séparateur de fenêtre            *
-- *                                                           *
-- * Appelé depuis core/highlights/init.lua                    *
-- *************************************************************

local M = {}

function M.setup()
	local p = require("core.highlights.palettes").get()
	local hl = vim.api.nvim_set_hl

	-- ========================
	-- Snacks.input
	-- ========================
	hl(0, "SnacksInputNormal", { fg = p.text.hex, bg = p.surface.hex })
	hl(0, "SnacksInputBorder", { fg = p.info.hex, bg = p.surface.hex })
	hl(0, "SnacksInputTitle", { fg = p.text.hex, bg = p.overlay.hex, bold = true })
	hl(0, "SnacksInputIcon", { fg = p.hint.hex, bg = p.surface.hex })

	-- ========================
	-- Snacks.win
	-- ========================
	hl(0, "SnacksWinNormal", { fg = p.info.hex, bg = p.surface.hex })
	hl(0, "SnacksWinBorder", { fg = p.test.hex, bg = p.overlay.hex })
	hl(0, "SnacksWinFooter", { fg = p.default.hex, bg = p.overlay.hex })
	hl(0, "SnacksWinSeparator", { fg = p.muted.hex, bg = p.surface.hex })
end

return M
