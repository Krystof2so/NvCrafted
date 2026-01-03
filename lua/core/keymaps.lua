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

-- Gestion des buffers
map("n", "<leader>b", "", { desc = " Buffers" })
map("n", "<leader>bf", "", { desc = "Formatage "})
map("n", "<leader>bn", ":bnext<CR>", { desc = "Buffer suivant" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Buffer précédent" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Fermer buffer actuel" })
map("n", "<leader>bl", ":Telescope buffers<CR>", { desc = "Liste des buffers" })

-- Telescope
map("n", "<leader>f", "", { desc = "Telescope"})
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Chercher fichiers" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Rechercher texte au niveau du projet" })
map("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Aide Neovim" })
map("n", "<leader>fk", ":Telescope keymaps<CR>", { desc = "Keymaps" })
map("n", "<leader>fc", ":Telescope commands<CR>", { desc = "Commandes" })
map("n", "<leader>fo", ":Telescope vim_options<CR>", { desc = "Options Neovim" })

-- Lazy.nvim 
map("n", "<leader>l", "", { desc = " Lazy" }) -- mapping “vide” juste pour le groupe
map("n", "<leader>ll", ":Lazy<CR>", { desc = "Ouverture de Lazy" })
map("n", "<leader>lu", ":Lazy update<CR>", { desc = "Lazy update" })
map("n", "<leader>ls", ":Lazy sync<CR>", { desc = "Lazy sync" })

-- Neotree
map("n", "<leader>e", "", { desc = " Neotree" })
map("n", "<leader>ee", ":Neotree<CR>", { desc = "Ouverture de Neotree" })
map("n", "<leader>eb", ":Neotree buffers<CR>", {desc = "Liste des buffers ouverts" })

-- Trouble
map("n", "<leader>d", "", {desc = " Diagnostics"})
map("n", "<leader>ds", "<cmd>Trouble preview_split<CR>", { desc = "Trouble avec split" })
map("n", "<leader>dd", "<cmd>Trouble diagnostics<CR>", { desc = "Trouble sans split" })


-- ************************* 
-- * Formatage des buffers *
-- *************************
--
-- Mapping : save + format Python avec Black
map("n", "<leader>bfp", function()
  if vim.bo.filetype ~= "python" then
    print("Ce mapping ne fonctionne que pour les fichiers Python")
    return
  end
  local filepath = vim.fn.expand("%:p") -- chemin complet du fichier
  vim.cmd("write")  -- Sauvegarde du fichier
  vim.fn.system(string.format("~/.local/share/nvim/mason/bin/black %q", filepath))  -- Exécute Black
  vim.cmd("edit!")  -- recharge le buffer pour appliquer les changements
  print("Black exécuté sur " .. filepath)
end, { desc = "Save + format Python avec Black" })


-- *************************************
-- * Groupe de mappings pour Which-key *
-- *************************************

local ok, wk = pcall(require, "which-key")
if ok then
  wk.add({
    b = { name = "Buffers" },
    d = { name = "Diagnostics" },
    e = { name = "Neotree" },
    f = { name = "Telescope" },
    l = { name = "Lazy" },
  }, { prefix = "<leader>", mode = "n" })
end

