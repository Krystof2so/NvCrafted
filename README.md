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

- **Neovim ≥ 0.10**
- [Lua](https://www.lua.org/) comme langage de configuration
- **lazy.nvim** : gestionnaire de plugins
- [mason.nvim](https://github.com/mason-org/mason.nvim) / [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) : installation et gestion des LSP
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) (via l’API `vim.lsp`)
- [Tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter) pour l’analyse syntaxique

---

## Arborescence du projet

```text
.
├── init.lua
├── lazy-lock.json
└── lua
    ├── core
    │   ├── autocmds.lua
    │   ├── keymaps.lua
    │   └── options.lua
    └── plugins
        ├── init.lua
        ├── coding
        ├── lsp
        │   ├── init.lua
        │   ├── mason.lua
        │   └── config
        ├── tools
        └── ui
```

### 1. `init.lua` (racine)

Point d’entrée principal :

- bootstrap de **lazy.nvim**
- définition des leaders
- chargement des modules `core`
- initialisation de **Lazy** avec l’import automatique des plugins

---

## Le répertoire `core/`

Contient la **configuration fondamentale de Neovim**, indépendante des plugins.

| Fichier | Rôle |
|------|------|
| `options.lua` | Options Neovim (`vim.opt`) |
| `keymaps.lua` | Raccourcis clavier globaux |
| `autocmds.lua` | Autocommandes |

👉 Ces fichiers ne dépendent d’aucun plugin et peuvent être lus comme une « config Neovim pure ».

---

## Gestion des plugins avec Lazy.nvim

### `lua/plugins/init.lua`

Ce fichier est le **point d’agrégation des plugins**. Il ne contient aucune configuration directe, ne s'occupant que des imports logiques :
- Scanne le dossier `lua/plugins/` et récupère tous les sous-répertoires.
- Transforme chaque sous-répertoire en une entrée `{ import = "plugins.<nom>" }`.
- Retourne une table directement utilisable par `require("lazy").setup()`.
Chaque sous-dossier représente un **domaine fonctionnel**.

---

## Organisation par domaines

### `plugins/ui/`

Plugins liés à l’interface utilisateur :

- barre de statut ([lualine](https://github.com/nvim-lualine/lualine.nvim))
- explorateur de fichiers ([neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim))
- écran d’accueil ([alpha](https://github.com/goolord/alpha-nvim))
- thème de couleurs ([Nord](https://www.nordtheme.com/)) - Je sais, je suis un inconditionnel de ce thème.

Chaque plugin dispose de son propre fichier.

---

### `plugins/coding/`

Plugins améliorant l’expérience d’édition du code :

- [auto-pairs](https://github.com/windwp/nvim-autopairs)
- **Tree-sitter**
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- formatage ([conform](https://github.com/stevearc/conform.nvim))

👉 La philosophie adoptée est de **ne configurer que ce qui diffère des valeurs par défaut**, afin de garder des fichiers courts et explicites.

Exemple : `autopairs.lua` ne redéfinit que l’intégration **Tree-sitter**.

---

### `plugins/tools/`

Outils transverses (ex. [which-key](https://github.com/folke/which-key.nvim)) qui n’entrent pas directement dans l’UI ou le code.

---

## Gestion des LSP

Le support LSP est volontairement **séparé en deux niveaux** :

### 1️⃣ Niveau global — `plugins/lsp/init.lua`

Responsabilités :

- installer les serveurs via **Mason**
- lister les serveurs actifs
- charger dynamiquement une configuration spécifique si elle existe

Principe clé :

> **Un serveur LSP fonctionne sans configuration spécifique.**
> Une surcouche n’est chargée que si un fichier dédié existe.

---

### 2️⃣ Niveau spécifique — `plugins/lsp/config/`

Chaque fichier correspond **à un serveur LSP précis**.

Exemple : `pyright.lua`

```lua
return {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "strict",
      },
    },
  },
}
```

Avantages :

- aucune duplication de logique
- configuration locale et explicite
- ajout d’un LSP = 1 fichier

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

✨ *Si vous cherchez une configuration Neovim modulaire et aisément compréhensible, ce dépôt est fait pour vous.*

