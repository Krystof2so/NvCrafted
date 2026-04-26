-- =============================================================================
-- lua/nvcrafted/tutor/progress.lua
-- Sauvegarde et restauration de la progression du tutoriel NvCrafted
-- Stockage : JSON dans vim.fn.stdpath("data")/nvcrafted_tutor_progress.json
-- =============================================================================

local M = {}

-- ---------------------------------------------------------------------------
-- Utilitaires
-- ---------------------------------------------------------------------------

--- Retourne le chemin du fichier de progression
local function progress_path()
	local ok, tutor = pcall(require, "nvcrafted.tutor")
	if ok and tutor.config and tutor.config.progress_file then
		return tutor.config.progress_file
	end
	return vim.fn.stdpath("data") .. "/nvcrafted_tutor_progress.json"
end

--- Encode une table Lua en JSON minimal (pas de dépendance externe)
--- Supporte : string, number, boolean, nil, table (array et dict)
local function encode_json(val, indent)
	indent = indent or ""
	local t = type(val)

	if val == nil then
		return "null"
	elseif t == "boolean" then
		return tostring(val)
	elseif t == "number" then
		-- Évite la notation scientifique pour les entiers
		if val == math.floor(val) then
			return string.format("%d", val)
		end
		return string.format("%g", val)
	elseif t == "string" then
		-- Échappe les caractères spéciaux JSON
		local escaped = val:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("\t", "\\t")
		return '"' .. escaped .. '"'
	elseif t == "table" then
		local inner = indent .. "  "

		-- Détermine si c'est un tableau (clés entières consécutives depuis 1)
		local is_array = true
		local max_n = 0
		for k, _ in pairs(val) do
			if type(k) ~= "number" or k ~= math.floor(k) or k < 1 then
				is_array = false
				break
			end
			if k > max_n then
				max_n = k
			end
		end
		is_array = is_array and (max_n == #val)

		if is_array then
			if #val == 0 then
				return "[]"
			end
			local items = {}
			for _, v in ipairs(val) do
				table.insert(items, inner .. encode_json(v, inner))
			end
			return "[\n" .. table.concat(items, ",\n") .. "\n" .. indent .. "]"
		else
			local keys = {}
			for k in pairs(val) do
				table.insert(keys, k)
			end
			table.sort(keys, function(a, b)
				return tostring(a) < tostring(b)
			end)
			if #keys == 0 then
				return "{}"
			end
			local items = {}
			for _, k in ipairs(keys) do
				local key = encode_json(tostring(k))
				local v = encode_json(val[k], inner)
				table.insert(items, inner .. key .. ": " .. v)
			end
			return "{\n" .. table.concat(items, ",\n") .. "\n" .. indent .. "}"
		end
	else
		-- Type non sérialisable (fonction, userdata…) → null
		return "null"
	end
end

--- Décode un JSON simple en table Lua
--- Délègue à vim.json.decode (disponible depuis Neovim 0.9)
local function decode_json(str)
	local ok, result = pcall(vim.json.decode, str, { luanil = { object = true, array = true } })
	if not ok then
		return nil, "JSON invalide : " .. tostring(result)
	end
	return result
end

-- ---------------------------------------------------------------------------
-- Lecture / écriture du fichier
-- ---------------------------------------------------------------------------

--- Lit le fichier de progression et retourne la table décodée (ou nil)
local function read_file()
	local path = progress_path()
	local f = io.open(path, "r")
	if not f then
		return nil
	end

	local content = f:read("*a")
	f:close()

	if not content or content == "" then
		return nil
	end

	local data, err = decode_json(content)
	if not data then
		vim.notify(
			"[NvCrafted Tutor] Fichier de progression corrompu, réinitialisation.\n" .. (err or ""),
			vim.log.levels.WARN
		)
		return nil
	end
	return data
end

--- Écrit la table dans le fichier de progression
local function write_file(data)
	local path = progress_path()

	-- Crée le dossier parent si nécessaire
	local dir = vim.fn.fnamemodify(path, ":h")
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end

	local f, err = io.open(path, "w")
	if not f then
		vim.notify("[NvCrafted Tutor] Impossible d'écrire la progression : " .. (err or path), vim.log.levels.ERROR)
		return false
	end

	f:write(encode_json(data))
	f:write("\n") -- newline final (convention Unix)
	f:close()
	return true
end

-- ---------------------------------------------------------------------------
-- API publique
-- ---------------------------------------------------------------------------

--- Sauvegarde la leçon courante (et la date de dernière activité)
--- @param lesson_id integer  Index de la leçon (1-based)
function M.save(lesson_id)
	local data = read_file() or {}

	data.lesson_id = lesson_id
	data.updated_at = os.date("!%Y-%m-%dT%H:%M:%SZ") -- ISO 8601 UTC
	-- Mémorise aussi la progression maximale atteinte
	data.max_reached = math.max(lesson_id, data.max_reached or 1)

	write_file(data)
end

--- Charge et retourne l'index de leçon sauvegardé (ou nil si aucun)
--- @return integer|nil
function M.load()
	local data = read_file()
	if not data then
		return nil
	end

	local id = data.lesson_id
	if type(id) ~= "number" or id < 1 then
		return nil
	end
	return math.floor(id)
end

--- Retourne toutes les données de progression (pour affichage dans le menu)
--- @return table  { lesson_id, max_reached, updated_at } ou {}
function M.info()
	return read_file() or {}
end

--- Remet la progression à zéro (avec confirmation)
function M.reset()
	vim.ui.input({ prompt = "Réinitialiser la progression ? (oui/non) : " }, function(input)
		if input and input:lower() == "oui" then
			write_file({ lesson_id = 1, max_reached = 1, updated_at = os.date("!%Y-%m-%dT%H:%M:%SZ") })
			vim.notify("[NvCrafted Tutor] Progression réinitialisée.", vim.log.levels.INFO)
		else
			vim.notify("[NvCrafted Tutor] Réinitialisation annulée.", vim.log.levels.INFO)
		end
	end)
end

return M
