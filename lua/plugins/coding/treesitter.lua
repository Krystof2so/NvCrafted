-- ************************************************************************
-- * GitHub: https://github.com/nvim-treesitter/nvim-treesitter/tree/main *
-- *                                                                      *
-- * Tree-sitter analyse le code via un arbre syntaxique pour fournir une *
-- * coloration syntaxique, l'indentation fiable et éventuellement un     *
-- * folding.                                                             *
-- ************************************************************************


return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,        -- doit être chargé immédiatement
    build = ":TSUpdate", -- installe et met à jour les parsers
    config = function()
      local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
      if not ok then return end  -- si plugin pas disponible

      ts_configs.setup({
        ensure_installed = { "lua", "python", "rust", "toml" },
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,  -- Pour les langages non listés dans ensure_installed
      })
    end,
  }
}

