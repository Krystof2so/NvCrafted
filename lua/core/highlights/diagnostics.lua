-- ************************************************************
-- * core/highlights/diagnostics.lua                          *
-- *                                                          *
-- * Highlights de diagnostics LSP adaptatifs au thème.       *
-- * Consomme core/highlights/palettes.lua                    *
-- *                                                          *
-- * Appelé depuis :                                          *
-- *   - core/highlights/init.lua  (changement de thème)      *
-- *   - core/lsp/on_attach.lua    (attachement LSP)          *
-- ************************************************************

local M = {}

local function apply_diagnostic_config()
	vim.diagnostic.config({
		signs = {
			active = true,
			values = {
				Error = { text = "●", texthl = "DiagnosticSignError" },
				Warn = { text = "●", texthl = "DiagnosticSignWarn" },
				Hint = { text = "●", texthl = "DiagnosticSignHint" },
				Info = { text = "●", texthl = "DiagnosticSignInfo" },
			},
		},
		virtual_text = { prefix = "●", spacing = 2 },
		underline = true,
		update_in_insert = false,
		severity_sort = true,
	})
end

function M.setup()
	apply_diagnostic_config()

	local palettes = require("core.highlights.palettes")
	local family = palettes.current_family()
	local hl = vim.api.nvim_set_hl

	-- Rosé Pine : délègue à la palette officielle du plugin
	if family == "rose-pine" then
		hl(0, "DiagnosticVirtualTextError", { fg = nil })
		hl(0, "DiagnosticVirtualTextWarn", { fg = nil })
		hl(0, "DiagnosticVirtualTextInfo", { fg = nil })
		hl(0, "DiagnosticVirtualTextHint", { italic = true })
		return
	end

	local p = palettes.get()

	hl(0, "DiagnosticError", { fg = p.error.hex, bold = true })
	hl(0, "DiagnosticWarn", { fg = p.warning.hex, bold = true })
	hl(0, "DiagnosticInfo", { fg = p.info.hex, bold = true })
	hl(0, "DiagnosticHint", { fg = p.hint.hex, italic = true })

	hl(0, "DiagnosticUnderlineError", { sp = p.error.hex, undercurl = true })
	hl(0, "DiagnosticUnderlineWarn", { sp = p.warning.hex, undercurl = true })
	hl(0, "DiagnosticUnderlineInfo", { sp = p.info.hex, undercurl = true })
	hl(0, "DiagnosticUnderlineHint", { sp = p.hint.hex, undercurl = true })

	hl(0, "DiagnosticVirtualTextError", { fg = p.error.hex })
	hl(0, "DiagnosticVirtualTextWarn", { fg = p.warning.hex })
	hl(0, "DiagnosticVirtualTextInfo", { fg = p.info.hex })
	hl(0, "DiagnosticVirtualTextHint", { fg = p.hint.hex, italic = true })

	-- Fallback : réinitialise via link si aucun thème reconnu
	if family == "default" then
		hl(0, "DiagnosticVirtualTextError", { link = "DiagnosticError" })
		hl(0, "DiagnosticVirtualTextWarn", { link = "DiagnosticWarn" })
		hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticInfo" })
		hl(0, "DiagnosticVirtualTextHint", { link = "DiagnosticHint" })
	end
end

return M
