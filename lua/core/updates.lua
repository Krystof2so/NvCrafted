-- **********************************************
-- * lua/core/updates.lua                       *
-- * Notification des mises à jour de plugins   *
-- **********************************************

TITLE_NOTIFY = " NvCrafted · Plugins"
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
		Snacks.notify.error("Module 'lazy' non chargé...", {title = TITLE_NOTIFY })
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

-- @return integer  nombre de plugins avec une mise à jour disponible
local function _read_results()
	local ok, lazy_config = pcall(require, "lazy.core.config")
	if not ok then
		Snacks.notify.error("Impossible de lire la configuration lazy", { title = TITLE_NOTIFY } )
		return 0
	end
	local plugins = lazy_config.plugins
	local count = 0

	-- Parcours de chaque plugin déclaré dans Lazy.
	-- '_' est le nom du plugin (clé du dictionnaire), non utilisé ici.
	-- 'plugin' est la table complète des métadonnées du plugin.
	for _, plugin in pairs(plugins) do
		-- Lazy stocke ses données internes dans le champ '_' de chaque plugin.
		-- On vérifie son existence avant d'y accéder.
		if plugin._ then
			-- 'plugin._.updates' est une table de commits disponibles en amont.
			-- Elle est peuplée par lazy.check() après la vérification réseau.
			-- nil  = vérification pas encore effectuée ou plugin épinglé
			-- {}   = aucune mise à jour disponible
			-- {..} = commits disponibles → mise à jour possible
			if plugin._.updates and #plugin._.updates > 0 then
				count = count + 1
			end
		end
	end
	-- Retourne le nombre total de plugins avec une mise à jour disponible.
	-- 0 = tout est à jour.
	return count
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
-- @param count  integer  nombre de mises à jour disponibles
-- @param silent boolean  si true, pas de notification "tout est à jour"
local function _notify(count, silent)
	if count > 0 then
		Snacks.notify.warn(count .. " mises à jour disponibles", { title = TITLE_NOTIFY } )
	elseif not silent then
		Snacks.notify.info("Tous les plugins sont à jour", { title = TITLE_NOTIFY } )
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
	_fetch()
	vim.defer_fn(function()
		local count = _read_results()
		_notify(count, silent)
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
				M.check(true, LONG_DELAY) -- 'false' si nous voulons une notification systématique après le démarrage
			end, SHORT_DELAY)
		end,
	})
end

return M
