-- ***********************************************************************
-- * Module : core.format.conform                                        *
-- *                                                                     *
-- * Configuration centralisée de conform.nvim pour NvCrafted.           *
-- * - Formatage automatique à la sauvegarde                             *
-- * - Choix dynamique des formateurs Python selon Ruff                  *
-- * - Utilisation des outils installés via Mason / mason-tool-installer *
-- * - Support étendu : Lua, Rust, Python, Markdown, JSON                *
-- ***********************************************************************

local M = {}

function M.setup()
	local conform = require("conform")

	conform.setup({
		-- ==================================
		-- 1. Formateurs par type de fichier
		-- ==================================
		formatters_by_ft = {
			lua = { "stylua" },
			rust = { lsp_format = "fallback" }, -- Rust : fallback LSP

			-- Python : dynamique avec Ruff
			python = function(bufnr)
				if conform.get_formatter_info("ruff_format", bufnr).available then
					-- Ruff formate le code si possible
					return { "ruff_format" }
				else
					-- Sinon : tri des imports + formatage
					return { "isort", "black" }
				end
			end,
			markdown = { "prettier" },
			json = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
		},
	})
	-- ============================================
	-- 2. Formatage automatique à l'enregistrement
	-- ============================================
	vim.api.nvim_create_autocmd("BufWritePre", {
		callback = function(args)
			local bufnr = args.buf
			require("conform").format({ bufnr = bufnr })
		end,
	})
end

return M
