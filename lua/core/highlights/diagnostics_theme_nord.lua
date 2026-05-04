-- **********************************************
-- * core/highlights/diagnostics_theme_nord.lua *
-- *                                            *
-- * Thème Nord pour les diagnostics            *
-- * Appel depuis core/lsp/on_attach.lua        *
-- **********************************************

local M = {}

M.setup = function()
	-- Configuration générale des diagnostics
	vim.diagnostic.config({
		signs = {
			active = true, -- active les signes
			values = {
				Error = { text = "●", texthl = "DiagnosticSignError" },
				Warn = { text = "●", texthl = "DiagnosticSignWarn" },
				Hint = { text = "●", texthl = "DiagnosticSignHint" },
				Info = { text = "●", texthl = "DiagnosticSignInfo" },
			},
		},
		virtual_text = {
			prefix = "●",
			spacing = 2,
		},
		underline = true,
		update_in_insert = false,
		severity_sort = true,
	})

	-- Couleurs et style basés sur Nord
	local hl = vim.api.nvim_set_hl

	-- Texte du diagnostic (virtual text)
	hl(0, "DiagnosticError", { fg = "#BF616A", bold = true })
	hl(0, "DiagnosticWarn", { fg = "#EBCB8B", bold = true })
	hl(0, "DiagnosticInfo", { fg = "#8FBCBB", bold = true })
	hl(0, "DiagnosticHint", { fg = "#81A1C1", italic = true })

	-- Soulignement doux (undercurl)
	hl(0, "DiagnosticUnderlineError", { sp = "#BF616A", undercurl = true })
	hl(0, "DiagnosticUnderlineWarn", { sp = "#EBCB8B", undercurl = true })
	hl(0, "DiagnosticUnderlineInfo", { sp = "#8FBCBB", undercurl = true })
	hl(0, "DiagnosticUnderlineHint", { sp = "#81A1C1", undercurl = true })

	-- Virtual text moins agressif
	hl(0, "DiagnosticVirtualTextError", { fg = "#BF616A" })
	hl(0, "DiagnosticVirtualTextWarn", { fg = "#EBCB8B" })
	hl(0, "DiagnosticVirtualTextInfo", { fg = "#8FBCBB" })
	hl(0, "DiagnosticVirtualTextHint", { fg = "#81A1C1", italic = true })
end

-- Auto-exécution si on veut juste require sans appeler setup
M.setup()

return M
