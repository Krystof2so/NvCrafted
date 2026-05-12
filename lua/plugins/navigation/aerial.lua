return {
	"stevearc/aerial.nvim",
	cmd = "AerialOpen",
	keys = { { "<leader>ao", "<cmd>AerialOpen<CR>", desc = "Ouvre Aerial" } },
	opts = {},
	-- Optional dependencies
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
}
