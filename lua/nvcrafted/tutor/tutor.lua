-- =============================================================================
-- lua/plugins/tools/tutor.lua
-- Spec Lazy.nvim pour le tutoriel et la documentation NvCrafted
-- Chargement différé : uniquement à la première commande ou keymap
-- =============================================================================

return {
	dir = vim.fn.stdpath("config"),
	name = "nvcrafted-tutor",
	lazy = true,

	-- -------------------------------------------------------------------------
	-- Déclencheurs de chargement
	-- Clés autorisées par Lazy dans cette table :
	--   [1] = lhs, [2] = rhs/function, mode, desc, noremap, silent, expr, ft
	-- Tout autre champ (icon, group…) doit être déclaré dans config via wk.add()
	-- -------------------------------------------------------------------------

	cmd = {
		"NvCraftedTutor",
		"NvCraftedDocs",
		"NvCraftedReset",
	},

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

	-- -------------------------------------------------------------------------
	-- Configuration (exécutée une seule fois, au premier chargement)
	-- -------------------------------------------------------------------------

	config = function()
		-- Surcharge optionnelle de la config du tutoriel
		require("nvcrafted.tutor").setup({
			-- lessons_dir = vim.fn.stdpath("config") .. "/tutor/lessons",
			-- docs_dir    = vim.fn.stdpath("config") .. "/docs",
			-- width       = 90,
			keymaps = {
				next_lesson = "]l",
				prev_lesson = "[l",
				hint = "gh",
				goto_lesson = "gl",
				quit = "q",
			},
		})

		-- Commandes utilisateur
		vim.api.nvim_create_user_command("NvCraftedTutor", function()
			require("nvcrafted.tutor").open()
		end, { desc = "Ouvrir le tutoriel NvCrafted" })

		vim.api.nvim_create_user_command("NvCraftedDocs", function()
			require("nvcrafted.tutor.docs").open()
		end, { desc = "Ouvrir la documentation NvCrafted" })

		vim.api.nvim_create_user_command("NvCraftedReset", function()
			require("nvcrafted.tutor.progress").reset()
		end, { desc = "Réinitialiser la progression du tutoriel" })

		-- Icônes et groupe which-key déclarés ici, jamais dans la table keys Lazy
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
