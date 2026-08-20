-- *********************************
-- * lua/core/options.lua          *
-- *                               *
-- * Options générales pour Neovim *
-- *********************************
--
local opt = vim.opt

-- ***************************
-- * 1. Comportement général *
-- ***************************
opt.colorcolumn = "120" -- str : Afficher la colonne pour la longueur maximale de ligne
opt.number = true -- bool : Afficher les numéros de ligne
opt.relativenumber = true -- bool : Afficher les numéros de ligne relatifs
opt.numberwidth = 4 -- int : Largeur de la colonne des numéros de ligne
opt.scrolloff = 8 -- int: Nombre minimum de lignes affichés sous le curseur
opt.sidescrolloff = 8 -- int: Espace minimal pour le scroll horizontal
opt.smoothscroll = true -- bool : fluidité du défilement
opt.signcolumn = "auto" -- str: Afficher la colonne des signes si des signes sont à afficher
opt.cursorline = true -- bool : Mettre en surbrillance la ligne du curseur
opt.updatetime = 300 -- int: Temps en millisecondes avant que le CursorHold s'active (LSP/diagnostics)
opt.history = 1000 -- int : Nombre de commandes dans l'historique
opt.helplang = "fr,en" -- str : Langues de l'aide intégrée

-- ------------------------------------------------------------------------------------
-- Créer le répertoire pour l'undo persistant : mkdir -p ~/.local/share/nvim/undo
-- La valeur pointe vers un répertoire qui doit exister avant que Neovim ne l'utilise.
-- Si le répertoire est absent, undofile échoue silencieusement.
-- Il faut ajouter la création automatique :
local undodir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end
opt.undofile = true -- bool : Activer l'undo persistant
opt.undodir = undodir -- Répertoire pour undo persistants
-- -------------------------------------------------------------------------------------

opt.hidden = true -- bool : changement de buffers sans sauvegarder
opt.confirm = true -- bool : Plutôt que d'échouer silencieusement sur :q avec des modifications non sauvegardées, Neovim demande confirmation

-- *****************
-- * 2. Complétion *
-- *****************
opt.completeopt = { "menu", "menuone", "noselect" } -- table{str} : pour LSP/completion

-- ************************
-- * 3. Types de fichiers *
-- ************************
opt.encoding = "utf8" -- str : Encodage des chaînes à utiliser
opt.fileencoding = "utf8" -- str : Encodage des fichiers à utiliser

-- *******************************
-- * 4. Gestion de la sauvegarde *
-- *******************************
opt.backup = false -- bool : Désactive les fichiers de sauvegarde
opt.writebackup = false -- bool : Désactive la création de backups avant l'écriture d'un fichier
opt.swapfile = false -- bool : Désactive les fichiers d'échange (swap)

-- ************
-- * 5. Thème *
-- ************
-- ------------------------------------------------------------------------------------
-- Conditionné à la capacité du terminal
if vim.fn.has("termguicolors") == 1 then
	opt.termguicolors = true -- bool : Activer si le terminal supporte les couleurs UI
end
-- ------------------------------------------------------------------------------------
opt.guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25-CursorIM,r-cr:hor20-Cursor" -- Apparence curseur selon le thème

-- *********************************
-- * 6. Navigation dans le fichier *
-- *********************************
opt.jumpoptions = "view" -- str : Continuité visuelle lors des sauts

-- ****************
-- * 7. Recherche *
-- ****************
opt.ignorecase = true -- bool : Ignorer la casse dans les motifs de recherche
opt.smartcase = true -- bool : Outrepasser ignorecase si la recherche contient des majuscules
opt.hlsearch = true -- bool : Mettre en surbrillance les correspondances de recherche
opt.gdefault = true -- bool : Remplacement d'une occurrence sur la ligne

-- *********************
-- * 8. Espaces blancs *
-- *********************
opt.expandtab = true -- bool : Utiliser des espaces au lieu des tabulations
opt.shiftwidth = 4 -- num : Taille d'une indentation
opt.softtabstop = 4 -- num : Nombre d'espaces qu'une tabulation représente en mode insertion
opt.tabstop = 4 -- num : Nombre d'espaces qu'une tabulation représente

-- *********
-- * 9. UI *
-- *********
opt.showmode = false -- bool : Désactiver le mode "INSERT" affiché (redondant avec un statusline)
opt.showtabline = 2 -- int : 2 -> Toujours afficher la tabline
opt.showcmd = true -- bool : Montre la commande en bas à gauche
opt.cmdheight = 0 -- int : Hauteur de la ligne de commande (inutile avec noice.nvim)
opt.pumheight = 15 -- int : Hauteur du popup menu
opt.pumblend = 20 -- int : Taux de transprence du popup
opt.laststatus = 3 -- int : Afficher une ligne de statut unique
opt.timeoutlen = 300 -- int :  durée d'attente en ms pour les séquences de touches (par défaut 1000ms). Avec which-key, une valeur plus courte améliore la réactivité de l'affichage du popup
opt.splitkeep = "screen" -- str : Stabilise le curseur dans les splits lors des redimensionnements
opt.virtualedit = "block" -- str : Permet au curseur de se déplacer là où il n'y a pas de caractère (utile en mode visuel bloc)

-- *************************
-- * 10. Fenêtres divisées *
-- *************************
opt.splitright = true -- bool : Placer la nouvelle fenêtre à droite de l'actuelle
opt.splitbelow = true -- bool : Placer la nouvelle fenêtre en dessous de l'actuelle
opt.equalalways = true -- bool : Rééquilibrage des splits quand on les redéfinit

-- *******************************
-- * 11. Souris et Presse-papier *
-- *******************************
opt.mouse = "a" -- str : Activer la souris dans tous les modes
opt.clipboard = "unnamedplus" -- str : Utiliser le presse-papier système

-- *******************
-- * 12. Indentation *
-- *******************
opt.smartindent = true -- bool : Activer l'indentation intelligente basée sur la syntaxe

-- *************************
-- * 13. Retour à la ligne *
-- *************************
opt.linebreak = true -- bool : Casse les lignes de texte seulement aux espaces (utile si wrap est activé)
opt.wrap = true -- bool : Activer le retour automatique à la ligne à l'affichage

-- *********************************
-- * 14. Correction orthographique *
-- *********************************
opt.spell = false -- bool : Activation uniquement selon contexte via auto-commandes

-- ***************
-- * 15. Folding *
-- ***************
-- Désactiver uniquement le repliement automatique :
opt.foldenable = false -- Désactive le repliement
opt.foldmethod = "manual" -- Mode manuel
opt.foldcolumn = "0" -- Masque la colonne de repliement
