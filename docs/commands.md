# **Documentation des raccourcis NvCrafted**

Organisation par fonctionnalité, avec groupes `<leader>` et descriptions.

---

## **📌 Table des Matières**

- `<leader>c` — Code
- `<leader>b` — Buffers
- `<leader>f` — Fichiers
- `<leader>n` — Navigation
- `<leader>d` — Diagnostics
- `<leader>u` — UI
- `<leader>m` — Messages (Noice)
- `<leader>l` — Lazy
- Raccourcis pour des fonctionnalités spécifiques (hors `which-key`)

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

## `<leader>u` — UI

Modification de l'apparence ou du comportement de l'éditeur.

| Raccourci    | Description                 | Commande/Plugin                       |
| ------------ | --------------------------- | ------------------------------------- |
| `<leader>ut` | Changer de thème            | `core.theme.preview_with_telescope()` |
| `<leader>uz` | Toggle Zen Mode             | `:ZenMode`                            |
| `<leader>uh` | Effacer la surbrillance     | `:nohlsearch`                         |
| `<leader>uI` | Toggle inlay hints (global) | `vim.lsp.inlay_hint`                  |

---

## `<leader>m` — Messages (Noice)

Accès à l'historique et aux outils de notification.

| Raccourci    | Description               | Commande/Plugin   |
| ------------ | ------------------------- | ----------------- |
| `<leader>mh` | Historique des messages   | `:NoiceHistory`   |
| `<leader>ml` | Dernier message           | `:NoiceLast`      |
| `<leader>me` | Messages d'erreur         | `:NoiceErrors`    |
| `<leader>ms` | Statistiques de débogage  | `:NoiceStats`     |
| `<leader>mt` | Historique dans Telescope | `:NoiceTelescope` |
| `<leader>mc` | Fermer les notifications  | `:NoiceDismiss`   |
| `<leader>md` | Désactiver Noice          | `:NoiceDisable`   |
| `<leader>ma` | Réactiver Noice           | `:NoiceEnable`    |

---

## `<leader>l` — Lazy

Gestion des plugins avec Lazy.nvim.

| Raccourci    | Description               | Commande/Plugin |
| ------------ | ------------------------- | --------------- |
| `<leader>ll` | Ouvrir Lazy               | `:Lazy`         |
| `<leader>lu` | Mettre à jour les plugins | `:Lazy update`  |
| `<leader>ls` | Synchroniser les plugins  | `:Lazy sync`    |

---

## Raccourcis pour des fonctionnalités spécifiques (hors `which-key`)

| Raccourci | Description                   | Commande/Plugin |
| --------- | ----------------------------- | --------------- |
| `<Alt>s`  | Sélection complète du fichier | **N** : `ggVG`  |
