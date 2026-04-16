-- ************************
-- * lua/core/keymaps.lua *
-- ************************

vim.g.mapleader = " "
local map = vim.keymap.set

-- **************
-- * Raccourcis *
-- **************

-- Raccourcis utilitaires
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Suppression surlignage recherche" })
map("n", "<leader>t", function()
	require("core.theme").preview_with_telescope()
end, { desc = "Sélectionner un thème" })

-- Gestion des buffers
map("n", "<leader>b", "", { desc = " Buffers" })
map("n", "<leader>bn", ":bnext<CR>", { desc = "Buffer suivant" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Buffer précédent" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Fermer buffer actuel" })
map("n", "<leader>bl", ":Telescope buffers<CR>", { desc = "Liste des buffers" })

-- aerial
map("n", "<leader>a", "", { desc = "Aerial" })
map("n", "<leader>ao", ":AerialOpen<CR>", { desc = "Ouvre Aerial" })

-- Lazy.nvim
map("n", "<leader>l", "", { desc = " Lazy" }) -- mapping “vide” juste pour le groupe
map("n", "<leader>ll", ":Lazy<CR>", { desc = "Ouverture de Lazy" })
map("n", "<leader>lu", ":Lazy update<CR>", { desc = "Lazy update" })
map("n", "<leader>ls", ":Lazy sync<CR>", { desc = "Lazy sync" })

-- Neotree
map("n", "<leader>e", "", { desc = " Neotree" })
map("n", "<leader>ee", ":Neotree<CR>", { desc = "Ouverture de Neotree" })
map("n", "<leader>eb", ":Neotree focus buffers float<CR>", { desc = "Liste des buffers ouverts" })
map("n", "<leader>eg", ":Neotree focus git_status float<CR>", { desc = "Liste des buffers modifiés (Git status)" })

-- Noice
map("n", "<leader>n", "", { desc = "Noice" })
map("n", "<leader>nd", ":NoiceDisable<CR>", { desc = "Désactive Noice" })
map("n", "<leader>nc", ":NoiceDismiss<CR>", { desc = "Ferme tous les messages visibles" })
map("n", "<leader>na", ":NoiceEnable<CR>", { desc = "Réactive Noice" })
map("n", "<leader>ne", ":NoiceErrors<CR>", { desc = "Affichage des messages d'erreurs" })
map("n", "<leader>nh", ":NoiceHistory<CR>", { desc = "Historique des messages notifiés" })
map("n", "<leader>nl", ":NoiceLast<CR>", { desc = "Dernier message notifié" })
map("n", "<leader>ns", ":NoiceStats<CR>", { desc = "Affiche des statistiques de débogage" })
map("n", "<Leader>nt", ":NoiceTelescope<CR>", { desc = "Ouvre l'historique dans Telescope" })

-- Telescope
map("n", "<leader>f", "", { desc = "Telescope" })
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Chercher fichiers" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Rechercher texte au niveau du projet" })
map("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Aide Neovim" })
map("n", "<leader>fk", ":Telescope keymaps<CR>", { desc = "Keymaps" })
map("n", "<leader>fc", ":Telescope commands<CR>", { desc = "Commandes" })
map("n", "<leader>fo", ":Telescope vim_options<CR>", { desc = "Options Neovim" })

-- Trouble
map("n", "<leader>d", "", { desc = " Diagnostics" })
map("n", "<leader>ds", "<cmd>Trouble preview_split<CR>", { desc = "Trouble avec split" })
map("n", "<leader>dd", "<cmd>Trouble diagnostics<CR>", { desc = "Trouble sans split" })

-- *************************************
-- * Groupe de mappings pour Which-key *
-- *************************************

local ok, wk = pcall(require, "which-key")
if ok then
	wk.add({
		a = { name = "Aerial" },
		b = { name = "Buffers" },
		d = { name = "Diagnostics" },
		e = { name = "Neotree" },
		f = { name = "Telescope" },
		l = { name = "Lazy" },
		n = { name = "Noice" },
	}, { prefix = "<leader>", mode = "n" })
end
