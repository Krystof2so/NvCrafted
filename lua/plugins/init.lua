-- ***********************************************************************************
-- * /lua/plugins/init.lua                                                           *
-- *                                                                                 *
-- * Génère dynamiquement la configuration des plugins pour lazy.nvim.               *
-- * Scanne le dossier `lua/plugins/` et récupère tous les sous-répertoires.         *
-- * Transforme chaque sous-répertoire en une entrée { import = "plugins.<nom>" }.   *
-- * Retourne une table `spec` directement utilisable par `require("lazy").setup()`. *
-- ***********************************************************************************


-- Fonction pour récupérer tous les sous-répertoires sous forme d'une table :
local function get_plugin_dirs(path)
  local dirs = {}
  local scan_handle = vim.loop.fs_scandir(path)  -- nil si répertoire est vide
  if scan_handle then  -- uniquement si non nil, sinon sortie de la condition
    while true do
      local name, type = vim.loop.fs_scandir_next(scan_handle)
      if not name then break end  -- quand il n'y a plus d'élement, name = nil
      if type == "directory" then  -- si répertoire
        table.insert(dirs, name)
      end
    end
  end
  return dirs
end

-- Fonction pour créer la spec Lazy.nvim à partir de la table des répertoires :
local function build_lazy_spec(dirs)
  local spec = {}
  for i, dir in ipairs(dirs) do
    spec[i] = { import = "plugins." .. dir }
  end
  return spec
end

-- Exécution :
return build_lazy_spec(get_plugin_dirs(vim.fn.stdpath("config") .. "/lua/plugins"))

