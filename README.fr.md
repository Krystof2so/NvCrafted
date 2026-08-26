<p align="center">
  🇬🇧 <a href="README.md">Read the README in English</a>
</p>

---

# NvCrafted

Une configuration [Neovim](https://neovim.io/) façonnée à la main, conçue pour être comprise, étendue et maîtrisée.

## 🪪 Présentation

Ce dépôt contient une configuration **Neovim** se voulant moderne, lisible et hautement modulaire, pensée comme une base évolutive pour construire un environnement de développement proche d’un IDE.

Les objectifs principaux du projet sont :

- 🧩 **Modularité maximale** : chaque fonctionnalité est isolée dans un fichier clairement identifié.
- 🧠 **Lisibilité et pédagogie** : la configuration doit rester compréhensible, même en y revenant plusieurs mois après.
- 🚀 **Scalabilité** : l’ajout d’un plugin ou d’une surcouche LSP se fait via un simple fichier.
- 🔧 **Approche déclarative** : [Lazy.nvim](https://lazy.folke.io/) est utilisé comme gestionnaire central.

Une fois la structure posée, la maintenance se résume essentiellement à **ajouter ou ajuster des modules**, sans modifier le cœur de la configuration.

(Ce projet demeure en construction...)

---

## ⚙️Prérequis

- **Neovim ≥ 0.12**
- [Lua](https://www.lua.org/) comme langage de configuration
- **lazy.nvim** : gestionnaire de plugins
- [mason.nvim](https://github.com/mason-org/mason.nvim) / [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) : installation et gestion des LSP
- [Tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter) pour l’analyse syntaxique
- [Lazydev.nvim](https://github.com/folke/lazydev.nvim) pour améliorer l'expérience **LSP** **Lua** avec les fichiers de configuration.
- [nerdfonts](https://www.nerdfonts.com/) : polices requises pour les icônes

---

## 📁 Structure du projet

```text
 .
├──  doc       # Aide intégrée de Néovim - Fichiers partiellement traduits en français
├──  docs      # Documentation technique (🇫🇷)
├──  init.lua  # Point d'entrée principal
├──  lazy-lock.json    # Verrouillage des versions des plugins
├──  lua
│   ├──  core  # Configuration Neovim/NvCrafted pure (indépendamment des plugins - Divers fichiers et répertoires)
│   │   ├──  format
│   │   ├──  highlights
│   │   ├──  git
│   │   ├──  lsp
│   │   ├──  map_actions   # Fonctionnalités propres à NvCrafted
│   │   ├──  snacks_config # Dashboard
│   ├──  nvcrafted
│   │   └──  tutor         # Tutoriel intégré (🇫🇷)
│   └──  plugins           # Plugins intégrés/classés par domaines fonctionnels
│       ├──  appearence
│       ├──  editing
│       ├──  git
│       ├──  lsp
│       ├──  meta
│       ├──  navigation
│       └──  ux
├──  README.fr.md
├── 󰂺 README.md
├──  snippets      
└──  tutor_lessons     # Leçons du tutoriel intégré
```

Pour plus de détails sur l’architecture, consultez <a href="/docs/architecture.md.">/docs/architecture.md</a>

---

## 🚀 Installation

### 1. Clôner le dépôt

```bash
git clone https://github.com/Krystof2so/NvCrafted.git ~/.config/nvim
```

### 2. Lancer Neovim

```bash
nvim
```

**Lazy.nvim** installera automatiquement les plugins au premier lancement.

⚠️**Note** :
- Assurez-vous que Neovim ≥ 0.12 est installé.
- Les polices Nerd Fonts sont requises pour une expérience optimale.

--- 

## 🔧 Fonctionnalités clés

- Un plugin = un fichier : Chaque plugin a son propre fichier dans lua/plugins/<domaine>/.
- Import automatique : plugins/init.lua scanne les sous-dossiers et les importe dynamiquement.
- Configuration minimaliste : Seules les options non par défaut sont configurées.

Exemple :
```lua
-- plugins/editing/autopairs.lua
return {
  "windwp/nvim-autopairs",
  opts = {
    check_ts = true,
    ts_config = { lua = { "string" } }
  }
}
```

Pour les conventions d’extension (déclaration vs spécification, opts vs config), consultez <a href="/docs/architecture.md.">/docs/architecture.md</a>.

--- 

## Support LSP et outils

NvCrafted structure le support LSP en 4 niveaux :
1. **Déclaration** :
    - `core/lsp/servers.lua` → Liste des serveurs LSP actifs.
    - `core/lsp/tools.lua` → Liste des outils Mason (formatters, linters).
2. **Installation** :
    - `plugins/lsp/mason.lua` → Installe les serveurs et outils via Mason.
3. **Orchestration** :
    - `plugins/lsp/init.lua` → Applique `on_attach` et `capabilities` communs, charge les surcouches spécifiques.
4. **Configuration spécifique** :
    - `plugins/lsp/config/<server>.lua` → Configuration personnalisée par serveur.

**Exemple : Ajouter un serveur LSP**
1. Ajoutez le nom du serveur dans `core/lsp/servers.lua` :
```lua
return { "lua_ls", "pyright", "rust_analyzer" }
```
2. (Optionnel) Créez un fichier de configuration dans `plugins/lsp/config/<server>.lua`.

Pour une description complète de l’architecture LSP, consultez <a href="/docs/lsp-nvcrafted.md">/docs/lsp-nvcrafted</a>.

--- 

## Gestion des raccourcis clavier

Les raccourcis sont organisés en 3 espaces selon leur portée :
- `core/keymaps.lua` : Raccourcis globaux (ex: <leader>hm pour accéder aux fichiers de documentation)
- Fichier du plugin : Raccourcis contextuels (ex: raccourcis dans un menu flottant).
- `core/lsp/on_attach.lua` : Raccourcis spécifiques au LSP (ex: `gd` pour aller à la définition).

Pour la liste complète des commandes, consultez <a href="/docs/commandes-Vim-Neovim.md">Commandes Vim et Neovim</a> et <a href="/docs/commandes-et-raccourcis-NvCrafted.md">Commandes et raccourcis propres à NvCrafted</a>.

--- 

## Snippets et auto-complétion

- Snippets : Stockés dans `~/.config/nvim/snippets/` (format VSCode).
- Chargement dynamique : Via `luasnip.loaders.from_vscode` dans `plugins/editing/blink.lua`.
- Intégration avec [blink.cmp](https://cmp.saghen.dev/) : Les snippets sont inclus comme source de complétion.

Exemple de configuration :
```lua
-- plugins/editing/blink.lua
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { vim.fn.stdpath("config") .. "/snippets" }
})
```

--- 

## Dictionnaire personnalisé

- Dictionnaires : Anglais (en), Français (fr), et un dictionnaire technique personnalisé (`code.utf-8.add`).
- Fonctionnement :
    - Création automatique de `code.utf-8.add` au premier lancement.
    - Compilation en `code.utf-8.spl` pour une utilisation immédiate.
    - Correction orthographique ciblée (commentaires et chaînes de caractères uniquement).
    - Ajout automatique des mots validés avec `zg`.

Aucun téléchargement de dictionnaire externe requis.

--- 

## Tutoriel et documentation française intégrée 

- Leçons : Disponibles dans `tutor_lessons`/ (ex: `01-Les-modes.md`).
- Module dédié : `lua/nvcrafted/tutor/` pour une expérience interactive.
- Objectif : Faciliter la prise en main de Neovim pour les débutants.

Pour plus d’informations, consultez le module <a href="/nvcrafted/tutor/">nvcrafted/tutor</a>.

Dans `/doc` se trouvent des fichiers `.frx`. Il s'agit des fichiers de la documenetation officielle Vim/Neovim, traduits en français (intégralement ou partiellement). Consulter : <a href="/docs/documentation-aide-neovim.md">Documentation intégrée de Vim/Neovim</a>. 

--- 

## Personnalisation des couleurs

- Thèmes disponibles : `everviolet`, `nordic`, `rose-pine` (par défaut).
- Fichiers dédiés : Dans `plugins/appearence/` (ex: `rose-pine.lua`).
- Surcouches : Personnalisation des couleurs pour des plugins spécifiques (ex: [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim), [which-key](https://github.com/folke/which-key.nvim/tree/main)).

- Pour la gestion des thèmes, consultez <a href="/docs/themes.md">Les thèmes avec NvCrafted</a>.
- Pour les personnalisations de couleurs, consultez <a href="/docs/highlights.md">Les higlights</a>.

--- 

## 📌 Conventions d’extension

### 1. Ajouter un plugin

1. Créez un fichier Lua dans le dossier correspondant (ex: `lua/plugins/editing/mon_plugin.lua`).
2. Retournez une table compatible avec Lazy.nvim :
```lua
return {
  "auteur/mon_plugin.nvim",
  opts = { ... },  -- Options statiques
  config = function()  -- Logique à exécuter
    -- Configuration ici
  end
}
```

### 2. Quand utiliser opts vs config ?

- Logique à exécuter (API, autocommandes, `pcall`) -> `config`
- Options statiques uniquement -> `opts`
- Options statiques + code supplémentaire -> `opts` + `config`

💡 Préférez `opts` pour les configurations simples : c’est plus court et plus lisible.

Pour des exemples concrets, consultez <a href="/docs/architecture.md.">la documentation sur l'architecture</a>

--- 

## 🎨 Philosophie du projet

- 📦 Un plugin = un fichier : Pas de boîte noire, tout est explicite.
- 🧠 Lisibilité : Les commentaires et la documentation sont en français (désolé pour les anglophones !).
- 🧪 Pas de magie : Tout est configurable et compréhensible.
- 🧩 Extension incrémentale : Ajoutez des fonctionnalités sans casser l’existant.

Cette configuration est conçue comme une base de travail personnelle, mais suffisamment structurée pour servir de référence ou de point de départ.

--- 

## 🔮 Évolutions prévues

- Ajout progressif de plugins (UI, DAP, tests, refactoring, etc.).
- Amélioration des intégrations LSP (surcouches) et ajouts de snippets.
- Toute autre idée respectant la philosophie du projet.
- Amélioration et enrichissement de la documentation intégrée en français, ainsi que des tutoriels de prise en main.

💬 Vous avez une suggestion ou une idée ? N’hésitez pas à contribuer !

---

## 📜 Licence

Libre d’utilisation, de modification et de partage.

✨ Si vous cherchez une configuration Neovim modulaire et aisément compréhensible, NvCrafted est fait pour vous.

