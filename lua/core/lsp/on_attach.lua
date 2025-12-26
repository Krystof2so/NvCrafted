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
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

  -- Actions au niveau du code
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

  -- Diagnostics
  vim.keymap.set("n", "<leader>cw", vim.diagnostic.open_float, opts)

  -- ------------------------------------------------------------
  -- Hooks conditionnels (préparés pour plus tard)
  -- ------------------------------------------------------------

  -- Exemple :
  -- if client.server_capabilities.documentFormattingProvider then
  --   -- activer le formatage auto
  -- end
end

return M

