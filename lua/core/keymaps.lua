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
map("n", "<leader>z", ":ZenMode<CR>", { desc = "Toggle Zen Mode" })

-- Gestion des buffers
map("n", "<leader>b", "", { desc = " Buffers" })
-- Navigation entre buffers
map("n", "<leader>bn", ":BufferNext<CR>", { desc = "Buffer suivant" })
map("n", "<leader>bp", ":BufferPrevious<CR>", { desc = "Buffer précédent" })
map("n", "<leader>b0", ":BufferLast<CR>", { desc = "Dernier buffer" })
map("n", "<leader>b1", ":BufferGoto 1<CR>", { desc = "Buffer N°1" })
map("n", "<leader>b2", ":BufferGoto 2<CR>", { desc = "Buffer N°2" })
map("n", "<leader>b3", ":BufferGoto 3<CR>", { desc = "Buffer N°3" })
map("n", "<leader>b4", ":BufferGoto 4<CR>", { desc = "Buffer N°4" })
map("n", "<leader>b5", ":BufferGoto 5<CR>", { desc = "Buffer N°5" })
map("n", "<leader>b6", ":BufferGoto 6<CR>", { desc = "Buffer N°6" })
map("n", "<leader>b7", ":BufferGoto 7<CR>", { desc = "Buffer N°7" })
map("n", "<leader>b8", ":BufferGoto 8<CR>", { desc = "Buffer N°8" })
map("n", "<leader>b9", ":BufferGoto 9<CR>", { desc = "Buffer N°9" })
-- Fermeture de buffers
map("n", "<leader>bc", "", { desc = "Fermeture de buffer(s)" })
map("n", "<leader>bca", ":BufferCloseAllButCurrent<CR>", { desc = "Fermer tous SAUF actuel" })
map("n", "<leader>bcc", ":BufferClose<CR>", { desc = "Fermer buffer actuel" })
map("n", "<leader>bcp", ":BufferCloseAllButCurrentOrPinned<CR>", { desc = "Fermer tous SAUF actuel/épinglés" })
map("n", "<leader>bcP", ":BufferCloseAllButPinned<CR>", { desc = "Fermer tous SAUF épinglés" })
map("n", "<leader>bcl", ":BufferCloseBuffersLeft<CR>", { desc = "Fermer buffers à GAUCHE" })
map("n", "<leader>bcr", ":BufferCloseBuffersRight<CR>", { desc = "Fermer buffers à DROITE" })
-- Épinglage et tri
map("n", "<leader>bP", ":BufferPin<CR>", { desc = "Épingler/désépingler buffer" })
map("n", "<leader>bo", ":BufferOrderByName<CR>", { desc = "Trier buffers par nom" })
-- Liste des buffers (Telescope)
map("n", "<leader>bl", ":Telescope buffers<CR>", { desc = "Liste des buffers (Telescope)" })

-- aerial
map("n", "<leader>a", "", { desc = "Aerial" })
map("n", "<leader>ao", ":AerialOpen<CR>", { desc = "Ouvre Aerial" })

-- Lazy.nvim
map("n", "<leader>l", "", { desc = " Lazy" }) -- mapping “vide” juste pour le groupe
map("n", "<leader>ll", ":Lazy<CR>", { desc = "Ouverture de Lazy" })
map("n", "<leader>lu", ":Lazy update<CR>", { desc = "Lazy update" })
map("n", "<leader>ls", ":Lazy sync<CR>", { desc = "Lazy sync" })

-- TODO: Neogen

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
map("n", "<leader>ft", ":TodoTelescope cwd=" .. vim.fn.getcwd() .. "<CR>", { desc = "Recherche les TODOs" })

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
