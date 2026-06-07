-- ************************************************************
-- * core/lsp/tools.lua                                       *
-- *                                                          *
-- * Source de vérité des outils installés par Mason qui ne   *
-- * sont PAS des serveurs LSP : formateurs, linters, etc.    *
-- *                                                          *
-- * Rôle dans le flux Mason :                                *
-- *   servers.lua  →  mason-lspconfig  →  serveurs LSP       *
-- *   tools.lua    →  mason-tool-installer  →  outils        *
-- *   Les deux listes sont installées par mason.nvim.        *
-- *                                                          *
-- * Pour ajouter un outil : ajouter son nom Mason ici.       *
-- * Les noms exacts sont disponibles via :Mason              *
-- ************************************************************
-- TODO: mise à jour de 'docs/lsp-nvcrafted.md'
return {
	-- Python
	"black", -- Formateur
	"isort", -- Tri des imports
	"ruff", -- Linter / formateur moderne Python (complément à Pyright) - uniquement ici, pas dans 'servers.lua'
	-- Lua :
	"stylua",
	-- Multi-langage :
	"prettier", -- Formateur JS, TS, JSON, YAML, Markdown...
}
