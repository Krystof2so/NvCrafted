-- =============================================================================
-- lua/plugins/tools/tutor.lua
-- =============================================================================

return {
	dir = vim.fn.stdpath("config"),
	name = "nvcrafted-tutor",
	lazy = true,

	cmd = {
		"NvCraftedTutor",
		"NvCraftedDocs",
		"NvCraftedReset",
	},

	-- Lazy.nvim n'accepte que : [1]=lhs, [2]=rhs, mode, desc, noremap, silent, expr, ft
	-- Aucun "icon" ici, aucune entrée sans rhs
	keys = {
		{
			"<leader>Tt",
			function()
				require("nvcrafted.tutor").open()
			end,
			desc = "Ouvrir le tutoriel",
			silent = true,
		},
		{
			"<leader>T]",
			function()
				require("nvcrafted.tutor").next_lesson()
			end,
			desc = "Leçon suivante",
			silent = true,
		},
		{
			"<leader>T[",
			function()
				require("nvcrafted.tutor").prev_lesson()
			end,
			desc = "Leçon précédente",
			silent = true,
		},
		{
			"<leader>Tg",
			function()
				require("nvcrafted.tutor").goto_lesson()
			end,
			desc = "Aller à une leçon",
			silent = true,
		},
		{
			"<leader>Td",
			function()
				require("nvcrafted.tutor.docs").open()
			end,
			desc = "Documentation NvCrafted",
			silent = true,
		},
		{
			"<leader>TR",
			function()
				require("nvcrafted.tutor.progress").reset()
			end,
			desc = "Réinitialiser",
			silent = true,
		},
	},

	config = function()
		require("nvcrafted.tutor").setup({
			keymaps = {
				next_lesson = "]l",
				prev_lesson = "[l",
				hint = "gh",
				goto_lesson = "gl",
				quit = "q",
			},
		})

		vim.api.nvim_create_user_command("NvCraftedTutor", function()
			require("nvcrafted.tutor").open()
		end, { desc = "Ouvrir le tutoriel NvCrafted" })

		vim.api.nvim_create_user_command("NvCraftedDocs", function()
			require("nvcrafted.tutor.docs").open()
		end, { desc = "Ouvrir la documentation NvCrafted" })

		vim.api.nvim_create_user_command("NvCraftedReset", function()
			require("nvcrafted.tutor.progress").reset()
		end, { desc = "Réinitialiser la progression du tutoriel" })

		-- Icônes et groupe : uniquement ici, jamais dans la table keys Lazy
		local ok, wk = pcall(require, "which-key")
		if ok then
			wk.add({
				{ "<leader>T", group = "Tutoriel & Docs", icon = "󱞁 " },
				{ "<leader>Tt", desc = "Ouvrir le tutoriel", icon = " " },
				{ "<leader>T]", desc = "Leçon suivante", icon = " " },
				{ "<leader>T[", desc = "Leçon précédente", icon = " " },
				{ "<leader>Tg", desc = "Aller à une leçon", icon = "󰒭 " },
				{ "<leader>Td", desc = "Documentation NvCrafted", icon = "󰈙 " },
				{ "<leader>TR", desc = "Réinitialiser", icon = "󰦛 " },
			})
		end
	end,
}
