-- *************************************************************
-- * core/highlights/themes/rose_pine.lua                      *
-- *                                                           *
-- * Palette Rosé Pine pour NvCrafted.                         *
-- * Couvre les trois variantes : main, moon, dawn.            *
-- * Consommée par core/highlights/themes/init.lua             *
-- *************************************************************

return {
    error   = { group = "DiagnosticError", hex = "#eb6f92" }, -- love
    warning = { group = "DiagnosticWarn",  hex = "#f6c177" }, -- gold
    info    = { group = "DiagnosticInfo",  hex = "#9ccfd8" }, -- foam
    hint    = { group = "DiagnosticHint",  hex = "#c4a7e7" }, -- iris
    default = { group = "Identifier",      hex = "#ebbcba" }, -- rose
    test    = { group = "Identifier",      hex = "#31748f" }, -- pine
    surface = { group = "Normal",          hex = "#1f1d2e" },
    overlay = { group = "NormalFloat",     hex = "#26233a" },
    text    = { group = "Normal",          hex = "#e0def4" },
    muted   = { group = "Comment",         hex = "#6e6a86" },
}
