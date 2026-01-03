-- lua/plugins/lsp/config/ruff.lua
return {
  settings = {
    python = {
      linting = {
        enabled = true,
        ruffEnabled = true,
        ruffPath = "ruff",  -- Mason va installer Ruff ici : ~/.local/share/nvim/mason/bin/ruff
      },
    },
  },
}

