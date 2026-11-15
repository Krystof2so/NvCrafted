# Documentation des commandes et raccourcis propres à NvCrafted

Organisation par fonctionnalité, avec groupes `<leader>` et descriptions.

---

## **📌 Table des Matières**

- `<leader>c` — Code
- `<leader>b` — Buffers
- `<leader>f` — Fichiers
- `<leader>n` — Navigation
- `<leader>d` — Diagnostics
- `<leader>x` — UI
- `<leader>m` — Multi-curseurs
- `<leader>p` — Lazy
- Raccourcis pour des fonctionnalités spécifiques (hors `which-key`)
- `lua/core/map_keymaps` - Fonctions pour mappings spécifiques

---

## **`<leader>c` — Code**

Actions sur le code : LSP, annotations, commentaires.
Les _mappings_ LSP _buffer-local_ (ex: `<leader>ca`, `<leader>cr`) sont définis dans `on_attach.lua` et apparaissent dans **Which-Key**.

| Raccourci    | Description         | Plugin/Commande      |
| ------------ | ------------------- | -------------------- |
| `<leader>cf` | Annoter la fonction | Neogen               |
| `<leader>cc` | Annoter la classe   | Neogen               |
| `<leader>ct` | Annoter le type     | Neogen               |
| `<leader>cF` | Annoter le fichier  | Neogen               |
| `<leader>ci` | Toggle hints        | `vim.lsp.inlay_hint` |

---

## `<leader>b` — Buffers

Navigation, fermeture, épinglage et tri des _buffers_.

### Navigation

| Raccourci      | Description           | Commande Neovim   |
| -------------- | --------------------- | ----------------- |
| `<leader>bn`   | Buffer suivant        | `:BufferNext`     |
| `<leader>bp`   | Buffer précédent      | `:BufferPrevious` |
| `<leader>b0`   | Dernier buffer ouvert | `:BufferLast`     |
| `<leader>b1-9` | Aller au buffer 1-9   | `:BufferGoto {n}` |

### Fermeture

| Raccourci    | Description                       | Commande Neovim                     |
| ------------ | --------------------------------- | ----------------------------------- |
| `<leader>bx` | Fermer le buffer actuel           | `:BufferClose`                      |
| `<leader>ba` | Fermer tous sauf le buffer actuel | `:BufferCloseAllButCurrent`         |
| `<leader>bq` | Fermer sauf actuel/épinglés       | `:BufferCloseAllButCurrentOrPinned` |
| `<leader>bQ` | Fermer sauf épinglés              | `:BufferCloseAllButPinned`          |
| `<leader>b<` | Fermer tous les buffers à gauche  | `:BufferCloseBuffersLeft`           |
| `<leader>b>` | Fermer tous les buffers à droite  | `:BufferCloseBuffersRight`          |

### Épinglage et Tri

| Raccourci    | Description                    | Commande Neovim      |
| ------------ | ------------------------------ | -------------------- |
| `<leader>bP` | Épingler/désépingler le buffer | `:BufferPin`         |
| `<leader>bo` | Trier les buffers par nom      | `:BufferOrderByName` |

### Liste

| Raccourci    | Description                   | Commande Neovim      |
| ------------ | ----------------------------- | -------------------- |
| `<leader>bl` | Liste des buffers (Telescope) | `:Telescope buffers` |

---

## `<leader>f` — Fichiers

Recherche et exploration de fichiers et de contenu.

| Raccourci    | Description                | Commande/Plugin          |
| ------------ | -------------------------- | ------------------------ |
| `<leader>ff` | Chercher un fichier        | `:Telescope find_files`  |
| `<leader>fg` | Rechercher du texte (grep) | `:Telescope live_grep`   |
| `<leader>fr` | Fichiers récents           | `:Telescope oldfiles`    |
| `<leader>ft` | Rechercher TODOs/FIX/BUG   | `TodoTelescope`          |
| `<leader>fk` | Explorer les raccourcis    | `:Telescope keymaps`     |
| `<leader>fh` | Aide Neovim                | `:Telescope help_tags`   |
| `<leader>fc` | Commandes disponibles      | `:Telescope commands`    |
| `<leader>fo` | Options Neovim             | `:Telescope vim_options` |

---

## `<leader>n` — Navigation

Déplacement dans la structure du projet et du code.

| Raccourci    | Description                   | Commande/Plugin                   |
| ------------ | ----------------------------- | --------------------------------- |
| `<leader>ne` | Ouvrir Neotree                | `:Neotree`                        |
| `<leader>nb` | Buffers ouverts (Neotree)     | `:Neotree focus buffers float`    |
| `<leader>ng` | Git status (Neotree)          | `:Neotree focus git_status float` |
| `<leader>na` | Structure du fichier (Aerial) | `:AerialOpen`                     |

---

## `<leader>d` — Diagnostics

Gestion des diagnostics (erreur, avertissements).
Les _mappings buffer-local_ (ex: `<leader>dd`, `<leader>dn`) sont dans `on_attach.lua`.

| Raccourci    | Description                   | Commande/Plugin          |
| ------------ | ----------------------------- | ------------------------ |
| `<leader>dl` | Liste globale des diagnostics | `:Trouble diagnostics`   |
| `<leader>ds` | Liste avec aperçu (split)     | `:Trouble preview_split` |

---

## `<leader>x` — UI

Modification de l'apparence ou du comportement de l'éditeur.

| Raccourci    | Description                                  | Commande/Plugin/Fichier               |
| ------------ | -------------------------------------------- | ------------------------------------- |
| `<leader>xt` | Changer de thème                             | `core.theme.preview_with_telescope()` |
| `<leader>xz` | Toggle Zen Mode                              | `:ZenMode`                            |
| `<leader>xh` | Effacer la surbrillance                      | `:nohlsearch`                         |
| `<leader>xI` | Toggle inlay hints (global)                  | `vim.lsp.inlay_hint`                  |
| `<leader>xa` | Ouvre le dashboard et ferme tous les buffers | `open_dashboard.lua`                  |

---

## `<leader>m` — Multi-curseurs

Édition multi-curseurs avec **multicursor.nvim**. Il y a un curseur _principal_ (celui que l'on contrôle) et des curseurs _secondaires_ : toute édition faite au curseur principal est répétée, une fois validée, au niveau de chaque curseur.

| Raccourci    | Mode | Description                                         | Fonction               |
| ------------ | ---- | --------------------------------------------------- | ---------------------- |
| `<leader>ma` | n, x | Curseurs sur toutes les occurrences du mot (Normal) | `matchAllAddCursors()` |
|              |      | ou de la sélection (Visual) dans le _buffer_        |                        |
| `<leader>mj` | n, x | Ajouter un curseur sur la ligne du dessous          | `lineAddCursor(1)`     |
|              |      | (répéter pour en empiler plusieurs)                 |                        |

### Raccourci contextuel

Défini dans `lua/plugins/editing/multicursor.lua` (couche de _mappings_), il n'existe que lorsqu'il y a plusieurs curseurs :

| Raccourci | Mode | Description                        | Fonction         |
| --------- | ---- | ---------------------------------- | ---------------- |
| `<Esc>`   | n    | Supprimer les curseurs secondaires | `clearCursors()` |

Avec un seul curseur, `<Esc>` garde son comportement habituel.

### Utilisation

**Remplacer un mot partout**

1. Placer le curseur sur le mot (mode Normal), puis `<leader>ma`.
2. Taper `ciw`, puis le nouveau mot.
3. `<Esc>` : retour en mode Normal, les curseurs restent actifs.
4. `<Esc>` de nouveau : retour à un seul curseur.

**Écrire la même ligne plusieurs fois**

1. Créer les lignes vides nécessaires (ex. `2o<Esc>`), puis remonter sur la première (`2k`).
2. `<leader>mj` autant de fois que de lignes supplémentaires.
3. Passer en Insert (`i`) et écrire la ligne une seule fois : elle est répétée à chaque curseur.
4. `<Esc>` deux fois pour revenir à un seul curseur.

> Le plugin ne crée pas de lignes : les lignes du dessous doivent déjà exister.

---

## `<leader>p` — Profil

Profil **NvCrafted**.

| Raccourci    | Description                      | Commande/Plugin/Fichier |
| ------------ | -------------------------------- | ----------------------- |
| `<leader>pl` | Ouvrir Lazy                      | `:Lazy`                 |
| `<leader>pu` | Mettre à jour les plugins        | `:Lazy update`          |
| `<leader>ps` | Synchroniser les plugins         | `:Lazy sync`            |
| `<leader>pi` | Fournit des informations système | `info_system.lua`       |

---

## Raccourcis pour des fonctionnalités spécifiques (hors `which-key`)

| Raccourci | Description                   | Commande/Plugin |
| --------- | ----------------------------- | --------------- |
| `<Alt>s`  | Sélection complète du fichier | **N** : `ggVG`  |

---

## `lua/core/map_actions` - Fonctions de mappings

Fonctionnalités spécifiques implémentées dans des fichiers propres, déclenchées par des mappings, trop volumineuses pour vivre directement dans `keymaps.lua`.

| Raccourci    | Description                                  | Fichier              |
| ------------ | -------------------------------------------- | -------------------- |
| `<leader>xa` | Ouvre le dashboard et ferme tous les buffers | `open_dashboard.lua` |
| `<leader>pi` | Fournit des informations système             | `info_system.lua`    |
