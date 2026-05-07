-- ****************************************************
-- * lua/plugins/coding/comment_nvim.lua              *
-- * Github: https://github.com/numToStr/Comment.nvim *
-- *                                                  *
-- * Plugin de commentaires intelligent et            *
-- * performant pour Neovim                           *
-- ****************************************************

return {
	{
		"numToStr/Comment.nvim",
		event = "BufReadPost", -- chargement différé (à l'ouverture d'un buffer)
		dependencies = {
			-- Intégration Tree-sitter pour la détection contextuelle du langage
			-- (indispensable pour les fichiers mixtes : HTML/CSS, Vue, Svelte…)
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		opts = {
			-- ================================================================
			-- Comportement général
			-- ================================================================
			padding = true, -- ajoute un espace entre le symbole de commentaire et le texte
			sticky = true, -- maintient le curseur sur sa ligne après le commentaire
			ignore = "^%s*$", -- ignore les lignes vides (motif Lua)
			-- ================================================================
			-- Mappings (valeurs par défaut conservées)
			-- ================================================================
			toggler = {
				line = "gcc", -- bascule le commentaire ligne
				block = "gbc", -- bascule le commentaire bloc
			},
			opleader = {
				line = "gc", -- opérateur ligne (ex: gc3j pour commenter 3 lignes)
				block = "gb", -- opérateur bloc
			},
			extra = {
				above = "gcO", -- insère un commentaire ligne au-dessus
				below = "gcA", -- insère un commentaire ligne en dessous (fin de ligne)
				eol = "gco", -- insère un commentaire en fin de ligne courante
			},
			mappings = {
				basic = true, -- active gcc, gbc, gc{motion}, gb{motion}
				extra = true, -- active gcO, gco, gcA
			},
			-- ================================================================
			-- Hook pre_hook : délègue la détection du commentstring à
			-- nvim-ts-context-commentstring pour les fichiers à langages
			-- injectés (Vue, Svelte, HTML avec JS/CSS embarqués, etc.)
			-- Sans ce hook, gcc utiliserait le commentstring du langage
			-- principal, ce qui produit des commentaires incorrects dans
			-- les blocs <script> ou <style>.
			-- ================================================================
			pre_hook = function(ctx)
				local ok, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
				if ok then
					return ts_comment.create_pre_hook()(ctx)
				end
			end,
		},
	},
}
