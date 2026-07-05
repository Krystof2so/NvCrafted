-- *************************************************************
-- * core/highlights/gitsigns_hl.lua                           *
-- *                                                           *
-- * Highlights adaptatifs pour gitsigns.nvim.                 *
-- * Couvre :                                                  *
-- *   - les signes de la gouttière (add/change/delete...)     *
-- *   - la prévisualisation de hunk (<leader>ghp)             *
-- *   - le blame de la ligne courante (<leader>ghb)           *
-- * Consomme core/highlights/themes/                          *
-- *                                                           *
-- * Délégation Rosé Pine : le plugin officiel définit déjà    *
-- * ses propres groupes Git (git_add, git_change, git_delete, *
-- * git_untracked, git_rename...) via son option `groups`,    *
-- * appliqués aux groupes natifs GitSigns* grâce à            *
-- * `enable.legacy_highlights`. Ce module ne fait donc rien   *
-- * pour cette famille — même logique que                     *
-- * core/highlights/diagnostics.lua.                          *
-- *                                                           *
-- * Appelé depuis core/highlights/init.lua                    *
-- *************************************************************

local M = {}

function M.setup()
	local themes = require("core.highlights.themes")
	local family = themes.current_family()

	-- Rosé Pine : délègue entièrement à la palette officielle du plugin
	if family == "rose_pine" then
		return
	end

	local p = themes.get()
	local hl = vim.api.nvim_set_hl

	-- ================================================================
	-- Signes de la gouttière (add / change / delete / changedelete /
	-- topdelete / untracked) 
	-- ================================================================
	hl(0, "GitSignsAdd", { fg = p.info.hex })
	hl(0, "GitSignsChange", { fg = p.warning.hex })
	hl(0, "GitSignsDelete", { fg = p.error.hex })
	hl(0, "GitSignsChangedelete", { fg = p.warning.hex })
	hl(0, "GitSignsTopdelete", { fg = p.error.hex })
	hl(0, "GitSignsUntracked", { fg = p.hint.hex })

	-- ================================================================
	-- Prévisualisation de hunk (popup ouvert par <leader>ghp)
	-- ================================================================
	hl(0, "GitSignsAddPreview", { fg = p.info.hex, bg = p.overlay.hex })
	hl(0, "GitSignsDeletePreview", { fg = p.error.hex, bg = p.overlay.hex })

	-- ================================================================
	-- Blame de la ligne courante (texte virtuel, <leader>ghb)
	-- ================================================================
	hl(0, "GitSignsCurrentLineBlame", { fg = p.muted.hex, italic = true })
end

return M
