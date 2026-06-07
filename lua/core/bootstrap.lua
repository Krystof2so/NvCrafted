-- **************************************************************
-- * lua/core/bootstrap.lua                                     *
-- *                                                            *
-- * Infrastructure de démarrage pour NvCrafted                 *
-- * Garantit :                                                 *
-- * - La version minimale de Neovim (0.11.0)                   *
-- * - la présence et le chargement de lazy.nvim                *
-- **************************************************************

local fn = vim.fn
local api = vim.api

-- ========================================
-- 1. Vérification de la version de Neovim
-- ========================================
-- FIX: Décalage de version avec README
local required_neovim_version = "0.12.2"
if fn.has("nvim-" .. required_neovim_version) ~= 1 then
	api.nvim_echo({
		{ "NvCrafted nécessite Neovim >= " .. required_neovim_version .. "\n", "ErrorMsg" },
		{ "Votre version : " .. vim.version().version .. "\n", "WarningMsg" },
		{ "Appuyez sur une touche pour quitter...", "Normal" },
	}, true, {})
	fn.getchar()
	os.exit(1)
end

-- =========================================
-- 2. Installation automatique de lazy.nvim
-- =========================================
-- Chemin d'installation de lazy.nvim :
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Utilisation de vim.uv (Neovim ≥ 0.10) ou fallback vers vim.loop :
local uv = vim.uv or vim.loop
-- Si lazy.nvim n'est pas présent, on le clone automatiquement
if not uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local sortie = fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	-- Gestion d'erreur en cas d'échec du clonage :
	if vim.v.shell_error ~= 0 then
		api.nvim_echo({
			{ "Échec du clonage de lazy.nvim :\n", "ErrorMsg" },
			{ sortie, "WarningMsg" },
			{ "\nAppuyez sur une touche pour quitter..." },
		}, true, {})
		fn.getchar()
		os.exit(1)
	end
end
-- Ajout de lazy.nvim en tête du runtimepath
vim.opt.rtp:prepend(lazypath)
