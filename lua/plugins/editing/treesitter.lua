-- ************************************************************************
-- * GitHub: https://github.com/nvim-treesitter/nvim-treesitter/tree/main *
-- *                                                                      *
-- * Tree-sitter analyse le code via un arbre syntaxique pour fournir une *
-- * coloration syntaxique, l'indentation fiable et éventuellement un     *
-- * folding.                                                             *
-- ************************************************************************

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate", -- installe et met à jour les parsers
		-- Pas d'event ici : l'init gère le FileType lui-même
		init = function()
			-- ================================================================
			-- Installation des parsers manquants au démarrage
			-- Diff entre les parsers déjà installés pour éviter
			-- de tout réinstaller à chaque lancement
			-- ================================================================
			local ensure_installed = {
				"python",
				"rust",
				"toml",
				"html",
				"css",
				"json",
				"regex",
				"bash",
			}

			local already_installed = require("nvim-treesitter.config").get_installed()
			local to_install = vim.iter(ensure_installed)
				:filter(function(parser)
					return not vim.tbl_contains(already_installed, parser)
				end)
				:totable()

			if #to_install > 0 then
				require("nvim-treesitter").install(to_install)
			end

			-- ================================================================
			-- Activation du highlight et de l'indentation par FileType
			-- L'ancienne API (highlight.enable, indent.enable dans setup())
			-- n'existe plus — on les active manuellement via autocmd
			-- ================================================================
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					-- Démarre le highlight Tree-sitter (pcall = silencieux
					-- si le parser n'est pas disponible pour ce filetype)
					pcall(vim.treesitter.start)
					-- Indentation Tree-sitter
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
}
