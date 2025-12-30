-- *********************************************************************************
-- * core/lsp/capabilities.lua                                                     *
-- *                                                                               *
-- * Ce fichier décrit ce que Neovim est capable de gérer en tant que client LSP.  *
-- * Les serveurs de langage s'adaptent à ces informations lors de leur démarrage. *
-- *********************************************************************************

local M = {}

function M.get()
  -- Capabilities de base fournies par Neovim :
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- ==============================================================
  -- = Items de complétion enrichies (fonctionnalités supportées) =
  -- ==============================================================
  capabilities.textDocument.completion.completionItem = {
    snippetSupport = true,                              -- Autorise les snippets dans les complétions
    documentationFormat = { "markdown", "plaintext" },  -- Formats pour la documentation d'une complétion (flottant)
    preselectSupport = true,                            -- Autorise les serveur à pré-selectionner un item 
    insertReplaceSupport = true,                        -- Autorise les modes d'insertion 'insert' et 'replace'
    labelDetailsSupport = true,                         -- Autorise les informations supplémentaires
    deprecatedSupport = true,                           -- Autorise le serveur à marquer un item comme obsolète
    commitCharactersSupport = true,                     -- Support des caractères de commit
  }

  -- ==========================
  -- = Encodage des positions =
  -- ==========================
  capabilities.general = {
    positionEncodings = { "utf-8", "utf-16", "utf-32" },
  }

  return capabilities
end

return M

