local M = {}

M.available = {
	"evergarden",
	"nordic",
	"thorn",
	"tokyonight",
}

M.default = "nordic"

function M.apply(theme)
	vim.cmd.colorscheme(theme)
end

function M.preview_with_telescope()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local current_theme = vim.g.colors_name

	pickers
		.new({}, {
			prompt_title = "Select Theme",

			finder = finders.new_table({
				results = M.available,
			}),

			sorter = conf.generic_sorter({}),

			attach_mappings = function(prompt_bufnr, map)
				local function preview_theme()
					local entry = action_state.get_selected_entry()
					if entry then
						M.apply(entry[1])
					end
				end

				map("i", "<C-n>", preview_theme)
				map("i", "<C-p>", preview_theme)
				map("n", "j", preview_theme)
				map("n", "k", preview_theme)

				actions.select_default:replace(function()
					local entry = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					if entry then
						M.apply(entry[1])
					end
				end)

				return true
			end,
		})
		:find()
	-- restore si fermeture sans sélection
	vim.schedule(function()
		vim.cmd.colorscheme(current_theme)
	end)
end

return M
