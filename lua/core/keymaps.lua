-- ***********************************************************************
-- * lua/core/keymaps.lua                                               *
-- *                                                                    *
-- * Mappings globaux de NvCrafted.                                     *
-- * Organisation par fonctionnalité, pas par plugin.                   *
-- *                                                                    *
-- * Groupes <leader> :                                                 *
-- *   <leader>h  →  Aide        (Help : Aide et documenatation)        *
-- *   <leader>c  →  Code        (LSP + annotations + commentaires)     *
-- *   <leader>b  →  Buffers     (navigation, fermeture, tri)           *
-- *   <leader>r  →  Recherche   (fichiers, grep, TODOs)                *
-- *   <leader>n  →  Navigation  (Neotree, Aerial, structure)           *
-- *   <leader>d  →  Diagnostics (Trouble, flottant, saut)              *
-- *   <leader>x  →  UI/UX       (thème, zen, hints global, hlsearch)   *
-- *   <leader>m  →  Messages    (Noice — historique, erreurs, stats)   *
-- *   <leader>p  →  Profil      (Lazy, Mason, Options)                 *
-- *                                                                    *
-- * Mappings buffer-local LSP : core/lsp/on_attach.lua                 *
-- * (nécessitent bufnr, définis à l'attachement LSP)                   *
-- *                                                                    *
-- * + Mapping généraux avec fonctionnalités spécifiques                *
-- **********************************************************************

vim.g.mapleader = " "
local map = vim.keymap.set

-- ======================================================================
-- Mapping généraux avec fonctionnalités spécifiques (hors which-key)
-- ======================================================================
-- Sélection complète du fichier
map("n", "<M-s>", "ggVG", {
	desc = "󰒉 Sélectionner tout le fichier",
	silent = true,
})

-- ======================================================================
-- <leader>h - Aide (<h>elp)
-- ======================================================================
map("n", "<leader>hm", ":Telescope keymaps<CR>", {
	desc = "󰌌 Explorer les raccourcis",
	silent = true,
})
map("n", "<leader>hh", ":Telescope help_tags<CR>", {
	desc = "󰋖 Aide Neovim",
	silent = true,
})
map("n", "<leader>hc", ":Telescope commands<CR>", {
	desc = "󰘳 Commandes disponibles",
	silent = true,
})

-- ======================================================================
-- <leader>c — Code
-- Actions sur le code : LSP, annotations, commentaires.
-- Les mappings LSP buffer-local (<leader>ca, cr, ci) sont dans
-- on_attach.lua car ils nécessitent bufnr. Ils apparaissent néanmoins
-- dans which-key grâce à leur enregistrement dans on_attach.
-- ======================================================================

-- Annotations (Neogen)
map("n", "<leader>cf", function()
	require("neogen").generate({ type = "func" })
end, { desc = "Annoter la fonction", silent = true })
map("n", "<leader>cc", function()
	require("neogen").generate({ type = "class" })
end, { desc = "Annoter la classe", silent = true })
map("n", "<leader>ct", function()
	require("neogen").generate({ type = "type" })
end, { desc = "Annoter le type", silent = true })
map("n", "<leader>cF", function()
	require("neogen").generate({ type = "file" })
end, { desc = "Annoter le fichier", silent = true })

-- ======================================================================
-- <leader>b — Buffers
-- ======================================================================

-- Navigation
map("n", "<leader>bn", ":BufferNext<CR>", { desc = "󰒭 Suivant", silent = true })
map("n", "<leader>bp", ":BufferPrevious<CR>", { desc = "󰒮 Précédent", silent = true })
map("n", "<leader>b0", ":BufferLast<CR>", { desc = "󰮱 Dernier buffer", silent = true })
map("n", "<leader>b1", ":BufferGoto 1<CR>", { desc = "Buffer 1", silent = true })
map("n", "<leader>b2", ":BufferGoto 2<CR>", { desc = "Buffer 2", silent = true })
map("n", "<leader>b3", ":BufferGoto 3<CR>", { desc = "Buffer 3", silent = true })
map("n", "<leader>b4", ":BufferGoto 4<CR>", { desc = "Buffer 4", silent = true })
map("n", "<leader>b5", ":BufferGoto 5<CR>", { desc = "Buffer 5", silent = true })
map("n", "<leader>b6", ":BufferGoto 6<CR>", { desc = "Buffer 6", silent = true })
map("n", "<leader>b7", ":BufferGoto 7<CR>", { desc = "Buffer 7", silent = true })
map("n", "<leader>b8", ":BufferGoto 8<CR>", { desc = "Buffer 8", silent = true })
map("n", "<leader>b9", ":BufferGoto 9<CR>", { desc = "Buffer 9", silent = true })
-- Fermeture
map("n", "<leader>bx", ":BufferClose<CR>", { desc = "󰅖 Fermer actuel", silent = true })
map("n", "<leader>ba", ":BufferCloseAllButCurrent<CR>", { desc = "󰅖 Fermer tous sauf actuel", silent = true })
map(
	"n",
	"<leader>bq",
	":BufferCloseAllButCurrentOrPinned<CR>",
	{ desc = "󰅖 Fermer sauf actuel/épinglés", silent = true }
)
map("n", "<leader>bQ", ":BufferCloseAllButPinned<CR>", { desc = "󰅖 Fermer sauf épinglés", silent = true })
map("n", "<leader>b<", ":BufferCloseBuffersLeft<CR>", { desc = "󰅘 Fermer à gauche", silent = true })
map("n", "<leader>b>", ":BufferCloseBuffersRight<CR>", { desc = "󰅙 Fermer à droite", silent = true })
-- Épinglage et tri
map("n", "<leader>bP", ":BufferPin<CR>", { desc = "󰐃 Épingler/désépingler", silent = true })
map("n", "<leader>bo", ":BufferOrderByName<CR>", { desc = "󰒺 Trier par nom", silent = true })
-- Liste
map("n", "<leader>bl", ":Telescope buffers<CR>", { desc = "󰈞 Liste (Telescope)", silent = true })

-- ======================================================================
-- <leader>r — Recherche
-- Recherche et exploration de fichiers et de contenu.
-- ======================================================================
map("n", "<leader>rf", ":Telescope find_files<CR>", {
	desc = "󰈞 Chercher un fichier",
	silent = true,
})
map("n", "<leader>rg", ":Telescope live_grep<CR>", {
	desc = "󰊄 Rechercher du texte (grep)",
	silent = true,
})
map("n", "<leader>rr", ":Telescope oldfiles<CR>", {
	desc = "󰋚 Fichiers récents",
	silent = true,
})
map("n", "<leader>rt", function()
	vim.cmd("TodoTelescope cwd=" .. vim.fn.getcwd())
end, { desc = "󰄲 Rechercher TODOs/FIX/BUG", silent = true })

-- ======================================================================
-- <leader>n — Navigation
-- Déplacement dans la structure du projet et du code.
-- ======================================================================

-- Neotree
map("n", "<leader>ne", ":Neotree<CR>", { desc = "󰙅 Ouvrir Neotree", silent = true })
map("n", "<leader>nb", ":Neotree focus buffers float<CR>", {
	desc = "󰈞 Buffers ouverts (Neotree)",
	silent = true,
})
map("n", "<leader>ng", ":Neotree focus git_status float<CR>", {
	desc = "󰊢 Git status (Neotree)",
	silent = true,
})
-- Aerial (structure du fichier courant)
map("n", "<leader>na", ":AerialOpen<CR>", {
	desc = "󱘎 Structure du fichier (Aerial)",
	silent = true,
})

-- ======================================================================
-- <leader>d — Diagnostics
-- Les mappings buffer-local (flottant, suivant, précédent) sont dans
-- on_attach.lua. Seuls les mappings globaux sont ici.
-- ======================================================================
map("n", "<leader>dl", "<cmd>Trouble diagnostics<CR>", {
	desc = "󰋼 Liste globale (Trouble)",
	silent = true,
})
map("n", "<leader>ds", "<cmd>Trouble preview_split<CR>", {
	desc = "󰋼 Liste avec aperçu (Trouble)",
	silent = true,
})

-- ======================================================================
-- <leader>x — UI/UX
-- Tout ce qui modifie l'apparence ou le comportement de l'éditeur.
-- ======================================================================
map("n", "<leader>xt", function()
	require("core.theme").preview_with_telescope()
end, { desc = "󰏘 Changer de thème", silent = true })
map("n", "<leader>xz", ":ZenMode<CR>", { desc = "󰰶 Toggle Zen Mode", silent = true })
map("n", "<leader>xh", ":nohlsearch<CR>", {
	desc = "󰹊 Effacer la surbrillance",
	silent = true,
})
map("n", "<leader>xa", function()
	require("core.map_actions.open_alpha").open()
end, { desc = "󰋜 Retour à l'écran d'accueil", silent = true })

-- ======================================================================
-- <leader>m — Messages (Noice)
-- Accès à l'historique et aux outils de notification.
-- ======================================================================
map("n", "<leader>mh", ":NoiceHistory<CR>", {
	desc = "󰋚 Historique des messages",
	silent = true,
})
map("n", "<leader>ml", ":NoiceLast<CR>", {
	desc = "󰍩 Dernier message",
	silent = true,
})
map("n", "<leader>me", ":NoiceErrors<CR>", {
	desc = "󰅚 Messages d'erreur",
	silent = true,
})
map("n", "<leader>ms", ":NoiceStats<CR>", {
	desc = "󰄴 Statistiques de débogage",
	silent = true,
})
map("n", "<leader>mt", ":NoiceTelescope<CR>", {
	desc = "󰭎 Historique dans Telescope",
	silent = true,
})
map("n", "<leader>mc", ":NoiceDismiss<CR>", {
	desc = "󰅙 Fermer les notifications",
	silent = true,
})
map("n", "<leader>md", ":NoiceDisable<CR>", {
	desc = "󰒲 Désactiver Noice",
	silent = true,
})
map("n", "<leader>ma", ":NoiceEnable<CR>", {
	desc = "󰒳 Réactiver Noice",
	silent = true,
})

-- ======================================================================
-- <leader>p — Profil
-- ======================================================================
map("n", "<leader>pi", function()
	require("core.map_actions.system_info").open()
end, { desc = " Informations système", silent = true })
map("n", "<leader>po", ":Telescope vim_options<CR>", {
	desc = "󰒓 Options Neovim",
	silent = true,
})
map("n", "<leader>pl", ":Lazy<CR>", { desc = "󰒲 Ouvrir Lazy", silent = true })
map("n", "<leader>pu", ":Lazy update<CR>", {
	desc = "󰒿 Mettre à jour les plugins",
	silent = true,
})
map("n", "<leader>ps", ":Lazy sync<CR>", {
	desc = "󰓦 Synchroniser",
	silent = true,
})

-- ======================================================================
-- Which-key — Déclaration des groupes et descriptions
-- ======================================================================
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	once = true,
	callback = function()
		local ok, wk = pcall(require, "which-key")
		if not ok then
			return
		end

		wk.add({

			-- ----------------------------------------------------------------
			-- Groupes de premier niveau
			-- ----------------------------------------------------------------
			{ "<leader>h", group = "Aide et documentation ", icon = "󰋖 " },
			{ "<leader>c", group = "Actions sur le code", icon = "󰅩 " },
			{ "<leader>b", group = "Buffers", icon = "󰈞 " },
			{ "<leader>r", group = "Rechercher", icon = "󰈔 " },
			{ "<leader>n", group = "Navigation", icon = "󰋜 " },
			{ "<leader>d", group = "Diagnostics", icon = "󰋼 " },
			{ "<leader>x", group = "UI/UX", icon = "󰏘 " },
			{ "<leader>m", group = "Messages", icon = "󰍩 " },
			{ "<leader>p", group = "Profil", icon = "󰒓 " },

			-- ----------------------------------------------------------------
			-- <leader>h — Aide
			-- ----------------------------------------------------------------
			{ "<leader>hm", desc = "Explorer les raccourcis", icon = "󰌌 " },
			{ "<leader>hh", desc = "Aide Neovim", icon = "󰋖 " },
			{ "<leader>hc", desc = "Commandes disponibles", icon = "󰘳 " },

			-- ----------------------------------------------------------------
			-- <leader>c — Code
			-- Les mappings LSP (ca, cr, ci) sont enregistrés dans on_attach
			-- avec buffer=bufnr. Which-key les fusionne automatiquement ici.
			-- ----------------------------------------------------------------
			{ "<leader>cf", desc = "Annoter la fonction", icon = " " },
			{ "<leader>cc", desc = "Annoter la classe", icon = " " },
			{ "<leader>ct", desc = "Annoter le type", icon = " " },
			{ "<leader>cF", desc = "Annoter le fichier", icon = " " },

			-- ----------------------------------------------------------------
			-- <leader>b — Buffers
			-- ----------------------------------------------------------------
			{ "<leader>bn", desc = "Suivant", icon = "󰒭 " },
			{ "<leader>bp", desc = "Précédent", icon = "󰒮 " },
			{ "<leader>b0", desc = "Dernier buffer", icon = "󰮱 " },
			{ "<leader>bx", desc = "Fermer actuel", icon = "󰅖 " },
			{ "<leader>ba", desc = "Fermer tous sauf actuel", icon = "󰅖 " },
			{ "<leader>bq", desc = "Fermer sauf actuel/épinglés", icon = "󰅖 " },
			{ "<leader>bQ", desc = "Fermer sauf épinglés", icon = "󰅖 " },
			{ "<leader>b<", desc = "Fermer à gauche", icon = "󰅘 " },
			{ "<leader>b>", desc = "Fermer à droite", icon = "󰅙 " },
			{ "<leader>bP", desc = "Épingler/désépingler", icon = "󰐃 " },
			{ "<leader>bo", desc = "Trier par nom", icon = "󰒺 " },
			{ "<leader>bl", desc = "Liste (Telescope)", icon = "󰈞 " },

			-- ----------------------------------------------------------------
			-- <leader>r — Rechercher
			-- ----------------------------------------------------------------
			{ "<leader>rf", desc = "Chercher un fichier", icon = "󰈞 " },
			{ "<leader>rg", desc = "Rechercher du texte (grep)", icon = "󰊄 " },
			{ "<leader>rr", desc = "Fichiers récents", icon = "󰋚 " },
			{ "<leader>rt", desc = "Rechercher TODOs/FIX/BUG", icon = "󰄲 " },

			-- ----------------------------------------------------------------
			-- <leader>n — Navigation
			-- ----------------------------------------------------------------
			{ "<leader>ne", desc = "Ouvrir Neotree", icon = "󰙅 " },
			{ "<leader>nb", desc = "Buffers ouverts (Neotree)", icon = "󰈞 " },
			{ "<leader>ng", desc = "Git status (Neotree)", icon = "󰊢 " },
			{ "<leader>na", desc = "Structure du fichier (Aerial)", icon = "󱘎 " },

			-- ----------------------------------------------------------------
			-- <leader>d — Diagnostics (globaux)
			-- Les mappings buffer-local (dd, dn, dp) sont dans on_attach.
			-- ----------------------------------------------------------------
			{ "<leader>dl", desc = "Liste globale (Trouble)", icon = "󰋼 " },
			{ "<leader>ds", desc = "Liste avec aperçu (Trouble)", icon = "󰋼 " },

			-- ----------------------------------------------------------------
			-- <leader>x — UI/UX
			-- ----------------------------------------------------------------
			{ "<leader>xa", desc = "Retour au menu principal (ferme les buffers)", icon = "󰋜 " },
			{ "<leader>xt", desc = "Changer de thème", icon = "󰏘 " },
			{ "<leader>xz", desc = "Toggle Zen Mode", icon = "󰰶 " },
			{ "<leader>xh", desc = "Effacer la surbrillance", icon = "󰹊 " },

			-- ----------------------------------------------------------------
			-- <leader>m — Messages
			-- ----------------------------------------------------------------
			{ "<leader>mh", desc = "Historique des messages", icon = "󰋚 " },
			{ "<leader>ml", desc = "Dernier message", icon = "󰍩 " },
			{ "<leader>me", desc = "Messages d'erreur", icon = "󰅚 " },
			{ "<leader>ms", desc = "Statistiques de débogage", icon = "󰄴 " },
			{ "<leader>mt", desc = "Historique dans Telescope", icon = "󰭎 " },
			{ "<leader>mc", desc = "Fermer les notifications", icon = "󰅙 " },
			{ "<leader>md", desc = "Désactiver Noice", icon = "󰒲 " },
			{ "<leader>ma", desc = "Réactiver Noice", icon = "󰒳 " },

			-- ----------------------------------------------------------------
			-- <leader>p — Profil
			-- ----------------------------------------------------------------
			{ "<leader>pi", desc = "Informations NvCrafted", icon = "󰋼 " },
			{ "<leader>pl", desc = "Ouvrir Lazy", icon = "󰒲 " },
			{ "<leader>pu", desc = "Mettre à jour les plugins", icon = "󰒿 " },
			{ "<leader>ps", desc = "Synchroniser", icon = "󰓦 " },
			{ "<leader>po", desc = "Options Neovim", icon = "󰒓 " },
		}, { prefix = "<leader>", mode = "n" })
	end,
})
