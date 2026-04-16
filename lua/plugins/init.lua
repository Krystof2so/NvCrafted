-- ***********************************************************************************
-- * /lua/plugins/init.lua                                                           *
-- *                                                                                 *
-- * Génère dynamiquement la configuration des plugins pour lazy.nvim.               *
-- * Scanne le dossier `lua/plugins/` et récupère tous les sous-répertoires.         *
-- * Transforme chaque sous-répertoire en une entrée { import = "plugins.<nom>" }.   *
-- * Retourne une table `spec` directement utilisable par `require("lazy").setup()`. *
-- ***********************************************************************************

-- ============================================================================
-- 1. Fonction pour récupérer tous les sous-répertoires sous forme d'une table
-- ============================================================================
local function get_plugin_dirs(path)
	local uv = vim.uv or vim.loop -- fallback pour Neovim < 0.10
	if uv.fs_stat(path) == nil then
		return {} -- Retourne une table vide si le dossier n'existe pas
	end
	local dirs = {}
	local scan_handle = uv.fs_scandir(path) -- Descripteur de répertoire - nil si répertoire est vide
	if scan_handle then -- uniquement si non nil, sinon sortie de la condition
		while true do
			local name, type = uv.fs_scandir_next(scan_handle)
			if not name then
				break
			end -- quand il n'y a plus d'élément, name = nil
			if type == "directory" then -- si répertoire
				table.insert(dirs, name)
			end
		end
	end
	return dirs -- retourne la liste des noms de répertoires ('coding', 'lsp', etc.)
end

-- ============================================================================================================
-- 2. Fonction pour créer la spec Lazy.nvim à partir de la table des répertoires générée par 'get_plugin_dirs'
-- ============================================================================================================
local function build_lazy_spec(dirs)
	local spec = {}
	for i, dir in ipairs(dirs) do -- Pour chaque répertoire dans 'dirs'...
		spec[i] = { import = "plugins." .. dir } -- ...crée une entrée { import = "plugins.<dir>" }
	end
	return spec -- spec = { [1] = { import = "plugins.coding" }, [2] = { import = "plugins.lsp" }, etc. }
end

-- ===============================
-- Exécution, et retourne la spec
-- ===============================
return build_lazy_spec(get_plugin_dirs(vim.fn.stdpath("config") .. "/lua/plugins"))
