# Liste de commandes pour **NvCrafted**

Mon souhait est de m'attaquer au _mapping_, de sortir d'une logique d'un _mapping_ définit par _plugin_ (_Quel plugin fait quoi ?_), mais bien d'être dans une logique d'actions (_qu'est-ce que je veux faire ?_). Cela fait plusieurs jours que j'y réfléchis, et voici ci-dessous ce que j'envisage. Mais avant de me lancer dans la réorganisation des _mappings_, vu que vous avez l'habitude d'utiliser des IDE, je voudrais votre avis sur cette possible réorganisation.

Fichier à mettre à jour, en tenant compte de l'organisation suivante :

## Hiérarchie envisagée

- `<leader>c` -> Actions sur le code : LSP (_rename_, _action_, _hints_, diagnostics flottants), annotations **Neogen**, commentaires
- `<leader>b` -> Actions sur les _Buffers_ : Navigation, fermeture, épinglage, tri, liste
- `<leader>f` -> Actions sur les fichiers : Recherche fichiers/texte, TODOs, historique
- `<leader>n` -> Navigation : **Aerial**, **Neotree**, saut vers erreur suivante/précédente
- `<leader>d`-> Diagnostics : **Trouble** (liste), saut entre diagnostics
- `<leader>u` -> UI: Thème, Zen mode, _toggle inlay hints_ global, _nohlsearch_
- `<leader>l` -> **Lazy** : _Update_, _sync_, _open_
- `<leader>m` -> Messages : **Noice** (historique, erreurs, stats)

## Prévoir

### Réorganisation des groupes

- `<leader>e` (**Neotree**) → `<leader>n` (Navigation), avec **Aerial**.
- `<leader>n` (**Noice**) → `<leader>m` (**Messages**).
- `<leader>t` (thème) et `<leader>h` (_hlsearch_) → `<leader>u` (UI), avec le _toggle hints_ global `<leader>uI`.

### Fermeture de buffers

Les raccourcis `<leader>bcc`, `<leader>bca`… simplifiés en `<leader>bx` (fermer), `<leader>ba` (tous sauf actuel), etc. (des lettres plus mnémotechniques que des combinaisons avec `c`.

### Diagnostics — deux niveaux

- `<leader>dl` et `<leader>ds` dans `keymaps.lua` pour \*_Trouble_ (global).
- `<leader>dd`, `<leader>dn`, `<leader>dp` dans `on_attach.lua` pour le flottant et la navigation entre diagnostics (_buffer_-local).
- **Which-key** doit fusionner les deux dans le même groupe `<leader>d`.
