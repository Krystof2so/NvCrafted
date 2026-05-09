-- *******************************************************************
-- * core/highlights/todo_comments.lua                               *
-- *                                                                 *
-- * Spécification de todo-comments.nvim pour NvCrafted.             *
-- * Consomme core/highlights/palettes.lua                           *
-- *                                                                 *
-- * Appelé depuis plugins/coding/todo_comments.lua                  *
-- *******************************************************************

local M = {}

function M.setup()
	local palettes = require("core.highlights.palettes")
	local p = palettes.get()

	require("todo-comments").setup({
		signs = true,
		sign_priority = 8,

		keywords = {
			FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
			TODO = { icon = " ", color = "info" },
			HACK = { icon = " ", color = "warning" },
			WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
			PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
			NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
			TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
		},

		gui_style = { fg = "NONE", bg = "BOLD" },
		merge_keywords = true,

		highlight = {
			multiline = true,
			multiline_pattern = "^.",
			multiline_context = 10,
			before = "",
			keyword = "wide",
			after = "fg",
			pattern = [[.*<(KEYWORDS)\s*:]],
			comments_only = true,
			max_line_len = 400,
			exclude = {},
		},

		-- Palette construite depuis la source de vérité
		colors = {
			error = { p.error.group, p.error.hex },
			warning = { p.warning.group, p.warning.hex },
			info = { p.info.group, p.info.hex },
			hint = { p.hint.group, p.hint.hex },
			default = { p.default.group, p.default.hex },
			test = { p.test.group, p.test.hex },
		},

		search = {
			command = "rg",
			args = {
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
			},
			pattern = [[\b(KEYWORDS):]],
		},
	})
end

return M
