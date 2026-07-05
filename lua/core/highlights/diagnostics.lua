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
local diagnostic = vim.diagnostic
local api = vim.api

local function apply_diagnostic_config()
	diagnostic.config({
		signs = {
			active = true,
			values = {
				Error = { text = "●", texthl = "DiagnosticSignError" },
				Warn = { text = "●", texthl = "DiagnosticSignWarn" },
				Hint = { text = "●", texthl = "DiagnosticSignHint" },
				Info = { text = "●", texthl = "DiagnosticSignInfo" },
			},
		},
		virtual_text = true,
		virtual_lines = { current_line = true },
		underline = true,
		update_in_insert = true,
		severity_sort = true,
	})
	local og_virt_text
	local og_virt_line
	-- Affichage des erreurs en mode arborescence sur la ligne courante en mode normal
	api.nvim_create_autocmd({ "CursorMoved", "DiagnosticChanged" }, {
		group = api.nvim_create_augroup("diagnostic_only_virtlines", { clear = true }),
		callback = function()
			if og_virt_line == nil then
				og_virt_line = diagnostic.config().virtual_lines
			end

			if not (og_virt_line and og_virt_line.current_line) then
				if og_virt_text then
					diagnostic.config({ virtual_text = og_virt_text })
					og_virt_text = nil
				end
				return
			end

			if og_virt_text == nil then
				og_virt_text = diagnostic.config().virtual_text
			end

			local lnum = api.nvim_win_get_cursor(0)[1] - 1

			if vim.tbl_isempty(diagnostic.get(0, { lnum = lnum })) then
				diagnostic.config({ virtual_text = og_virt_text })
			else
				diagnostic.config({ virtual_text = false })
			end
		end,
	})
end

function M.setup()
	apply_diagnostic_config()
	local themes = require("core.highlights.themes")
	local family = themes.current_family()
	local p = themes.get()
	local hl = vim.api.nvim_set_hl

	-- Rosé Pine : délègue à la palette officielle du plugin
	if family == "rose_pine" then
		hl(0, "DiagnosticVirtualTextError", { fg = nil })
		hl(0, "DiagnosticVirtualTextWarn", { fg = nil })
		hl(0, "DiagnosticVirtualTextInfo", { fg = nil })
		hl(0, "DiagnosticVirtualTextHint", { italic = true })
		return
	end

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
