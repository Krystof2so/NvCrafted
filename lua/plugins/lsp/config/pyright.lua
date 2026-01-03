-- lua/plugins/lsp/config/pyright.lua
return {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "strict",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",

        reportUnusedImport = true,
        reportUnusedVariable = "warning",
        reportUnboundVariable = "error",
        reportMissingTypeStubs = "warning",
        reportOptionalSubscript = "warning",
        reportOptionalMemberAccess = "warning",
        reportGeneralTypeIssues = true,
        reportFunctionMemberAccess = true,
      },
      pythonPath = ".venv/bin/python",
    },
  },
}

