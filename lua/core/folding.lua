-- lua/core/folding.lua
-- *************************************************************
-- * Folding natif : LSP en priorité, Tree-sitter en repli.    *
-- *                                                           *
-- * Règle l'apparence et le comportement général des plis,    *
-- * puis il choisit la source qui décide où commencent et     *
-- * finissent les plis (Tree-sitter ou LSP).                  *
-- * Calcul asynchrone : Les plages LSP arrivent après un      *
-- * échange avec le serveur. A l'ouverture d'un fichier, il   *
-- * peut s'écouler un court instant avant que les plis soient *
-- * disponibles.                                              *
-- *************************************************************

local M = {}

-- ---------------------------------------------------------------------------------------
--  Commentaires de documentation Rust systématiquement repliées à l'ouverture du fichier
--  Fonctions utilitaires :
--  - is_doc()
--  - doc_blocks()
--  - close_doc_folds()
--  Fonction d'orchestration :
--  - fold_rust_docs()
-- ---------------------------------------------------------------------------------------

-- Reconnaître une ligne de documentation :
-- Utilisation de motifs Lua ()
-- '^%s*' => début de ligne puis espaces (indentation)
-- '///[^/]' => trois antislashs suivis d'un caractère autre qu'un antislash
-- '///$' => trois antislash + fin de ligne
-- '//!' => Pour la documentation générale de la crate
---@param line any
---@return boolean
local function is_doc(line)
	return line:match("^%s*///[^/]") ~= nil or line:match("^%s*///$") ~= nil or line:match("^%s*//!") ~= nil
end

-- Repérer les blocs sur plusieurs lignes :
-- Lit chaque ligne du buffer dans une table.
-- La boucle externe parcourt les lignes. Quand elle tombe sur une ligne de doc,
-- elle mémorise start, puis la boucle interne avance tant que la ligne suivante
-- est aussi de la doc.
-- 'if l > start' filtre les blocs d'une seule ligne
-- Retourne, sous forme de paires, la liste des blocs de doc de 2 lignes ou plus :
-- { {début, fin}, ... }. Exemple => '{ {1, 4}, {12, 15} }'.
---@param buf any
---@return table
local function doc_blocks(buf)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local blocks = {}
	local l = 1
	while l <= #lines do
		if is_doc(lines[l]) then
			local start = l
			while l < #lines and is_doc(lines[l + 1]) do
				l = l + 1
			end
			if l > start then
				table.insert(blocks, { start, l })
			end
		end
		l = l + 1 -- Passe à la ligne suivante
	end
	return blocks
end

-- Ferme le pli de chaque bloc :
-- Fonction exécutée dans le contexte de la fenêtre courante ('win').
-- Si pli de commentaire existe, foldclose le ferme.
---@param win any
---@param blocks any -- Liste de paires {début, fin} (numéros de ligne Neovim)
local function close_doc_folds(win, blocks)
	vim.api.nvim_win_call(win, function()
		for _, block in ipairs(blocks) do -- 'block' réceptionne une paire
			local start = block[1] -- Ligne de début du bloc
			-- Appel d'une commande 'Ex' :
			vim.cmd(("silent! %dfoldclose"):format(start)) -- Remplace '%d' par 'start' et ferme un niveau de pli ('silent!' supprime les erreurs = exception)
			-- Vérifier si pli fermé commence à la première ligne du bloc, si oui l'ouvre ('foldopen')
			if vim.fn.foldclosed(start) ~= start then
				vim.cmd(("silent! %dfoldopen"):format(start))
			end
		end
	end)
end

-- Vérifier que les plis existent :
-- Neovim demande que 'rust-analyzer' fournisse les plages de pli.
-- Garde d'entrée : la fonction abandonne après 20 tentatives
-- (environ 5 secondes avec 250 ms d'attente)
-- ou si la fenêtre ou le buffer ont été fermés entre-temps.
---@param win any
---@param buf any
---@param tries any
local function fold_rust_docs(win, buf, tries)
	if tries > 20 then -- Condition d'arrêt de la récursion
		return
	end
	local blocks = doc_blocks(buf)
	if #blocks == 0 then -- Stop si aucun bloc multi-lignes
		return
	end
	vim.defer_fn(function() -- Exécution de la fonction après 250ms
		-- Au cas où le contexte ait changé (fermeture de la fenêtre ou du buffer)
		if not vim.api.nvim_win_is_valid(win) or not vim.api.nvim_buf_is_valid(buf) then
			return
		end
		local ready = vim.api.nvim_win_call(win, function()
			return vim.fn.foldlevel(blocks[1][1]) > 0
		end) -- Vérifie si un pli existe
		if ready then
			close_doc_folds(win, blocks)
		else
			fold_rust_docs(win, buf, tries + 1) -- Rappel de la fonction
		end
	end, 250)
end

function M.setup()
	-- Valeurs par défaut (les fichiers s'ouvrent d&pliés pas défaut):
	vim.o.foldenable = true -- Active le repliement
	vim.o.foldlevel = 99 -- Rien n'est replié par défaut (0 pour avoir tout de replié)
	vim.o.foldlevelstart = 99 -- Idem (au lancement du fichier)
	vim.o.foldcolumn = "1" -- Petite colonne pour repérer les plis ('-' pli ouvert, '+' pli fermé)
	vim.o.foldtext = "" -- Affiche la 1re ligne du pli, avec sa coloration

	local group = vim.api.nvim_create_augroup("NvCraftedFoldingExpr", { clear = true })

	-- Repli : Tree-sitter, si un parser existe pour le filetype
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			-- Tente de récupérer le parser tree-sitter du buffer
			if pcall(vim.treesitter.get_parser, args.buf) then
				local win = vim.api.nvim_get_current_win()
				vim.wo[win][0].foldmethod = "expr"
				vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
			end
		end,
	})

	-- Prioritaire : quand un serveur LSP s'attache à un buffer et
	-- si le serveur sait fournir des plages de pliage (Méthode
	-- 'foldingRange' applicable au document).
	vim.api.nvim_create_autocmd("LspAttach", { -- Si LSP le 'foldexpr' de tree-sitter est écrasé
		group = group,
		callback = function(args)
			-- Identification du serveur retourné
			local client = vim.lsp.get_client_by_id(args.data.client_id) -- Objet rpc du client
			if client and client:supports_method("textDocument/foldingRange") then
				local win = vim.api.nvim_get_current_win() -- 'window-ID' (integer)
				vim.wo[win][0].foldmethod = "expr"
				vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
			end
		end,
	})

	-- Autocommande qui déclenche le repliement des commentaire de documentation Rust
	-- Ne se déclenche que pour les fichier '.rs' au niveau de la fenêtre courante
	vim.api.nvim_create_autocmd("LspAttach", {
		group = group,
		callback = function(args)
			if vim.bo[args.buf].filetype ~= "rust" or vim.b[args.buf].nvcrafted_docs_folded then
				return
			end
			vim.b[args.buf].nvcrafted_docs_folded = true -- une seule fois par buffer
			fold_rust_docs(vim.api.nvim_get_current_win(), args.buf, 0)
		end,
	})
end

return M
