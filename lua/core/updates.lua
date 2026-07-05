-- **********************************************
-- * lua/core/updates.lua                       *
-- * Notification des mises à jour de plugins   *
-- **********************************************

TITLE_NOTIFY = " NvCrafted - plugins"
LONG_DELAY = 10000 -- 10s
SHORT_DELAY = 3000 -- 3s

local M = {}

-- ================================================================
-- = 1. M._fetch()                                                =
-- ================================================================
-- Interroge Lazy de façon asynchrone sans ouvrir son interface.
-- Pas de valeur de retour : opération purement asynchrone.
local function _fetch()
	-- Récupère le module "lazy" de manière asynchrone
	-- Avec vérification du chargement
	local ok, lazy = pcall(require, "lazy")
	if not ok then
		vim.notify("Module 'lazy' non chargé...", vim.log.levels.ERROR, { title = TITLE_NOTIFY })
	end
	-- Appelle lazy.check() avec show = false pour éviter d'ouvrir l'interface
	lazy.check({ show = false })
end

-- ================================================================
-- = 2. M._read_results()                                         =
-- ================================================================
-- Récupération de la table de configuration interne de Lazy.
-- 'plugins' est un dictionnaire { nom_plugin = table_plugin, ... }
-- Chaque entrée contient toutes les métadonnées du plugin.

-- @return table  liste des plugins à mettre à jour
local function _read_results()
	local ok, lazy_config = pcall(require, "lazy.core.config")
	if not ok then
		vim.notify("Impossible de lire la configuration lazy", vim.log.levels.ERROR, { title = TITLE_NOTIFY })
		return {}
	end
	local plugins = lazy_config.plugins
	local outdated = {}

	-- Parcours de chaque plugin déclaré dans Lazy.
	-- '_' est le nom du plugin (clé du dictionnaire), non utilisé ici.
	-- 'plugin' est la table complète des métadonnées du plugin.
	for _, plugin in pairs(plugins) do
		-- Lazy stocke ses données internes dans le champ '_' de chaque plugin.
		-- On vérifie son existence avant d'y accéder.
		if plugin._ then
			-- {}   = aucune mise à jour disponible
			-- {..} = commits disponibles → mise à jour possible
			if type(plugin._.updates) == "table" then
				table.insert(outdated, plugin.name)
			end
		end
	end
	-- Retourne le nombre total de plugins avec une mise à jour disponible.
	-- 0 = tout est à jour.
	return outdated
end

-- ================================================================
-- = 3. _notify()                                               =
-- ================================================================
-- Affiche la notification via vim.notify (routée vers nvim-notify
-- par Noice, déjà configuré dans NvCrafted).
-- Deux niveaux selon le résultat :
--   - WARN  si count > 0  →  mises à jour disponibles
--   - INFO  si count == 0 →  tout est à jour (mode non-silencieux)
--
-- @param outdated table  liste des mises à jour disponibles
-- @param silent boolean  si true, pas de notification "tout est à jour"
local function _notify(outdated, silent)
    local count = #outdated
	if count > 0 then
        -- Construction de la liste des plugins à mettre à jour
        local lines = {}
        for _, name in ipairs(outdated) do
            table.insert(lines, "- " .. name)
        end
        local update = count == 1 and " mise à jour disponible :\n" or " mises à jour disponibles :\n"
        local message = count .. update .. table.concat(lines, "\n")
		vim.notify(message, vim.log.levels.WARN, { title = TITLE_NOTIFY })
	elseif not silent then
		vim.notify("Tous les plugins sont à jour", vim.log.levels.INFO, { title = TITLE_NOTIFY })
	end
end

-- ================================================================
-- = 4. M.check()                                                 =
-- ================================================================
-- Point d'entrée public — orchestre les trois fonctions privées.
-- Appelée depuis M.setup() (démarrage) et depuis le keymap
-- <leader>pu (vérification manuelle).
--
--- @param silent boolean  transmis à _notify()
--- @param delay  integer  délai en ms avant lecture des résultats (défaut : 10000)
function M.check(silent, delay)
	delay = delay or SHORT_DELAY
	vim.defer_fn(function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyCheck",
			once = true,
			callback = function()
				local outdated = _read_results()
				_notify(outdated, silent)
			end,
		})
		_fetch()
	end, delay)
end

-- ================================================================
-- = 5. M.setup()                                                 =
-- ================================================================
-- Enregistre l'autocommand VimEnter qui déclenche la vérification
-- au démarrage. Appelée depuis init.lua après lazy.setup().
function M.setup()
	vim.api.nvim_create_autocmd("VimEnter", {
		once = true, -- Garantit que la vérification ne s'effectue qu'une seule fois au démarrage
		callback = function()
			-- Code qui sera exécuté au démarrage, après 3 secondes
			vim.defer_fn(function()
				-- Écoute la fin de la vérification avant de lire les résultats
				vim.api.nvim_create_autocmd("User", {
					pattern = "LazyCheck",
					once = true,
					callback = function()
						local count = _read_results()
						_notify(count, true)
					end,
				})
				-- Lance la vérification
				_fetch()
			end, SHORT_DELAY)
		end,
	})
end

return M
