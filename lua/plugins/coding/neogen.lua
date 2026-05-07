-- ********************************************************
-- * lua/plugins/coding/neogen.lua                        *
-- * GitHub : https://github.com/danymat/neogen           *
-- *                                                      *
-- * Génération automatique d'annotations et docstrings   *
-- * pour Bash, Lua, Python et Rust.                      *
-- ********************************************************

return {
	"danymat/neogen",
	version = "*",
	dependencies = {
		-- Tree-sitter est requis pour l'analyse syntaxique
		-- qui permet à Neogen de positionner les annotations
		"nvim-treesitter/nvim-treesitter",
	},
	event = "BufReadPost",
	opts = {
		-- ============================================================
		-- Activation de l'intégration LuaSnip
		-- ============================================================
		snippet_engine = "luasnip",
		-- ============================================================
		-- Conventions d'annotations par langage
		-- ============================================================
		languages = {
			bash = { -- Bash : convention shell standard
				template = {
					annotation_convention = "google_bash",
				},
			},
			lua = { -- Lua : convention EmmyLua, reconnue par lua_ls
				template = {
					annotation_convention = "emmylua",
				},
			},
			python = { -- Python : convention Google Docstrings (lisible et supportée par pyright)
				template = {
					annotation_convention = "google_docstrings",
				},
			},
			rust = { -- Rust : convention rustdoc (///), standard de l'écosystème Rust, généré par `cargo doc`
				template = {
					annotation_convention = "rustdoc",
				},
			},
		},
	},
}
