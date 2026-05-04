-- *****************************************************************
-- * core/lsp/on_attach.lua                                        *
-- *                                                               *
-- * Fonction appelée lorsqu'un serveur LSP s'attache à un buffer. *
-- * C'est le point de jonction entre :                            *
-- *    - le serveur LSP (client)                                  *
-- *    - le buffer courant (bufnr)                                *
-- * Toute logique dépendante du LSP et du buffer doit             *
-- * s'implémenter ici.                                            *
-- *****************************************************************

local M = {}

function M.on_attach(_, bufnr)
	-- Highlights de diagnostics adaptatifs au thème courant.
	-- Le module détecte automatiquement la famille du thème actif
	-- (rose-pine, nordic, evergarden, ou fallback).
	require("core.highlights.diagnostics").setup()

	-- ------------------------------------------------------------
	-- Options buffer-local liées au LSP
	-- ------------------------------------------------------------
	-- Utilisation de l'omnifunc LSP pour la complétion native
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	-- ------------------------------------------------------------
	-- Mappings LSP (buffer-local)
	-- ------------------------------------------------------------
	local opts = { buffer = bufnr, silent = true }

	-- Navigation
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

	-- Documentation
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover({
			border = "rounded",
			max_width = 80,
			max_height = 20,
		})
	end, opts)

	-- Actions au niveau du code
	vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

	-- Diagnostics flottants
	vim.keymap.set("n", "<leader>cw", function()
		vim.diagnostic.open_float(nil, {
			bufnr = bufnr, -- buffer local
			border = "rounded",
			max_width = 80,
			max_height = 20,
			title = "Diagnostics",
			title_pos = "center",
			focusable = false,
		})
	end, opts)
end

return M
