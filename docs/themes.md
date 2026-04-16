# Gestion des thèmes dans NvCrafted

**NvCrafted** permet de sélectionner et d’appliquer dynamiquement des thèmes de couleurs. Les thèmes sont gérés via le module `core/theme.lua` et peuvent être choisis via une interface **Telescope** ou directement en modifiant le code.

## Sélection d’un thème

### Méthode 1 : Via la commande interactive (recommandé)

- Appuyer sur `<leader>t` (par défaut, `<leader>` est la touche `<Espace>`).
- Une fenêtre **Telescope** s’ouvre avec la liste des thèmes disponibles.
- Naviguer avec `j` / `k` ou `Ctrl+n` / `Ctrl+p` pour sélectionner un thème.
- Le thème est prévisualisé en temps réel pendant la navigation.
- Valider avec `<Entrée>` pour appliquer le thème sélectionné.
- Appuyer sur `<Esc>` ou `q` pour quitter sans appliquer (le thème précédent est restauré).

La fonction `preview_with_telescope()` permet de prévisualiser un thème sans l’appliquer définitivement. Si nous quittons **Telescope** (`<Esc>` ou `q`), le thème précédent est automatiquement restauré.

### Méthode 2 : Modification manuelle du thème par défaut

- Éditer le fichier `lua/core/theme.lua`.
- Modifier la ligne : `M.default = "nordic"` pour remplacer "nordic" par le nom du thème souhaité.
- Redémarrer **NvCrafted**.

### Systématiquement

- Les _plugins_ comme `lualine`, `neo-tree`, ou ̀`which-key` s’adaptent automatiquement au thème sélectionné via `vim.cmd.colorscheme()`. Aucune configuration supplémentaire n’est nécessaire.
- A noter que c'est le thème par défaut (à savoir `Nordic`) qui se lance au démarrage de **NvCrafted**.

## Structure et localisation des thèmes

- La liste des thèmes disponibles est définie dans `lua/core/theme.lua` (tableau `M.available`).
- Configuration des thèmes : chaque thème est défini dans un fichier **Lua** sous `lua/plugins/themes/[nom_du_thème].lua`.

Exemple : `lua/plugins/themes/everviolet.lua`

```lua
return {
    "everviolet/nvim",  -- Nom du plugin (pour lazy.nvim)
    name = "evergarden", -- Nom du thème (doit correspondre à une entrée dans `M.available`)
    priority = 1000,     -- Priorité élevée pour charger le thème en premier
    opts = {
        theme = {
            variant = "spring",  -- Variante du thème (si applicable)
        },
    },
}
```

- Le champ `name` doit correspondre à une entrée dans `M.available` (dans l'exemple ci-dessus : `evergarden`).
- Le _plugin_ du thème doit être installé via `lazy.nvim`.

## Ajouter un nouveau thème

### Étape 1 : Installer le _plugin_ du thème

- Ajouter le _plugin_ dans `lua/plugins/themes/[nom_du_nouveau_thème].lua`.
- Donner une `priority = 1000` aux _plugins_ de thème pour qu’ils se chargent avant les autres _plugins_.

### Étape 2 : Mettre à jour la liste des thèmes disponibles

- Éditez `lua/core/theme.lua`.
- Ajouter le nom du thème dans le tableau `M.available` :

```lua
 M.available = {
     "evergarden",
     "nordic",
     "thorn",
     "tokyonight",
     "catppuccin",  -- Ici, une nouveau thème
 }
```

### Étape 3 : (Optionnel) Définir le thème par défaut

Modifier `M.default` dans `lua/core/theme.lua` si l'on souhaite que le nouveau thème soit appliqué par défaut : `M.default = "catppuccin"`.

### Étape 4 : Vérifier l’intégration

- Redémarrer **NvCrafted**
- Utiliser `<leader>t` pour vérifier que le nouveau thème apparaît dans la liste **Telescope**.
