# Gestion des thèmes dans NvCrafted

**NvCrafted** permet de sélectionner et d'appliquer dynamiquement des thèmes de couleurs. Les thèmes sont gérés via le module `core/theme.lua` et peuvent être choisis via une interface **Telescope** ou directement en modifiant le code.

## Thème principal : Rosé Pine

**NvCrafted** utilise **Rosé Pine** comme thème par défaut. Ce thème propose trois variantes accessibles directement depuis le picker :

| Nom dans le picker | Variante | Ambiance                         |
| ------------------ | -------- | -------------------------------- |
| `rose-pine`        | main     | Sombre, tons chauds et rosés     |
| `rose-pine-moon`   | moon     | Sombre, tons plus froids/violets |
| `rose-pine-dawn`   | dawn     | Clair, tons crème et pastel      |

## Highlights adaptatifs

Les highlights de diagnostics LSP (erreurs, avertissements, infos, hints) s'adaptent automatiquement au thème actif. Le module `core/highlights/diagnostics.lua` détecte la famille du thème courant (`rose-pine`, `nordic`, `evergarden`) et applique la palette correspondante :

- **Rosé Pine** : délègue à la palette officielle du plugin (`love`, `gold`, `foam`, `iris`)
- **Nordic** : palette Nord classique (`#BF616A`, `#EBCB8B`, `#8FBCBB`, `#81A1C1`)
- **Evergarden** : palette Everforest adaptée
- **Autres** : fallback vers les couleurs natives de Neovim

Ce mécanisme est déclenché à deux moments :

1. À l'attachement d'un serveur LSP (via `on_attach`)
2. À chaque changement de thème (via `M.apply` dans `core/theme.lua`)

---

## Sélection d'un thème

### Méthode 1 : Via la commande interactive (recommandé)

- Appuyer sur `<leader>t` (par défaut, `<leader>` est la touche `<Espace>`).
- Une fenêtre **Telescope** s'ouvre avec la liste des thèmes disponibles.
- Naviguer avec `j` / `k` ou `Ctrl+n` / `Ctrl+p` pour sélectionner un thème.
- Le thème est prévisualisé en temps réel pendant la navigation.
- Valider avec `<Entrée>` pour appliquer le thème sélectionné.
- Appuyer sur `<Esc>` ou `q` pour quitter sans appliquer (le thème précédent est restauré).

La fonction `preview_with_telescope()` permet de prévisualiser un thème sans l'appliquer définitivement. Si nous quittons **Telescope** (`<Esc>` ou `q`), le thème précédent est automatiquement restauré — et les highlights de diagnostics sont également restaurés avec lui.

### Méthode 2 : Modification manuelle du thème par défaut

- Éditer `lua/plugins/themes/rose-pine.lua`.
- Modifier la ligne `vim.cmd.colorscheme("rose-pine")` par `"rose-pine-moon"` ou `"rose-pine-dawn"`.
- Mettre à jour `M.default` dans `lua/core/theme.lua` en conséquence.
- Redémarrer **NvCrafted**.

### Systématiquement

- Les plugins comme `lualine`, `neo-tree`, ou `which-key` s'adaptent automatiquement au thème sélectionné via `vim.cmd.colorscheme()`. Aucune configuration supplémentaire n'est nécessaire.
- C'est le thème `rose-pine` (variante main) qui se lance au démarrage de **NvCrafted**.

---

## Structure et localisation des thèmes

- La liste des thèmes disponibles est définie dans `lua/core/theme.lua` (tableau `M.available`).
- Chaque thème est défini dans un fichier **Lua** sous `lua/plugins/themes/[nom_du_thème].lua`.

Exemple : `lua/plugins/themes/rose-pine.lua`

```lua
return {
    "rose-pine/neovim",
    name = "rose-pine",   -- nom du colorscheme (doit correspondre aux entrées dans M.available)
    lazy = false,
    priority = 1000,      -- priorité élevée pour charger le thème en premier
    config = function()
        require("rose-pine").setup({ ... })
        vim.cmd.colorscheme("rose-pine")
    end,
}
```

- Le champ `name` correspond à la famille du thème.
- Les variantes (`rose-pine-moon`, `rose-pine-dawn`) sont des colorschemes distincts fournis par le même plugin.

---

## Ajouter un nouveau thème

### Étape 1 : Installer le plugin du thème

Ajouter le plugin dans `lua/plugins/themes/[nom_du_nouveau_thème].lua` avec `lazy = true` (il n'est pas le thème par défaut) :

```lua
return {
    "author/mytheme.nvim",
    name = "mytheme",
    lazy = true,
    priority = 1000,
}
```

### Étape 2 : Mettre à jour la liste des thèmes disponibles

Éditer `lua/core/theme.lua` et ajouter le nom dans `M.available` :

```lua
M.available = {
    "rose-pine",
    "rose-pine-moon",
    "rose-pine-dawn",
    "nordic",
    "evergarden",
    "mytheme",  -- nouveau thème
}
```

### Étape 3 : Ajouter les highlights de diagnostics (recommandé)

Éditer `lua/core/highlights/diagnostics.lua` et ajouter une branche dans `current_theme_family()` et la fonction de highlights correspondante.

### Étape 4 : Vérifier l'intégration

- Redémarrer **NvCrafted**
- Utiliser `<leader>t` pour vérifier que le nouveau thème apparaît dans la liste **Telescope**.

---

## Thèmes disponibles

| Fichier                 | Thème(s)                                        | Statut     |
| ----------------------- | ----------------------------------------------- | ---------- |
| `themes/rose-pine.lua`  | `rose-pine`, `rose-pine-moon`, `rose-pine-dawn` | **Défaut** |
| `themes/nordic.lua`     | `nordic`                                        | Disponible |
| `themes/everviolet.lua` | `evergarden`                                    | Disponible |
