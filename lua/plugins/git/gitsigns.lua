-- ************************************************************
-- * lua/plugins/git/gitsigns.lua                             *
-- *                                                          *
-- * gitsigns.nvim : Intégration avancée pour Git             *
-- * - Affiche des signes dans la |signcolumn| pour indiquer  *
-- * les lignes modifiées/ajoutées/supprimées.                *
-- *
-- *                                                          *
-- * GitHub : https://github.com/lewis6991/gitsigns.nvim/     *
-- ************************************************************

return {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPre", -- chargement dès qu'un fichier est ouvert
}

-- GROUPES DE SURBRILLANCE -> h: gitsigns-highlight-groups
