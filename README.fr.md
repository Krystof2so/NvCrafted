<p align="center">
  🇬🇧 <a href="README.md">Read the README in English</a>
</p>

---

# NvCrafted

Une configuration [Neovim](https://neovim.io/) façonnée à la main, pensée pour être comprise, étendue et maîtrisée.

## Présentation

Ce dépôt contient une configuration **Neovim** se voulant moderne, lisible et hautement modulaire, pensée comme une base évolutive pour construire un environnement de développement proche d’un IDE.

Les objectifs principaux du projet sont :

- 🧩 **Modularité maximale** : chaque fonctionnalité est isolée dans un fichier clairement identifié.
- 🧠 **Lisibilité et pédagogie** : la configuration doit rester compréhensible, même en y revenant plusieurs mois après.
- 🚀 **Scalabilité** : l’ajout d’un plugin ou d’une surcouche LSP se fait via un simple fichier.
- 🔧 **Approche déclarative** : [Lazy.nvim](https://lazy.folke.io/) est utilisé comme gestionnaire central.

Une fois la structure posée, la maintenance se résume essentiellement à **ajouter ou ajuster des modules**, sans modifier le cœur de la configuration.

Ce projet demeure en construction...

---

## Outillage de base nécessaire

- **Neovim ≥ 0.11**
- [Lua](https://www.lua.org/) comme langage de configuration
- **lazy.nvim** : gestionnaire de plugins
- [mason.nvim](https://github.com/mason-org/mason.nvim) / [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) : installation et gestion des LSP
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) (via l’API `vim.lsp`)
- [Tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter) pour l’analyse syntaxique
- [Lazydev.nvim](https://github.com/folke/lazydev.nvim) pour améliorer l'expérience **LSP** **Lua** avec les fichiers de configuration.
- [nerdfonts](https://www.nerdfonts.com/)

---

## Arborescence du projet

```text
 .
├──  docs
│   ├──  architecture.md
│   ├──  autocommands.md
│   ├──  commands.md
│   ├──  highlights.md
│   ├──  lsp-nvcrafted.md
│   └──  themes.md
├──  init.lua
├──  lazy-lock.json
├──  lua
│   ├──  core
│   │   ├──  autocmds.lua
│   │   ├──  bootstrap.lua
│   │   ├──  format
│   │   │   └──  conform.lua
│   │   ├──  highlights
│   │   │   ├──  blink_hl.lua
│   │   │   ├──  diagnostics.lua
│   │   │   ├──  init.lua
│   │   │   ├──  neo_tree_ls.lua
│   │   │   ├──  palettes.lua
│   │   │   ├──  todo_comments_hl.lua
│   │   │   └──  which_key_ls.lua
│   │   ├──  keymaps.lua
│   │   ├──  lsp
│   │   │   ├──  capabilities.lua
│   │   │   ├──  on_attach.lua
│   │   │   ├──  servers.lua
│   │   │   └──  tools.lua
│   │   ├──  options.lua
│   │   ├──  spell.lua
│   │   └──  theme.lua
│   ├──  nvcrafted
│   │   └──  tutor
│   │       ├──  docs.lua
│   │       ├──  init.lua
│   │       ├──  progress.lua
│   │       └──  tutor.lua
│   └──  plugins
│       ├──  appearence
│       │   ├──  alpha.lua
│       │   ├──  barbar.lua
│       │   ├──  everviolet.lua
│       │   ├──  lualine.lua
│       │   ├──  nordic.lua
│       │   └──  rose-pine.lua
│       ├──  editing
│       │   ├──  autopairs.lua
│       │   ├──  blink.lua
│       │   ├──  comment_nvim.lua
│       │   ├──  conform.lua
│       │   ├──  lazydev.lua
│       │   ├──  neogen.lua
│       │   ├──  todo_comments.lua
│       │   └──  treesitter.lua
│       ├──  init.lua
│       ├──  lsp
│       │   ├──  config
│       │   │   ├──  lua_ls.lua
│       │   │   ├──  pyright.lua
│       │   │   └──  ruff.lua
│       │   ├──  init.lua
│       │   └──  mason.lua
│       ├──  meta
│       │   └──  tutor.lua
│       ├──  navigation
│       │   ├──  aerial.lua
│       │   ├──  neo_tree.lua
│       │   ├──  telescope.lua
│       │   └──  trouble.lua
│       └──  ux
│           ├──  noice.lua
│           ├──  which_key.lua
│           └──  zen-mode.lua
├──  README.fr.md
├── 󰂺 README.md
├──  snippets
│   └──  python.json
└──  tutor_lessons
    ├──  01-Les-modes.md
    ├──  02-Navigation-de-base.md
    └──  03-La-grammaire-de-Neovim.md
```

---

## Le répertoire `docs/`

**NvCrafted** dispose d'une documentation technique complémentaire au `README`, organisée par thématique dans le dossier `docs/`.

| Fichier            | Contenu                                                                                                                                       |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------- |
| `autocommands.md`  | Description des groupes d'autocommandes définis dans `core/autocmds.lua`                                                                      |
| `commands.md`      | Liste des commandes disponibles dans **NvCrafted**                                                                                            |
| `lsp-nvcrafted.md` | Architecture complète du support **LSP** : flux d'installation, orchestration, rôle de `on_attach` et `capabilities`, conventions d'extension |
| `architecure.md`   | Explication de la conception architecturale de **NvCrafted**                                                                                  |
| `themes.md`        | Explications sur installation et gestion des thèmes                                                                                           |

---

## `init.lua` (racine)

Point d’entrée principal (purement déclaratif):

- bootstrap de **lazy.nvim** via `core.bootstrap` (isolation de la logique d'installation de **lazy.nvim**)
- définition des leaders
- chargement des modules `core`
- initialisation de **Lazy** avec l’import automatique des plugins

### Flux de démarrage

```text
init.lua (racine)
  │
  ├── core.bootstrap
  │     └── installe lazy.nvim si absent
  │
  ├── configuration système
  │     ├── désactivation des providers inutiles (Perl, Ruby)
  │     ├── Python dédié Neovim (~/.venvs/neovim)
  │     └── ajout de Mason au PATH
  │
  ├── leader keys (Space / Backslash)
  │
  ├── modules core/ (indépendants des plugins)
  │     ├── core.spell
  │     ├── core.options
  │     ├── core.keymaps
  │     └── core.autocmds
  │
  └── lazy.setup("plugins")
        └── plugins/init.lua
              └── scan automatique des sous-dossiers
                    ├── plugins/appearence/
                    ├── plugins/editing/
                    ├── plugins/meta/
                    ├── plugins/lsp/
                    │     └── init.lua
                    │           ├── servers.lua → activation LSP
                    │           └── tools.lua  → outils Mason
                    ├── plugins/navigation/
                    └── plugins/ux
```

L'ordre est intentionnel : les modules `core/` sont chargés avant **Lazy**, garantissant que les options et les _leaders_ sont en place avant l'initialisation de tout _plugin_.

---

## Le répertoire `core/`

Contient la **configuration fondamentale de Neovim**, indépendante des plugins.

| Fichier           | Rôle                              |
| ----------------- | --------------------------------- |
| `options.lua`     | Options Neovim (`vim.opt`)        |
| `keymaps.lua`     | Raccourcis clavier globaux        |
| `autocmds.lua`    | Autocommandes                     |
| `spell.lua`       | Dictionnaire personnalisé         |
| `bootstrap.lua`   | Démarrage **lazy.nvim**           |
| `lsp/servers.lua` | Source de vérité des serveurs LSP |

👉 Ces fichiers ne dépendent d’aucun plugin et peuvent être lus comme une « configuration Neovim pure ».

---

## Conventions d’extension

### Ajouter un _plugin_

1. Crée un fichier **Lua** dans le dossier correspondant, par exemple :
   - `lua/plugins/ux/` concerne l'ergonomie
   - `lua/plugins/editing/` concerne l'édition
   - `lua/plugins/navigation/` concerne la navigation

2. Le fichier doit retourner une table compatible **Lazy.nvim**. Exemple minimal :

```lua
return {
  "author/pluginname.nvim",
  config = function()
    -- configuration spécifique du plugin ici
  end
}
```

### Convention : spécification vs déclaration

Certains _plugins_ impliquent une logique de configuration suffisamment riche pour justifier un fichier dédié dans `core/`. **NvCrafted** applique alors une séparation en deux niveaux :

| Niveau        | Fichier                          | Rôle                                                             |
| ------------- | -------------------------------- | ---------------------------------------------------------------- |
| Déclaration   | `plugins/<domaine>/<plugin>.lua` | Déclare le _plugin_ auprès de **Lazy**, délègue la configuration |
| Spécification | `core/<domaine>/<plugin>.lua`    | Contient la logique réelle, indépendante de **Lazy**             |

#### Exemple : `conform.nvim`

`plugins/editing/conform.lua` se limite à déclarer le _plugin_ et à appeler le module `core` :

```lua
return {
  "stevearc/conform.nvim",
  opts = function()
    require("core.format.conform").setup()
  end,
}
```

Toute la logique réelle — formateurs par type de fichier, sélection dynamique **Python**, formatage automatique à la sauvegarde — vit dans `core/format/conform.lua`.

#### Quand appliquer cette convention ?

- La configuration du _plugin_ contient de la _logique métier_ (conditions, fonctions, autocommandes).
- Elle est susceptible d'être _réutilisée_ par d'autres modules.
- On veut qu'elle reste _lisible et testable_ indépendamment du cycle de vie de **Lazy**.

Un _plugin_ dont la configuration tient en quelques lignes d'options statiques n'a pas besoin de ce découpage : `opts = { ... }` directement dans le fichier _plugin_ suffit.

### `opts` vs `config` dans Lazy.nvim

**Lazy.nvim** propose deux façons de configurer un _plugin_. Le choix dépend de la nature de la configuration.

#### `opts` — options statiques

À utiliser quand la configuration se résume à des valeurs à passer directement au _plugin_ :

```lua
-- plugins/editing/autopairs.lua
opts = {
  check_ts = true,
  ts_config = {
    lua = { "string" },
  },
}
```

**Lazy** appelle automatiquement `plugin.setup(opts)`. Aucun code supplémentaire n'est nécessaire.

#### `config` — logique à exécuter

À utiliser quand la configuration nécessite du code : autocommandes, protection par `pcall`, etc.

```lua
-- plugins/editing/treesitter.lua
config = function()
  local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
  if not ok then return end
  ts_configs.setup({ ... })
end
```

#### `opts` + `config` — les deux ensemble

Quand un _plugin_ a des options statiques et du code à exécuter après son initialisation, les deux coexistent. `opts` est alors reçu en second argument de `config` :

```lua
-- plugins/editing/blink.lua
opts = {
  keymap = { ... },
  completion = { ... },
},
config = function(_, opts)
  require("blink.cmp").setup(opts)        -- opts transmis ici
  require("luasnip.loaders.from_vscode")  -- code supplémentaire
    .lazy_load({ paths = { ... } })
  vim.cmd([[hi LspFloatBorder ...]])      -- highlights manuels
end,
```

Le `_` en premier argument est le _plugin_ lui-même (non utilisé ici, ignoré par convention).

#### Règle de décision

| Situation                                     | Clé à utiliser    |
| --------------------------------------------- | ----------------- |
| Options statiques uniquement                  | `opts`            |
| Code à exécuter (API, autocommandes, `pcall`) | `config`          |
| Options statiques + code supplémentaire       | `opts` + `config` |

Quand le doute existe, préférer `opts` : c'est plus court, plus lisible, et **Lazy** gère l'appel à `setup()` automatiquement.

### Organisation des _keymaps_

Les raccourcis clavier sont répartis en trois espaces distincts selon leur portée.

#### `core/keymaps.lua` — raccourcis globaux

Tous les raccourcis actifs en permanence, quelle que soit la situation, sont définis ici. Cela inclut les raccourcis qui invoquent des _plugins_, car ils font partie de l'interface globale de **NvCrafted** :

```lua
-- core/keymaps.lua
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Chercher fichiers" })
map("n", "<leader>ee", ":Neotree<CR>", { desc = "Ouverture de Neotree" })
```

#### Dans le fichier plugin — raccourcis contextuels

Les raccourcis qui n'ont de sens que dans un contexte précis (_popup_, menu flottant) restent dans le fichier _plugin_ :

```lua
-- plugins/editing/blink.lua
opts = {
  keymap = {
    ["<CR>"]    = { "accept", "fallback" },
    ["<Tab>"]   = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
  },
}
```

Ces raccourcis sont gérés par **blink.cmp** lui-même et n'ont aucun effet en dehors du menu de complétion. Les définir dans `core/keymaps.lua` serait sans objet.

#### `core/lsp/on_attach.lua` — raccourcis buffer-local LSP

Un troisième espace existe pour les raccourcis **LSP** : ils sont définis dans `on_attach` et ne s'activent que lorsqu'un serveur **LSP** est attaché au _buffer_ courant.

```lua
-- core/lsp/on_attach.lua
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
```

Les raccourcis **LSP** appartiennent à `on_attach`, jamais à `core/keymaps.lua` — ils ne doivent pas polluer les _buffers_ sans **LSP**.

### Ajouter un serveur **LSP**

L’ajout d’un serveur _LSP_ suit une approche déclarative en deux niveaux.

1. Déclaration du serveur
   Ajouter le nom du serveur dans `lua/core/lsp/servers.lua`
   Exemple :

```lua
return {
  "lua_ls",
  "pyright",
  "rust_analyzer",
}
```

👉 Ce fichier est la source de vérité :

- utilisé par **Mason** pour l’installation
- utilisé par l’orchestrateur **LSP** pour l’activation

2. Configuration spécifique
   Créer un fichier nommé selon le serveur : `lua/plugins/lsp/config/<nom_serveur>.lua`.
   Structure du fichier :

```lua
return {
  settings = {
    -- configuration LSP spécifique
  }
}
```

Principe clé :
Un serveur LSP fonctionne sans configuration spécifique.
Une surcouche n’est chargée que si un fichier dédié existe.

---

## Gestion des plugins avec Lazy.nvim

### `lua/plugins/init.lua`

Ce fichier est le **point d’agrégation des plugins**. Il ne contient aucune configuration directe, ne s'occupant que des imports logiques :

- Un scan du dossier `lua/plugins/` est effectué en vue de récupérer tous les sous-répertoires.
- Transforme chaque sous-répertoire en une entrée `{ import = "plugins.<nom>" }`.
- Retourne une table directement utilisable par `require("lazy").setup()`.
  Chaque sous-dossier représente un **domaine fonctionnel**.

👉 Principes clés :

- Aucun _plugin_ n’est déclaré manuellement dans init.lua.
- Chaque _plugin_ dispose de son propre fichier.
- La philosophie adoptée est de ne configurer que ce qui diffère des valeurs par défaut, afin de garder des fichiers courts et explicites. Par exemple : `autopairs.lua` ne redéfinit que l’intégration **Tree-sitter**.

---

## Gestion des LSP et des outils

Le support **LSP** et l'installation des outils sont structurés en quatre niveaux distincts.

### 1. Déclaration — `core/lsp/servers.lua`

- Liste explicite des serveurs activés
- Aucune logique, aucune dépendance _plugin_

### 2. Déclaration — `core/lsp/tools.lua`

- Liste explicite des outils **Mason** non-**LSP** : formateurs (`black`, `stylua`, `prettier`),_linters_ (`ruff`), et autres binaires.
- Même philosophie que `servers.lua` : une liste pure, sans logique.

Ces deux fichiers sont les _sources de vérité_ de l'environnement. Tout ce qui doit être installé est déclaré ici, nulle part ailleurs.

### 3. Installation — `plugins/lsp/mason.lua`

Consomme les deux listes :

- `mason-lspconfig` installe les serveurs de `servers.lua`
- `mason-tool-installer` installe les outils de `tools.lua`
- `mason.nvim` exécute les installations
  Aucune décision fonctionnelle ici.

### 4. Orchestration — `plugins/lsp/init.lua`

Pour chaque serveur de `servers.lua` :

- applique `on_attach` et `capabilities` communs
- charge la surcouche `lsp/config/<serveur>.lua` si elle existe
- enregistre le serveur via `vim.lsp.config()`

Un serveur fonctionne sans surcouche.
Une surcouche n'est chargée que si le fichier existe.

---

## Gestion des _Snippets_

### Structure

Les _snippets_ sont stockés dans `~/.config/nvim/snippets/` au format JSON (compatible VSCode).

### Configuration

Les _snippets_ sont chargés dynamiquement via `lazy_load` :

```lua
-- plugins/editing/blink.lua
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { vim.fn.stdpath("config") .. "/snippets" },
})
```

**blink.cmp** est configuré pour inclure **luasnip** comme source de complétion :

```lua
sources = { -- Sources de complétion prioritaires
    default = { "lsp", "buffer", "snippets", "path" },
},
```

---

## Gestion du dictionnaire personnalisé

**NvCrafted** intègre un système de correction orthographique adapté au code et aux commentaires.

- Dictionnaires utilisés : anglais (en), français (fr) et un dictionnaire personnalisé code.
- Création automatique : au premier lancement, le fichier `code.utf-8.add` est créé avec les mots techniques fréquents et compilé en `code.utf-8.spl`.
- Spellcheck ciblé : actif uniquement dans les commentaires et les chaînes de caractères.
- Ajout automatique : les mots validés avec `zg` sont ajoutés à `code.utf-8.add` et recompilés dans `.spl`.
- Compatibilité : fonctionne dès le premier lancement, avec **Neo-tree** et tous les _buffers_, sans télécharger de dictionnaire externe.

---

## Installation

### Prérequis

- **Neovim ≥ 0.11**
- [Git](https://git-scm.com/)

### Étapes

```bash
# Clonage du dépôt
git clone https://github.com/Krystof2so/NvCrafted.git ~/.config/nvim

# Lancer Neovim
nvim
```

**Lazy.nvim** installera automatiquement les plugins au premier lancement.

---

## Philosophie du projet

- 📦 **Un plugin = un fichier**
- 🧠 **Lisibilité**
- 🧪 **Aucune boîte noire**
- 🧩 **Extension incrémentale**

Cette configuration est pensée comme une **base de travail personnelle**, mais suffisamment structurée pour servir de référence ou de point de départ.

Mon souhait est de conserver une organisation et une configuration qui se veuille la plus simple d'utilisation, la plus modulaire possible. Une spécificité = un fichier... rien de plus basique.

Les commentaires insérés dans chacun des fichiers sont intégralement en français (Sorry to English speakers), car je trouve que **Neovim** est globalement peu documenté en français (ou voire des configurations quasi ésotériques).

---

## Évolutions prévues

- Ajout progressif de plugins (UI, DAP, tests, refactoring…)
- Amélioration des intégrations LSP (surcouches)
- Et puis tout ce qui me passera par la tête en restant fidèle à la philosophie du projet

---

## Licence

Libre d’utilisation, de modification et de partage.

---

✨ _Si vous cherchez une configuration Neovim modulaire et aisément compréhensible, ce dépôt est fait pour vous._
