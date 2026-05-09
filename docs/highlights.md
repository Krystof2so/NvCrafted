# Gestion des _highlights_ dans NvCrafted

**NvCrafted** centralise la gestion des couleurs et des _highlights_ dans le module `core/highlights/`. L'objectif est de garantir qu'à chaque changement de thème, l'ensemble des _plugins_ s'adaptent automatiquement sans aucune intervention manuelle.

---

## Philosophie

La gestion des _highlights_ repose sur trois principes :

- **Une source de vérité unique** : toutes les couleurs sont définies dans `core/highlights/palettes.lua`. Aucun fichier _plugin_ ne contient de couleur codée en dur.
- **Une responsabilité = un fichier** : chaque _plugin_ disposant de _highlights_ spécifiques possède son propre module dans `core/highlights/`.
- **Un point d'entrée unique** : `core/highlights/init.lua` orchestre l'application de tous les _highlights_. C'est le seul fichier appelé depuis l'extérieur.

---

## Architecture

```text
core/highlights/
├── palettes.lua           ← source de vérité des couleurs par famille de thème
├── init.lua               ← point d'entrée : orchestre tous les modules
├── diagnostics.lua        ← highlights LSP (erreurs, avertissements, hints)
├── blink_hl.lua           ← highlights blink.cmp et fenêtres flottantes LSP
├── todo_comments_hl.lua   ← highlights todo-comments.nvim
├── which_key_hl.lua       ← highlights which-key.nvim
└── neo_tree_hl.lua        ← highlights neo-tree.nvim
```

---

## La source de vérité : `palettes.lua`

Ce fichier définit une palette par famille de thème. Chaque entrée expose deux valeurs :

| Clé     | `group`                   | `hex`       |
| ------- | ------------------------- | ----------- |
| `error` | groupe de highlight natif | couleur hex |

Les clés sémantiques disponibles dans chaque palette :

| Clé       | Usage sémantique                              |
| --------- | --------------------------------------------- |
| `error`   | Erreurs, diagnostics critiques                |
| `warning` | Avertissements, accentuation forte            |
| `info`    | Informations, bordures, éléments actifs       |
| `hint`    | Suggestions, raccourcis, éléments secondaires |
| `default` | Identifiants, éléments neutres                |
| `test`    | Tests, états spéciaux                         |
| `surface` | Fond des fenêtres flottantes                  |
| `overlay` | Fond des popups, éléments surposés            |
| `text`    | Texte principal                               |
| `muted`   | Texte atténué, commentaires, footer           |

### Familles de thèmes supportées

| Famille      | Thèmes couverts                                     |
| ------------ | --------------------------------------------------- |
| `rose-pine`  | `rose-pine`, `rose-pine-moon`, `rose-pine-dawn`     |
| `nordic`     | `nordic`                                            |
| `evergarden` | `evergarden`                                        |
| `default`    | Tout autre thème (fallback vers les groupes natifs) |

### API publique

```lua
local palettes = require("core.highlights.palettes")

-- Retourne la palette complète du thème actif
local p = palettes.get()

-- Retourne la famille du thème actif
local family = palettes.current_family()  -- ex: "rose-pine"

-- Retourne une couleur spécifique
local color = palettes.get_color("error") -- { group = "...", hex = "..." }
```

---

## Le point d'entrée : `init.lua`

`core/highlights/init.lua` est le **seul fichier appelé depuis l'extérieur**. Il orchestre l'application de tous les modules via `pcall` pour éviter tout crash si un _plugin_ n'est pas encore chargé.

```lua
function M.setup()
    pcall(function() require("core.highlights.diagnostics").setup()   end)
    pcall(function() require("core.highlights.todo_comments_hl").setup() end)
    pcall(function() require("core.highlights.blink_hl").setup()         end)
    pcall(function() require("core.highlights.which_key_hl").setup()     end)
    pcall(function() require("core.highlights.neo_tree_hl").setup()      end)
end
```

### Points d'appel

`init.lua` est appelé depuis deux endroits :

| Fichier                  | Moment d'appel                        |
| ------------------------ | ------------------------------------- |
| `core/theme.lua`         | À chaque changement de thème          |
| `core/lsp/on_attach.lua` | À chaque attachement d'un serveur LSP |

```lua
-- core/theme.lua
function M.apply(theme)
    vim.cmd.colorscheme(theme)
    pcall(function()
        require("core.highlights").setup()
    end)
end

-- core/lsp/on_attach.lua
require("core.highlights").setup()
```

---

## Les modules de highlights

### `diagnostics.lua` — Highlights LSP

Gère les couleurs des diagnostics LSP : erreurs, avertissements, infos, hints, soulignements et texte virtuel.

**Comportement spécifique à Rosé Pine** : le plugin officiel définit déjà ses propres groupes de diagnostic via sa palette (`love`, `gold`, `foam`, `iris`). Le module délègue donc à ces groupes natifs et n'applique que des ajustements mineurs, pour éviter tout conflit.

Pour les autres familles, les couleurs sont appliquées explicitement depuis la palette.

---

### `blink_ls.lua` — _Highlights_ `blink.cmp`

Gère les fenêtres flottantes du menu de complétion et de la documentation LSP.

Groupes appliqués :

| Groupe                  | Usage                                 |
| ----------------------- | ------------------------------------- |
| `LspFloatBorder`        | Bordure des fenêtres flottantes LSP   |
| `LspFloatWinNormal`     | Fond et texte des fenêtres flottantes |
| `BlinkCmpMenuBorder`    | Bordure du menu de complétion         |
| `BlinkCmpDocBorder`     | Bordure de la documentation           |
| `BlinkCmpMenuSelection` | Élément sélectionné dans le menu      |

---

### `todo_comments_hl.lua` — _Highlights_ `todo-comments.nvim`

Construit la table `colors` attendue par `todo-comments.setup()` à partir de la palette active. Chaque entrée combine le groupe de _highlight_ natif et la couleur en hexadécimal, ce qui permet à `todo-comments` d'utiliser l'une ou l'autre selon le contexte.

---

### `which_key.lua` — _Highlights_ `which-key.nvim`

Cas particulier : les _highlights_ de `which-key` utilisent exclusivement des `link` vers des groupes natifs Neovim. Ils s'adaptent donc automatiquement à tout thème sans nécessiter de palette codée.

| Groupe              | Lié à         |
| ------------------- | ------------- |
| `WhichKeyDesc`      | `Identifier`  |
| `WhichKeyGroup`     | `Function`    |
| `WhichKeySeparator` | `Comment`     |
| `WhichKeyValue`     | `Comment`     |
| `WhichKeyBorder`    | `FloatBorder` |
| `NormalFloat`       | `Normal`      |

---

### `neo_tree_hl.lua` — _Highlights_ `neo-tree.nvim`

Gère les fenêtres flottantes de prévisualisation de **neo-tree**.

| Groupe               | Usage                             | Couleur palette    |
| -------------------- | --------------------------------- | ------------------ |
| `NeoTreeFloatNormal` | Fond du popup de prévisualisation | `surface`          |
| `NeoTreeFloatBorder` | Bordure du popup                  | `warning`          |
| `NeoTreeFloatTitle`  | Titre du popup                    | `overlay` + `text` |
| `NeoTreeTitleBar`    | Barre de titre                    | `overlay` + `info` |

---

## Ajouter un nouveau module de highlights

L'ajout d'un _plugin_ nécessitant des _highlights_ adaptatifs suit toujours le même _pattern_ en trois étapes.

### 1. Créer le module

```lua
-- core/highlights/mon_plugin.lua
local M = {}

function M.setup()
    local p  = require("core.highlights.palettes").get()
    local hl = vim.api.nvim_set_hl

    hl(0, "MonPluginBorder", { fg = p.info.hex, bg = p.surface.hex })
    -- ...
end

return M
```

### 2. Supprimer les couleurs codées en dur du fichier plugin

```lua
-- plugins/.../mon_plugin.lua
-- Supprimer tout bloc vim.api.nvim_set_hl(...)
-- Ajouter une note de délégation dans l'en-tête
```

### 3. Enregistrer dans `init.lua`

```lua
-- core/highlights/init.lua
pcall(function() require("core.highlights.mon_plugin").setup() end)
```

---

## Séparation des responsabilités

| Fichier                          | Rôle                                       |
| -------------------------------- | ------------------------------------------ |
| `core/highlights/palettes.lua`   | Données pures — aucune logique             |
| `core/highlights/init.lua`       | Orchestration — aucune couleur             |
| `core/highlights/<plugin>.lua`   | Application des highlights d'un plugin     |
| `plugins/<domaine>/<plugin>.lua` | Déclaration Lazy — aucune couleur codée    |
| `core/theme.lua`                 | Déclenchement à chaque changement de thème |
