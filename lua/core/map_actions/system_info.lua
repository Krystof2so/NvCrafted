-- *************************************************************
-- * lua/core/map_actions/system_info.lua                      *
-- *                                                           *
-- * Affiche les informations système de NvCrafted dans un     *
-- * split vertical à droite.                                  *
-- *                                                           *
-- * Appelé depuis core/keymaps.lua (<leader>pv)               *
-- *************************************************************

local M = {}

function M.open()
	-- =========================================================
	-- Collecte des informations
	-- =========================================================
	local v = vim.version()
	local uname = vim.uv.os_uname()

	-- Version de Neovim
	local nvim_version = string.format("v%d.%d.%d", v.major, v.minor, v.patch)

	-- Système d'exploitation (nom complet)
	local os_name = uname.sysname
	if os_name == "Linux" then
		-- Tente de lire /etc/os-release pour le nom de la distribution
		local f = io.open("/etc/os-release", "r")
		if f then
			for line in f:lines() do
				local pretty = line:match('^PRETTY_NAME="(.+)"')
				if pretty then
					os_name = pretty
					break
				end
			end
			f:close()
		end
	end

	-- Version du kernel
	local kernel = uname.release

	-- PID du processus Neovim
	local pid = vim.uv.os_getpid()

	-- Chemin de la configuration
	local config_path = vim.fn.stdpath("config")

	-- Encodage actif
	local encoding = vim.o.fileencoding ~= "" and vim.o.fileencoding or vim.o.encoding

	-- Plugins installés (lazy.nvim)
	local plugin_count = 0
	local ok_lazy, lazy = pcall(require, "lazy")
	if ok_lazy then
		plugin_count = #lazy.plugins()
	end

	-- Serveurs LSP actifs sur le buffer courant
	local lsp_clients = vim.lsp.get_clients({ bufnr = 0 })
	local lsp_names = {}
	for _, client in ipairs(lsp_clients) do
		table.insert(lsp_names, client.name)
	end
	local lsp_display = #lsp_names > 0 and table.concat(lsp_names, ", ") or "aucun"

	-- Serveurs LSP installés via Mason
	local mason_count = 0
	local ok_mason, mason_registry = pcall(require, "mason-registry")
	if ok_mason then
		for _, pkg in ipairs(mason_registry.get_installed_packages()) do
			if pkg.spec.categories and vim.tbl_contains(pkg.spec.categories, "LSP") then
				mason_count = mason_count + 1
			end
		end
	end

    -- Répertoire courant (deux niveaux maximum)
    local cwd = vim.fn.getcwd()
    local cwd_parts = vim.split(cwd, "/", { plain = true })
    local cwd_display
    if #cwd_parts >= 3 then
        cwd_display = "…/" .. cwd_parts[#cwd_parts - 1] .. "/" .. cwd_parts[#cwd_parts]
    elseif #cwd_parts == 2 then
        cwd_display = cwd_parts[#cwd_parts - 1] .. "/" .. cwd_parts[#cwd_parts]
    else
        cwd_display = cwd
    end

	-- =========================================================
	-- Construction du contenu
	-- =========================================================
	local lines = {
		"",
		"  󰅱  Version de Neovim :              " .. nvim_version,
		"  󰻀  Système d'exploitation :         " .. os_name,
		"  󰒋  Version du Kernel :              " .. kernel,
		"  󰈙  Configuration de NvCrafted :     " .. config_path,
		"  󰏔  Encodage actif :                 " .. encoding,
		"",
		"  " .. string.rep("─", 60),
		"",
		"  󰏓  Plugins installés :              " .. plugin_count,
		"  󰒍  LSP Mason installés :            " .. mason_count,
		"  󰒍  LSP actifs :                     " .. lsp_display,
		"",
		"  " .. string.rep("─", 60),
		"",
		"  󰂚  PID du processus de Neovim :     " .. pid,
        "  󰉖  Répertoire courant :             " .. cwd_display,
		"",
	}

	--[[ -- =========================================================
	-- Création et affichage dans un split vertical à droite (si snacks.win pas disponible)
	-- =========================================================
	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].modifiable = true

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false

	vim.cmd("botright vsplit")
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)
	vim.api.nvim_win_set_width(win, 55)

	-- Options de la fenêtre
	vim.wo[win].number = false
	vim.wo[win].relativenumber = false
	vim.wo[win].signcolumn = "no"
	vim.wo[win].wrap = false
	vim.wo[win].cursorline = true

	-- Fermeture avec q
	vim.keymap.set("n", "q", "<cmd>close<CR>", {
		buffer = buf,
		silent = true,
		desc = "Fermer les informations système", ]]

	-- =========================================================
	-- Affichage dans une fenêtre flottante via Snacks.win
	-- =========================================================
	Snacks.win({
		buf = (function()
			local buf = vim.api.nvim_create_buf(false, true)
			vim.bo[buf].buftype = "nofile"
			vim.bo[buf].bufhidden = "wipe"
			vim.bo[buf].swapfile = false
			vim.bo[buf].modifiable = true
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			vim.bo[buf].modifiable = false
			return buf
		end)(),
		width = 0.4,
		height = 0.5,
		border = "double",
		title = "  💻 NvCrafted — Informations système ",
		title_pos = "center",
		footer = "  <q>  fermer ",
		footer_pos = "right",
		wo = {
			number = false,
			relativenumber = false,
			signcolumn = "no",
			wrap = false,
			cursorline = false,
			winhighlight = "Normal:SnacksWinNormal,FloatBorder:SnacksWinBorder,Cursor:None",
		},
		keys = {
			q = "close",
		},
	})
end

return M
