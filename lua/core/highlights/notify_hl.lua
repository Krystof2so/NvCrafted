-- *************************************************************
-- * core/highlights/notify_hl.lua                             *
-- *                                                           *
-- * Highlights de nvim-notify pour NvCrafted.                 *
-- * Consomme core/highlights/themes/                          *
-- *                                                           *
-- * Groupes couverts par niveau (ERROR/WARN/INFO/DEBUG/TRACE) *
-- *   Notify<LEVEL>Border  → bordure de la notification       *
-- *   Notify<LEVEL>Icon    → icône du niveau                  *
-- *   Notify<LEVEL>Title   → titre de la notification         *
-- *   Notify<LEVEL>Body    → corps du message (lien Normal)   *
-- *                                                           *
-- * Appelé depuis core/highlights/init.lua                    *
-- *************************************************************

local M = {}

function M.setup()
    local p  = require("core.highlights.themes").get()
    local hl = vim.api.nvim_set_hl

    -- ========================
    -- ERROR
    -- ========================
    hl(0, "NotifyERRORBorder", { fg = p.error.hex,   bg = p.surface.hex })
    hl(0, "NotifyERRORIcon",   { fg = p.error.hex })
    hl(0, "NotifyERRORTitle",  { fg = p.error.hex,   bold = true })
    hl(0, "NotifyERRORBody",   { link = "Normal" })

    -- ========================
    -- WARN
    -- ========================
    hl(0, "NotifyWARNBorder",  { fg = p.warning.hex, bg = p.surface.hex })
    hl(0, "NotifyWARNIcon",    { fg = p.warning.hex })
    hl(0, "NotifyWARNTitle",   { fg = p.warning.hex, bold = true })
    hl(0, "NotifyWARNBody",    { link = "Normal" })

    -- ========================
    -- INFO
    -- ========================
    hl(0, "NotifyINFOBorder",  { fg = p.info.hex,    bg = p.surface.hex })
    hl(0, "NotifyINFOIcon",    { fg = p.info.hex })
    hl(0, "NotifyINFOTitle",   { fg = p.info.hex,    bold = true })
    hl(0, "NotifyINFOBody",    { link = "Normal" })

    -- ========================
    -- DEBUG
    -- ========================
    hl(0, "NotifyDEBUGBorder", { fg = p.muted.hex,   bg = p.surface.hex })
    hl(0, "NotifyDEBUGIcon",   { fg = p.muted.hex })
    hl(0, "NotifyDEBUGTitle",  { fg = p.muted.hex,   bold = true })
    hl(0, "NotifyDEBUGBody",   { link = "Normal" })

    -- ========================
    -- TRACE
    -- ========================
    hl(0, "NotifyTRACEBorder", { fg = p.hint.hex,    bg = p.surface.hex })
    hl(0, "NotifyTRACEIcon",   { fg = p.hint.hex })
    hl(0, "NotifyTRACETitle",  { fg = p.hint.hex,    bold = true })
    hl(0, "NotifyTRACEBody",   { link = "Normal" })
end

return M
