-- *************************************************************
-- * core/highlights/init.lua                                  *
-- *                                                           *
-- * Point d'entrée des highlights adaptatifs de NvCrafted.    *
-- * Appelé depuis core/theme.lua à chaque changement de thème.*
-- * Orchestre l'application de tous les modules de highlights. *
-- *************************************************************

local M = {}

function M.setup()
	pcall(function()
		require("core.highlights.diagnostics").setup()
	end)
	pcall(function()
		require("core.highlights.todo_comments_hl").setup()
	end)
	pcall(function()
		require("core.highlights.blink_hl").setup()
	end)
	pcall(function()
		require("core.highlights.which_key_hl").setup()
	end)
	pcall(function()
		require("core.highlights.neo_tree_hl").setup()
	end)
	pcall(function()
		require("core.highlights.telescope_hl").setup()
	end)
	pcall(function()
		require("core.highlights.alpha_hl").setup()
	end)
end

return M
