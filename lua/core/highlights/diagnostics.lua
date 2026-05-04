-- ************************************************************
-- * core/highlights/diagnostics.lua                          *
-- *                                                          *
-- * Highlights de diagnostics adaptatifs au thème courant.   *
-- * Appelé depuis :                                          *
-- *   - core/lsp/on_attach.lua  (attachement LSP)            *
-- *   - core/theme.lua          (changement de thème)        *
-- *                                                          *
-- * Stratégie :                                              *
-- *   • Rosé Pine (main / moon / dawn) :                     *
-- *     utilise la palette officielle via highlight_groups   *
-- *     → les couleurs sont déjà définies par le plugin,     *
-- *     on ajuste uniquement le virtual text et les signes.  *
-- *   • Nordic :                                             *
-- *     palette Nord (#BF616A, #EBCB8B, #8FBCBB, #81A1C1)   *
-- *   • Evergarden :                                         *
-- *     palette Everforest-like adaptée                      *
-- *   • Tout autre thème :                                   *
-- *     fallback neutre sur les couleurs de diagnostic       *
-- *     natives de Neovim                                    *
-- ************************************************************

local M = {}

local hl = vim.api.nvim_set_hl

-- ----------------------------------------------------------------
-- Détecte la famille du thème actif
-- ----------------------------------------------------------------
local function current_theme_family()
	local name = vim.g.colors_name or ""
	if name:find("^rose%-pine") then
		return "rose-pine"
	elseif name == "nordic" then
		return "nordic"
	elseif name == "evergarden" then
		return "evergarden"
	else
		return "default"
	end
end

-- ----------------------------------------------------------------
-- Configuration générale vim.diagnostic (commune à tous les thèmes)
-- ----------------------------------------------------------------
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
		virtual_text = {
			prefix = "●",
			spacing = 2,
		},
		underline = true,
		update_in_insert = false,
		severity_sort = true,
	})
end

-- ----------------------------------------------------------------
-- Rosé Pine — délègue à la palette officielle du plugin.
-- Le plugin définit déjà DiagnosticError/Warn/Info/Hint via
-- groups.error / warn / info / hint.
-- On s'assure juste que le virtual text reste discret (no bold).
-- ----------------------------------------------------------------
local function highlights_rose_pine()
	hl(0, "DiagnosticVirtualTextError", { fg = nil })
	hl(0, "DiagnosticVirtualTextWarn", { fg = nil })
	hl(0, "DiagnosticVirtualTextInfo", { fg = nil })
	hl(0, "DiagnosticVirtualTextHint", { italic = true })
end

-- ----------------------------------------------------------------
-- Nordic — palette Nord
-- ----------------------------------------------------------------
local function highlights_nordic()
	-- Texte du diagnostic
	hl(0, "DiagnosticError", { fg = "#BF616A", bold = true })
	hl(0, "DiagnosticWarn", { fg = "#EBCB8B", bold = true })
	hl(0, "DiagnosticInfo", { fg = "#8FBCBB", bold = true })
	hl(0, "DiagnosticHint", { fg = "#81A1C1", italic = true })

	-- Soulignement (undercurl)
	hl(0, "DiagnosticUnderlineError", { sp = "#BF616A", undercurl = true })
	hl(0, "DiagnosticUnderlineWarn", { sp = "#EBCB8B", undercurl = true })
	hl(0, "DiagnosticUnderlineInfo", { sp = "#8FBCBB", undercurl = true })
	hl(0, "DiagnosticUnderlineHint", { sp = "#81A1C1", undercurl = true })

	-- Virtual text (discret, sans gras)
	hl(0, "DiagnosticVirtualTextError", { fg = "#BF616A" })
	hl(0, "DiagnosticVirtualTextWarn", { fg = "#EBCB8B" })
	hl(0, "DiagnosticVirtualTextInfo", { fg = "#8FBCBB" })
	hl(0, "DiagnosticVirtualTextHint", { fg = "#81A1C1", italic = true })
end

-- ----------------------------------------------------------------
-- Evergarden — palette Everforest adaptée
-- ----------------------------------------------------------------
local function highlights_evergarden()
	-- Texte du diagnostic
	hl(0, "DiagnosticError", { fg = "#e67e80", bold = true })
	hl(0, "DiagnosticWarn", { fg = "#dbbc7f", bold = true })
	hl(0, "DiagnosticInfo", { fg = "#7fbbb3", bold = true })
	hl(0, "DiagnosticHint", { fg = "#a7c080", italic = true })

	-- Soulignement (undercurl)
	hl(0, "DiagnosticUnderlineError", { sp = "#e67e80", undercurl = true })
	hl(0, "DiagnosticUnderlineWarn", { sp = "#dbbc7f", undercurl = true })
	hl(0, "DiagnosticUnderlineInfo", { sp = "#7fbbb3", undercurl = true })
	hl(0, "DiagnosticUnderlineHint", { sp = "#a7c080", undercurl = true })

	-- Virtual text (discret, sans gras)
	hl(0, "DiagnosticVirtualTextError", { fg = "#e67e80" })
	hl(0, "DiagnosticVirtualTextWarn", { fg = "#dbbc7f" })
	hl(0, "DiagnosticVirtualTextInfo", { fg = "#7fbbb3" })
	hl(0, "DiagnosticVirtualTextHint", { fg = "#a7c080", italic = true })
end

-- ----------------------------------------------------------------
-- Fallback — laisse Neovim gérer avec ses valeurs par défaut.
-- On réinitialise via link pour éviter des restes d'un thème
-- précédent.
-- ----------------------------------------------------------------
local function highlights_default()
	hl(0, "DiagnosticVirtualTextError", { link = "DiagnosticError" })
	hl(0, "DiagnosticVirtualTextWarn", { link = "DiagnosticWarn" })
	hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticInfo" })
	hl(0, "DiagnosticVirtualTextHint", { link = "DiagnosticHint" })
end

-- ----------------------------------------------------------------
-- Point d'entrée public
-- ----------------------------------------------------------------
function M.setup()
	apply_diagnostic_config()

	local family = current_theme_family()

	if family == "rose-pine" then
		highlights_rose_pine()
	elseif family == "nordic" then
		highlights_nordic()
	elseif family == "evergarden" then
		highlights_evergarden()
	else
		highlights_default()
	end
end

M.setup()

return M
