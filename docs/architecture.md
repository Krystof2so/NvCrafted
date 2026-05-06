# Architecture de NvCrafted — Décisions de conception

Ce document explique les choix structurants de **NvCrafted** : pourquoi telle séparation, pourquoi tel fichier, pourquoi cet ordre. Il complète les commentaires dans le code en documentant le _pourquoi_ là où le code documente le _comment_.

---

## 1. `core/` est indépendant des _plugins_

### Décision

Tout ce qui relève de la configuration fondamentale de **Neovim** vit dans `core/`, sans aucune dépendance à un _plugin_ externe.

### Pourquoi

`core/` est chargé avant `lazy.setup()`. Si un module `core/` dépendait d'un _plugin_, il échouerait silencieusement au premier lancement (avant que **Lazy** ait pu installer quoi que ce soit).

Cette contrainte devient une règle de conception : `core/` doit pouvoir s'exécuter dans un **Neovim** nu, sans _plugin_.

### Conséquence

Les options, les _leaders_, les autocommandes et les raccourcis globaux sont garantis en place avant l'initialisation de tout _plugin_. C'est l'ordre observé dans `init.lua` :

```lua
require("core.options")
require("core.keymaps")
require("core.autocmds")
-- puis seulement :
require("lazy").setup("plugins")
```

---

## 2. _Bootstrap_ isolé dans `core/bootstrap.lua`

### Décision

La logique d'installation de **lazy.nvim** est isolée dans `core/bootstrap.lua`, appelé en tout premier dans `init.lua`.

### Pourquoi

Le _bootstrap_ est une opération d'infrastructure, pas de configuration. Il vérifie la présence de **lazy.nvim**, le clone si absent, gère l'erreur de clonage et prépare le `runtimepath` (liste des dossiers dans lesquels **Neovim** cherche ses fichiers de configuration, _plugins_, scripts et ressources au démarrage). Mélanger cette logique avec la configuration dans `init.lua` nuirait à la lisibilité de ce dernier.

`init.lua` reste ainsi purement déclaratif — il décrit _ce que fait_ **NvCrafted**, pas _comment installer ses dépendances_.

### Détail technique

Le _bootstrap_ utilise `vim.uv` (Neovim ≥ 0.10) avec un fallback (alternative de repli) vers `vim.loop` pour la vérification de présence de **lazy.nvim** :

```lua
local uv = vim.uv or vim.loop
if not uv.fs_stat(lazypath) then
  -- clone lazy.nvim...
end
```

---

## 3. Scan automatique des sous-dossiers dans `plugins/init.lua`

### Décision

Aucun _plugin_ n'est déclaré manuellement dans `plugins/init.lua`. Un scan automatique du dossier `lua/plugins/` génère dynamiquement la spec **Lazy**.

### Pourquoi

Une déclaration manuelle imposerait de modifier `plugins/init.lua` à chaque ajout ou suppression de plugin. Avec le scan automatique,
ajouter un fichier dans le bon sous-dossier suffit.

`plugins/init.lua` ne connaît pas les _plugins_ — il connaît uniquement les _domaines fonctionnels_ (sous-dossiers).

### Fonctionnement

```lua
-- Chaque sous-dossier devient une entrée Lazy :
{ import = "plugins.coding" }
{ import = "plugins.ui" }
{ import = "plugins.lsp" }
{ import = "plugins.tools" }
```

**Lazy** se charge ensuite de résoudre tous les fichiers dans chaque sous-dossier.

---

## 4. Dualité spécification / déclaration (`conform.nvim`)

### Décision

Certains _plugins_ dont la configuration implique de la logique métier sont scindés en deux fichiers :

| Fichier                      | Rôle                            |
| ---------------------------- | ------------------------------- |
| `plugins/coding/conform.lua` | Déclaration **Lazy** uniquement |
| `core/format/conform.lua`    | Logique réelle de configuration |

### Pourquoi

La logique de `conform.nvim` — sélection dynamique du formateur **Python**, formatage automatique à la sauvegarde via autocommands — ne se résume pas à des options statiques.

Par exemple, pour la sélection dynamique du formateur **Python** : si **ruff_format** est disponible, on l'utilise, sinon on bascule sur **isort + black**.

La placer dans `core/` permet :

- de la lire et la tester indépendamment de **Lazy**
- de la réutiliser depuis d'autres modules si nécessaire
- de garder le fichier _plugin_ court et déclaratif

### Règle d'application

Cette convention s'applique quand la configuration contient des conditions, des fonctions ou des autocommandes. Un _plugin_ dont la configuration tient en quelques options statiques reste entièrement dans son fichier `plugins/`.

---

## 5. `on_attach` et `capabilities` comme modules autonomes

### Décision

`on_attach` et `capabilities` vivent dans des fichiers dédiés (`core/lsp/on_attach.lua`, `core/lsp/capabilities.lua`), injectés dans chaque serveur par l'orchestrateur `plugins/lsp/init.lua`.

### Pourquoi — `on_attach`

`on_attach` est appelé à chaque attachement d'un serveur **LSP** à un _buffer_. Il définit des _mappings_ et comportements **buffer-local** : ils ne doivent s'activer que lorsqu'un **LSP** est présent, jamais globalement.

Isoler `on_attach` garantit :

- qu'aucun raccourci **LSP** ne pollue les _buffers_ sans **LSP**
- qu'une modification des _mappings_ **LSP** ne touche qu'un seul fichier
- que les _highlights_ de diagnostic sont initialisés au bon moment

### Pourquoi — `capabilities`

Les _capabilities_ décrivent le contrat entre **Neovim** (client) et chaque serveur **LSP**. Elles sont identiques pour tous les serveurs et doivent être définies une seule fois.

Les _capabilities_ déclarées dans **NvCrafted** enrichissent celles fournies par défaut par **Neovim** :

- support des _snippets_
- formats de documentation (`markdown`, `plaintext`)
- encodages de position (`utf-8`, `utf-16`, `utf-32`)

Centraliser les _capabilities_ évite toute divergence entre serveurs et constitue l'identité du client **LSP** de **NvCrafted**.

---

## 6. `servers.lua` et `tools.lua` comme sources de vérité

### Décision

Tout ce qui doit être installé par **Mason** est déclaré dans deux fichiers sans logique (ne contiennent que des données):

| Fichier                | Contenu                              |
| ---------------------- | ------------------------------------ |
| `core/lsp/servers.lua` | Serveurs LSP                         |
| `core/lsp/tools.lua`   | Outils non-LSP (formateurs, linters) |

### Pourquoi

Centraliser les déclarations d'installation évite la dispersion : un outil déclaré dans un fichier _plugin_ serait invisible depuis un autre contexte.

Ces fichiers sont les seuls endroits où chercher ce qui est installé sur le système via **Mason**. Supprimer une ligne = désinstaller. Ajouter une ligne = installer. Aucune logique, aucun effet de bord.
