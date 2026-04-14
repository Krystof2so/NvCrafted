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
.
├── docs
│   ├── autocommands.md
│   ├── commands.md
│   └── lsp-nvcrafted.md
├── init.lua
├── lazy-lock.json
├── lua
│   ├── core
│   │   ├── autocmds.lua
│   │   ├── bootstrap.lua
│   │   ├── format
│   │   │   └── conform.lua
│   │   ├── highlights
│   │   │   └── diagnostics_theme_nord.lua
│   │   ├── keymaps.lua
│   │   ├── lsp
│   │   │   ├── capabilities.lua
│   │   │   ├── on_attach.lua
│   │   │   ├── servers.lua
│   │   │   └── tools.lua
│   │   ├── options.lua
│   │   └── spell.lua
│   └── plugins
│       ├── coding
│       │   ├── autopairs.lua
│       │   ├── blink.lua
│       │   ├── conform.lua
│       │   ├── lazydev.lua
│       │   ├── telescope.lua
│       │   └── treesitter.lua
│       ├── init.lua
│       ├── lsp
│       │   ├── config
│       │   │   ├── lua_ls.lua
│       │   │   ├── pyright.lua
│       │   │   └── ruff.lua
│       │   ├── init.lua
│       │   └── mason.lua
│       ├── tools
│       │   └── which_key.lua
│       └── ui
│           ├── aerial.lua
│           ├── alpha.lua
│           ├── colorscheme.lua
│           ├── lualine.lua
│           ├── neo_tree.lua
│           └── trouble.lua
├── README.fr.md
├── README.md
└── snippets
    └── python.json
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
                    ├── plugins/coding/
                    ├── plugins/ui/
                    ├── plugins/tools/
                    └── plugins/lsp/
                          └── init.lua
                                ├── servers.lua → activation LSP
                                └── tools.lua  → outils Mason
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
   - `lua/plugins/ui/` pour un plugin d’interface
   - `lua/plugins/coding/` pour un plugin lié à l’édition de code
   - `lua/plugins/tools/` pour les outils transverses

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

`plugins/coding/conform.lua` se limite à déclarer le _plugin_ et à appeler le module `core` :

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

## Organisation par domaines

### `plugins/ui/`

Plugins liés à l’interface utilisateur :

- barre de statut ([lualine](https://github.com/nvim-lualine/lualine.nvim))
- explorateur de fichiers ([neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim))
- écran d’accueil ([alpha](https://github.com/goolord/alpha-nvim))
- thème de couleurs ([Nord](https://www.nordtheme.com/)) - Je sais, je suis un inconditionnel de ce thème.
- Visualisation des diagnostics ([Trouble](https://github.com/folke/trouble.nvim/tree/main))
- Visualisation de la structure du fichier courant (et navigation) ([aerial](https://github.com/stevearc/aerial.nvim))

---

### `plugins/coding/`

Plugins améliorant l’expérience d’édition du code :

- [auto-pairs](https://github.com/windwp/nvim-autopairs)
- **Tree-sitter**
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- formatage ([conform](https://github.com/stevearc/conform.nvim))
- [Lazydev](https://github.com/folke/lazydev.nvim)

---

### `plugins/tools/`

Outils transverses (ex. [which-key](https://github.com/folke/which-key.nvim)) qui n’entrent pas directement dans l’UI ou le code.

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
-- plugins/coding/blink.lua
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
