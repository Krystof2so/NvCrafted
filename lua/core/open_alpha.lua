-- *************************************************************
-- * lua/core/open_alpha.lua                                   *
-- *                                                           *
-- * Retour à l'écran d'accueil Alpha depuis n'importe où.     *
-- * Ferme tous les buffers ouverts en proposant               *
-- * d'enregistrer les modifications non sauvegardées.         *
-- * Ferme également Neo-tree s'il est ouvert.                 *
-- *                                                           *
-- * Appelé depuis core/keymaps.lua (<leader>xa)               *
-- *************************************************************

local M = {}

function M.open()
	local buffers_list = vim.api.nvim_list_bufs() -- 'nvim_list_bufs()' = liste les buffers ouverts
	local buffers_modified = {}
	local index_buf_list = 0

	-- =========================================================
	-- Lancement d'alpha.nvim
	-- =========================================================
	local function launch_alpha()
		-- Ferme Neo-tree s'il est ouvert
		pcall(function()
			require("neo-tree.command").execute({ action = "close" })
		end)
		-- Suppression des buffers et de leurs métadonnées
		-- pcall pour absorber les erreurs potentielles (enregistrements déjà réalisés)
		for _, buf in ipairs(buffers_list) do
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
		-- Lancement d'alpha.nvim
		require("alpha").start(true)
	end

	-- =========================================================
	-- Traitement séquentiel des buffers
	-- =========================================================
	local function buffer_processing()
		index_buf_list = index_buf_list + 1
		if index_buf_list > #buffers_modified then
			launch_alpha()
			return
		end
		local buf = buffers_modified[index_buf_list]
		local name = vim.api.nvim_buf_get_name(buf)
		if name ~= "" then
			name = vim.fn.fnamemodify(name, ":t") -- Non du fichier uniquement (pas le chemin complet)
		else
			name = "[Sans nom]"
		end
		-- Boucle d'évènement (via 'vim.schedule): traitement des buffers un par un
		vim.schedule(function()
			-- Utilisation d'une interface Snacks.input pour traiter chacun des buffers
			Snacks.input({
				prompt = "(E)nregistrer · (I)gnorer · (A)nnuler  󰜴  ",
				prompt_pos = "left",
				win = {
					title = "'" .. name .. "' a été modifié ",
					title_pos = "center",
					width = 60,
					row = 2,
					border = "rounded",
				},
			}, function(choice)
				-- Toute la logique vit ici, dans le callback asynchrone
				if choice == "e" or choice == "E" then
					vim.api.nvim_buf_call(buf, function()
						vim.cmd("write")
					end)
					vim.schedule(buffer_processing)
				elseif choice == "i" or choice == "I" then
					vim.schedule(buffer_processing)
				elseif choice == "a" or choice == "A" or choice == nil then
					vim.notify("Retour à l'accueil annulé.", vim.log.levels.INFO)
				else
					-- Saisie invalide : on relance Snacks.input pour ce même buffer
					vim.notify("Saisie invalide. Veuillez taper e, i ou a.", vim.log.levels.WARN)
					index_buf_list = index_buf_list - 1
					vim.schedule(buffer_processing)
				end
			end)
		end)
	end

	-- =========================================================
	-- Collecte des buffers modifiés non sauvegardés
	-- =========================================================
	for _, buf in ipairs(buffers_list) do
		if
			vim.api.nvim_buf_is_valid(buf) -- si buffer existe en mémoire (Précaution supplémentaire)
			and vim.api.nvim_buf_is_loaded(buf) -- si contenu en mémoire
			and vim.bo[buf].buftype == "" -- si buffer ordinaire (exclu terminal, fenêtres LSP...)
			and vim.bo[buf].modified
		then -- si modifié et non sauvegardé
			table.insert(buffers_modified, buf)
		end
	end

	-- =========================================================
	-- Logique de lancement d'alpha.nvim
	-- =========================================================
	if #buffers_modified == 0 then -- Aucun buffer à modifier
		launch_alpha()
		return
	end
	-- Sinon, traitement séquentiel des buffers pour enregistrement ou non
	buffer_processing()
end

return M
