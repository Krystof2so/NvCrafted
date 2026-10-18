# Comportements automatiques (core.autocmds)

**NvCrafted** centralise les réactions automatiques de **Neovim** dans le fichier `lua/core/autocmds.lua`.

Une auto-commande définit un comportement déclenché automatiquement lorsqu’un événement Neovim se produit (ouverture de fichier, changement de fenêtre, etc.).

### Principes architecturaux

- Une auto-commande = une intention claire
- Un groupe = une responsabilité
- Aucun comportement implicite ou magique
- Aucune dépendance directe à des _plugins_
- Les auto-commandes définissent quand un comportement s’applique, jamais comment il est implémenté

### Groupes d’auto-commandes définis

#### **NvCraftedGeneral** — Socle fondamental

- Restauration automatique de la position du curseur
- Lorsqu’un fichier est rouvert, le curseur revient à la dernière position connue.
- Comportement attendu dans un éditeur moderne.
- Sécurisé (position valide uniquement).

#### **NvCraftedFoldingExpr** — Folding natif

Il est défini dans `core/folding.lua`, qui centralise tout ce qui touche au pliage.

**Source des plis** :

- `FileType` : le _folding_ s'appuie sur **Tree-sitter** (`vim.treesitter.foldexpr()`) si un _parser_ existe pour le langage.
- `LspAttach` : si le serveur gère `textDocument/foldingRange`, la source passe sur le _LSP_ (`vim.lsp.foldexpr()`), prioritaire sur **Tree-sitter**.
- **Documentation Rust** : à l'attachement d'un serveur _LSP_ sur un _buffer_ **rust**, les blocs de documentation de deux lignes ou plus (`///` et `//!`) sont repliés automatiquement, une seule fois par _buffer_. Le repli attend que le serveur ait fourni ses plages de pliage (jusqu'à 5 secondes environ). Exception voulue dépendant de l'arrivée des plages _LSP_ (évènement asynchrone).
- A l'ouverture initiale, les fichiers s'ouvrent avec les plis dépliés grâce aux options `foldlevel` et `foldlevelstart` (valeur `99`), et non plus via une auto-commande (à l'exception des commentaires de documentation **Rust**). Le repli reste ensuite à la main (`zc`, `za`, `zM`, etc.).

#### **NvCraftedSpell** — Orthographe contextuelle

- Le correcteur orthographique est activé uniquement pour les fichiers rédactionnels :
  - `markdown`
  - `text`
  - `rst`

La logique avancée de gestion des dictionnaires (anglais, français, dictionnaire personnalisé, compilation automatique, ajout des mots validés) est volontairement déportée dans le module dédié :

### Séparation des responsabilités

| Fichier             | Rôle                             |
| ------------------- | -------------------------------- |
| `core.options.lua`  | État global par défaut           |
| `core.autocmds.lua` | Quand appliquer un comportement  |
| `core.spell.lua`    | Comment fonctionne l’orthographe |
| `core.keymaps.lua`  | Interactions utilisateur         |

Cette séparation garantit un socle stable, lisible et extensible, sur lequel les phases suivantes de **NvCrafted** peuvent s’appuyer.
