-- **************************************************************************
-- * lua/plugins/lsp/servers.lua                                            *
-- *                                                                        *
-- * Ce fichier constitue la "source de vérité*" des serveurs LSP utilisés  *
-- * par NvCrafted.                                                         *
-- * Chaque clé correspond au nom exact du serveur LSP tel qu'attendu par   *
-- * nvim-lspconfig et Mason.                                               *
-- * La valeur associée est volontairement vide : les configurations        *
-- * spécifiques sont définies dans lua/plugins/lsp/config/<server>.lua.    *
-- *                                                                        *
-- * Ajouter un nouveau LSP propre à NvCrefted se fait donc en 2 étapes     *
-- * simples :                                                              *
-- * 1. Ajouter le nom du serveur ici                                       *
-- * 2. (Optionnel) Créer une surcouche de configuration dédiée             *
-- * Cette approche garantit :                                              *
-- * - une configuration déclarative                                        *
-- * - une excellente lisibilité                                            *
-- * - une scalabilité propre au framework NvCrafted                        *
-- **************************************************************************

return {
	-- HTML/CSS
	"html",
	"cssls",
	"emmet_ls", -- optionnel mais fortement recommandé
	"texlab", -- LaTeX
	"lua_ls", -- Lua
	-- Python
	"pyright",
	"ruff",
	"rust_analyzer", -- Rust
}
