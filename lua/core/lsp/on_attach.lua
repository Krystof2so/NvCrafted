-- *****************************************************************
-- * core/lsp/on_attach.lua                                        *
-- *                                                               *
-- * Fonction appelée lorsqu'un serveur LSP s'attache à un buffer. *
-- * C'est le point de jonction entre :                            *
-- *    - le serveur LSP (client)                                  *
-- *    - le buffer courant (bufnr)                                *
-- *                                                               *
-- * Contient uniquement ce qui nécessite bufnr :                  *
-- * - options buffer-local                                        *
-- * - inlay hints                                                 *
-- * - mappings LSP buffer-local                                   *
-- *                                                               *
-- * Organisation des mappings : par fonctionnalité, pas par       *
-- * plugin. Cohérente avec core/keymaps.lua.                      *
-- *                                                               *
-- * Groupes which-key déclarés ici pour les mappings buffer-local *
-- * qui ne peuvent pas l'être dans keymaps.lua (bufnr requis).    *
-- *****************************************************************

local M = {}
local map = vim.keymap.set

function M.on_attach(client, bufnr)
	-- ============================================================
	-- Highlights adaptatifs au thème courant
	-- ============================================================
	require("core.highlights").setup()

	-- ============================================================
	-- Options buffer-local
	-- ============================================================
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	-- ============================================================
	-- Inlay hints natifs (Neovim 0.10+)
	-- Activés automatiquement si le serveur les supporte.
	-- Toggle buffer-local : <leader>ci
	-- Toggle global       : <leader>uI  (core/keymaps.lua)
	-- ============================================================
	if client and client:supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	-- ============================================================
	-- Mappings buffer-local
	-- ============================================================
	local opts = { buffer = bufnr, silent = true }

	-- ----------------------------------------------------------
	-- Navigation dans le code (sans préfixe <leader>)
	-- Conventions Neovim standard : g + lettre
	-- ----------------------------------------------------------
	map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Aller à la définition" }))
	map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Aller à la déclaration" }))
	map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Références du symbole" }))
	map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Aller à l'implémentation" }))
	map("n", "K", function()
		vim.lsp.buf.hover({ border = "rounded", max_width = 80, max_height = 20 })
	end, vim.tbl_extend("force", opts, { desc = "Documentation (hover)" }))

	-- ----------------------------------------------------------
	-- <leader>c — Actions sur le code (LSP)
	-- Le groupe complet <leader>c est déclaré dans keymaps.lua.
	-- Les mappings Neogen (<leader>cf, cc, ct, cF) y sont aussi.
	-- ----------------------------------------------------------
	map("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "󰑕 Renommer le symbole" }))
	map("n", "<leader>ci", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
	end, vim.tbl_extend("force", opts, { desc = "󰈈 Toggle hints (buffer)" }))

	-- ----------------------------------------------------------
	-- <leader>d — Diagnostics (buffer-local)
	-- Le diagnostic flottant est buffer-local (bufnr requis).
	-- La liste globale (Trouble) est dans keymaps.lua.
	-- ----------------------------------------------------------
	map("n", "<leader>dd", function()
		vim.diagnostic.open_float(nil, {
			bufnr = bufnr,
			border = "rounded",
			max_width = 80,
			max_height = 20,
			title = " Diagnostics",
			title_pos = "center",
			focusable = false,
		})
	end, vim.tbl_extend("force", opts, { desc = "󰙨 Diagnostic flottant" }))
	map("n", "<leader>dn", function()
		vim.diagnostic.jump({ count = 1, float = { border = "rounded" } })
	end, vim.tbl_extend("force", opts, { desc = "󰼧 Diagnostic suivant" }))
	map("n", "<leader>dp", function()
		vim.diagnostic.jump({ count = -1, float = { border = "rounded" } })
	end, vim.tbl_extend("force", opts, { desc = "󰼨 Diagnostic précédent" }))

	-- ----------------------------------------------------------
	-- Enregistrement which-key des mappings buffer-local
	-- Déclaré ici car which-key doit connaître le buffer.
	-- ----------------------------------------------------------
	local ok, wk = pcall(require, "which-key")
	if ok then
		wk.add({
			-- Sous-groupe LSP dans <leader>c
			{ "<leader>cr", buffer = bufnr, desc = "Renommer le symbole", icon = "󰑕" },
			{ "<leader>ci", buffer = bufnr, desc = "Toggle hints (buffer)", icon = "󰈈" },
			-- Sous-groupe diagnostics dans <leader>d
			{ "<leader>dd", buffer = bufnr, desc = "Diagnostic flottant", icon = "󰙨" },
			{ "<leader>dn", buffer = bufnr, desc = "Diagnostic suivant", icon = "󰼧" },
			{ "<leader>dp", buffer = bufnr, desc = "Diagnostic précédent", icon = "󰼨" },
		})
	end
end

return M
