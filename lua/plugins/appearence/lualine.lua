-- **********************************************************
-- * Github : https://github.com/nvim-lualine/lualine.nvim  *
-- *                                                        *
-- * Lualine est un plugin qui permet de créer une barre de *
-- * statut (statusline) rapide et personnalisable.         *
-- **********************************************************

return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()

            vim.api.nvim_set_hl(0, 'LualineModified', { fg = '#D08770' })  -- highlight du symbole "modifié"                    

            require('lualine').setup({
                options = {
                    theme = 'auto',                                   -- Thème automatique basé sur le colorscheme
                    component_separators = { left = '', right = ''},
                    section_separators = { left = '', right = ''},
                    icons_enabled = true,                             -- Activer les icônes
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = {
                        {  -- Affichage du type de fichier
                            'filetype',
                            colored = true,                           -- Pour colorer l'icône
                            icon_only = true,                         -- n'affiche que l'icône
                        },
                        { -- Affichage du nom de fichier avec symbole modifié ou lecture seule si besoin
                            'filename',
                            symbols = {
                                modified = "%#LualineModified#●", -- Pour indiquer que le fichier est modifié
                                readonly = "🔒"                   -- Pour indiquer que le fichier est en lecture seule
                            },
                        },
                    },
                    lualine_x = {'location'},
                    lualine_y = {'progress'},
                    lualine_z = {
                        {
                            function()
                                return os.date('%H:%M')  -- Affiche l'heure en format 24h
                            end,
                            icon = ' ',
                        }
                    }
                },
                inactive_sections = {
                    lualine_c = {'filename'},
                    lualine_x = {'location'},
                },
            })
        end
    },
}
