-- Options générales
local opt = vim.opt

-- [[ Comportement général ]]
opt.colorcolumn = '120'        -- str : Afficher la colonne pour la longueur maximale de ligne
opt.number = true              -- bool : Afficher les numéros de ligne     
opt.relativenumber = true      -- bool : Afficher les numéros de ligne relatifs
opt.numberwidth = 4            -- int : Largeur de la colonne des numéros de ligne
opt.scrolloff = 8              -- int: Nombre minimum de lignes affichés sous le curseur
opt.signcolumn = "yes"         -- str: Afficher la colonne des signes
opt.cursorline = true          -- bool : Mettre en surbrillance la ligne du curseur

-- [[ Types de fichiers ]]
opt.encoding = 'utf8'          -- str : Encodage des chaînes à utiliser
opt.fileencoding = 'utf8'      -- str : Encodage des fichiers à utiliser

-- [[ Thème ]]
opt.syntax = "ON"              -- str : Activer la coloration syntaxique
opt.termguicolors = true       -- bool : Activer si le terminal supporte les couleurs UI

-- [[ Recherche ]]
opt.ignorecase = true          -- bool : Ignorer la casse dans les motifs de recherche
opt.smartcase = true           -- bool : Outrepasser ignorecase si la recherche contient des majuscules
opt.incsearch = true           -- bool : Utiliser la recherche incrémentale
opt.hlsearch = false           -- bool : Mettre en surbrillance les correspondances de recherche

-- [[ Espaces blancs ]]
opt.expandtab = true           -- bool : Utiliser des espaces au lieu des tabulations
opt.shiftwidth = 4             -- num : Taille d'une indentation
opt.softtabstop = 4            -- num : Nombre d'espaces qu'une tabulation représente en mode insertion
opt.tabstop = 4                -- num : Nombre d'espaces qu'une tabulation représente

-- [[ Fenêtres divisées ]]
opt.splitright = true          -- bool : Placer la nouvelle fenêtre à droite de l'actuelle
opt.splitbelow = true          -- bool : Placer la nouvelle fenêtre en dessous de l'actuelle

-- [[ Souris et Presse-papier ]]
opt.mouse = "a"                -- str : Activer la souris dans tous les modes
opt.clipboard = "unnamedplus"  -- str : Utiliser le presse-papier système

-- [[ Indentation ]]
opt.smartindent = true         -- bool : Activer l'indentation intelligente basée sur la syntaxe

-- [[ Retour à la ligne ]]
opt.wrap = false               -- bool : Désactiver le retour automatique à la ligne à l'affichage

-- [[ UI - plugins ]]
opt.laststatus = 3             -- bool : Afficher une ligne de statut unique

-- ************************

-- [[ Options spéciales ]]

-- Folding basé sur Tree-sitter
opt.foldmethod = "expr"               -- utiliser une expression pour décider des folds
opt.foldexpr = "nvim_treesitter#foldexpr()"  -- Tree-sitter fournit la fonction
opt.foldenable = true                 -- activer le folding
opt.foldlevel = 99                    -- tout ouvert par défaut
opt.foldlevelstart = 99               -- idem à l'ouverture
opt.foldcolumn = "1"                  -- colonne pour voir les folds

