-- Options générales
local opt = vim.opt
-- [[ Comportement général ]]
opt.colorcolumn = '120'        -- str : Afficher la colonne pour la longueur maximale de ligne
opt.number = true              -- bool : Afficher les numéros de ligne     
opt.relativenumber = true      -- bool : Afficher les numéros de ligne relatifs
opt.numberwidth = 4            -- int : Largeur de la colonne des numéros de ligne
opt.scrolloff = 8              -- int: Nombre minimum de lignes affichés sous le curseur
opt.sidescrolloff = 8          -- int: Espace minimal pour le scroll horizontal
opt.smoothscroll = true        -- bool : fluidité du défilement
opt.signcolumn = "yes"         -- str: Afficher la colonne des signes
opt.cursorline = true          -- bool : Mettre en surbrillance la ligne du curseur
opt.updatetime = 300           -- int: Temps en millisecondes avant que le CursorHold s'active (LSP/diagnostics)
opt.history = 1000             -- int : Nombre de commandes dans l'historique
-- Créer le répertoire pour l'undo persistant : mkdir -p ~/.local/share/nvim/undo
opt.undofile = true            -- bool : Activer l'undo persistant 
opt.undodir = vim.fn.stdpath("data").."/undo"     -- Répertoire pour undo persistants
opt.hidden = true              -- bool : changement de buffers sans sauvegarder

-- [[ Complétion ]]
opt.completeopt = {"menu", "menuone", "noselect"}  -- table{str} : pour LSP/completion

-- [[ Types de fichiers ]]
opt.encoding = 'utf8'          -- str : Encodage des chaînes à utiliser
opt.fileencoding = 'utf8'      -- str : Encodage des fichiers à utiliser

-- [[ Gestion de la sauvegarde ]]
opt.backup = false             -- bool : Désactive les fichiers de sauvegarde
opt.writebackup = false        -- bool : Désactive la création de backups avant l'écriture d'un fichier
opt.swapfile = false           -- bool : Désactive les fichiers d'échange (swap)

-- [[ Thème ]]
opt.syntax = "ON"              -- str : Activer la coloration syntaxique
opt.termguicolors = true       -- bool : Activer si le terminal supporte les couleurs UI

-- [[ Navigation dans le fichier ]]
opt.jumpoptions = "view"       -- str : Continuité visuelle lors des sauts

-- [[ Recherche ]]
opt.ignorecase = true          -- bool : Ignorer la casse dans les motifs de recherche
opt.smartcase = true           -- bool : Outrepasser ignorecase si la recherche contient des majuscules
opt.incsearch = true           -- bool : Utiliser la recherche incrémentale
opt.hlsearch = true            -- bool : Mettre en surbrillance les correspondances de recherche
opt.wrapscan = true            -- bool : Continue la recherche à partir du début ou de la fin
opt.gdefault = true            -- bool : Remplacement d'une occurrence sur la ligne

-- [[ Espaces blancs ]]
opt.expandtab = true           -- bool : Utiliser des espaces au lieu des tabulations
opt.shiftwidth = 4             -- num : Taille d'une indentation
opt.softtabstop = 4            -- num : Nombre d'espaces qu'une tabulation représente en mode insertion
opt.tabstop = 4                -- num : Nombre d'espaces qu'une tabulation représente

-- [[ UI ]]
opt.showmode = false           -- bool : Désactiver le mode "INSERT" affiché (redondant avec un statusline)
opt.showtabline = 2            -- int : 2 -> Toujours afficher la tabline
opt.showcmd = true             -- bool : Montre la commande en bas à gauche
opt.cmdheight = 2              -- int : Hauteur de la ligne de commande
opt.pumheight = 15             -- int : Hauteur du popup menu
opt.pumblend = 50              -- int : Taux de transprence du popup

-- [[ Fenêtres divisées ]]
opt.splitright = true          -- bool : Placer la nouvelle fenêtre à droite de l'actuelle
opt.splitbelow = true          -- bool : Placer la nouvelle fenêtre en dessous de l'actuelle
opt.equalalways = true         -- bool : Maintenir les splits égaux quand on les redéfinit
opt.hidden = true              -- bool : Permet de changer de buffer sans sauvegarder

-- [[ Souris et Presse-papier ]]
opt.mouse = "a"                -- str : Activer la souris dans tous les modes
opt.clipboard = "unnamedplus"  -- str : Utiliser le presse-papier système

-- [[ Indentation ]]
opt.autoindent = true          -- bool : Garde l’indentation quand on se rend à la ligne suivante
opt.smartindent = true         -- bool : Activer l'indentation intelligente basée sur la syntaxe
opt.smarttab = true            -- bool : Tab / Backspace intelligents dans l’indentation

-- [[ Retour à la ligne ]]
opt.linebreak = true           -- bool : Casse les lignes de texte seulement aux espaces (utile si wrap est activé)
opt.wrap = true                -- bool : Activer le retour automatique à la ligne à l'affichage

-- [[ UI - plugins ]]
opt.laststatus = 3             -- bool : Afficher une ligne de statut unique

-- [[ Performance ]]
opt.lazyredraw = true          -- bool : Accélère les macros et recherche

-- [[ Correction orthographique ]]
opt.spell = false              -- bool : Activation uniquement selon contexte via auto-commandes


-- ************************

-- [[ Options spéciales ]]

-- Folding basé sur Tree-sitter
opt.foldmethod = "expr"               -- utiliser une expression pour décider des folds
opt.foldexpr = "nvim_treesitter#foldexpr()"  -- Tree-sitter fournit la fonction
opt.foldenable = true                 -- activer le folding
opt.foldlevel = 99                    -- tout ouvert par défaut
opt.foldlevelstart = 99               -- idem à l'ouverture
opt.foldcolumn = "1"                  -- colonne pour voir les folds

