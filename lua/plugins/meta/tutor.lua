-- =============================================================================
-- lua/plugins/meta/tutor.lua
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
			"<leader>ht",
			function()
				require("nvcrafted.tutor").open()
			end,
			desc = "Ouvrir le tutoriel",
			silent = true,
		},
		{
			"<leader>h]",
			function()
				require("nvcrafted.tutor").next_lesson()
			end,
			desc = "Leçon suivante du tutoriel",
			silent = true,
		},
		{
			"<leader>h[",
			function()
				require("nvcrafted.tutor").prev_lesson()
			end,
			desc = "Leçon précédente du tutoriel",
			silent = true,
		},
		{
			"<leader>hg",
			function()
				require("nvcrafted.tutor").goto_lesson()
			end,
			desc = "Aller à une leçon précise",
			silent = true,
		},
		{
			"<leader>hd",
			function()
				require("nvcrafted.tutor.docs").open()
			end,
			desc = "Accès à la documentation de NvCrafted",
			silent = true,
		},
		{
			"<leader>hR",
			function()
				require("nvcrafted.tutor.progress").reset()
			end,
			desc = "Réinitialiser les leçons (reset)",
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
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			once = true,
			callback = function()
				local ok, wk = pcall(require, "which-key")
				if not ok then
					return
				end
				wk.add({
					{ "<leader>ht", desc = "Ouvrir le tutoriel", icon = " " },
					{ "<leader>h]", desc = "Leçon suivante du tutoriel", icon = " " },
					{ "<leader>h[", desc = "Leçon précédente du tutoriel", icon = " " },
					{ "<leader>hg", desc = "Aller à une leçon précise du tutoriel", icon = "󰒭 " },
					{ "<leader>hd", desc = "Documentation de NvCrafted", icon = "󰈙 " },
					{ "<leader>hR", desc = "Réinitialiser les leçons (reset)", icon = "󰦛 " },
				})
			end,
		})
	end,
}
