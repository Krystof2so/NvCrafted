## Auto-commandes — Comportements automatiques (core.autocmds)

**NvCrafted** centralise les réactions automatiques de **Neovim** dans le fichier `lua/core/autocmds.lua`.

Une auto-commande définit un comportement déclenché automatiquement lorsqu’un événement Neovim se produit (ouverture de fichier, changement de fenêtre, etc.).

### Principes architecturaux

- Une auto-commande = une intention claire
- Un groupe = une responsabilité
- Aucun comportement implicite ou magique
- Aucune dépendance directe à des *plugins*
- Les auto-commandes définissent quand un comportement s’applique, jamais comment il est implémenté

### Groupes d’auto-commandes définis

#### **NvCraftedGeneral** — Socle fondamental

  - Restauration automatique de la position du curseur
  - Lorsqu’un fichier est rouvert, le curseur revient à la dernière position connue.
  - Comportement attendu dans un éditeur moderne.
  - Sécurisé (position valide uniquement).

#### **NvCraftedFolding** — Lecture initiale des fichiers

- Tous les fichiers s’ouvrent avec les *folds* dépliés.
- Le *folding* reste ensuite entièrement manuel.
- Compatible avec **Tree-sitter** et les méthodes de *folding* modernes.

Objectif : garantir une lecture immédiate et non intrusive.

#### **NvCraftedSpell** — Orthographe contextuelle

- Le correcteur orthographique est activé uniquement pour les fichiers rédactionnels :
  - `markdown`
  - `text`
  - `rst`

La logique avancée de gestion des dictionnaires (anglais, français, dictionnaire personnalisé, compilation automatique, ajout des mots validés) est volontairement déportée dans le module dédié :

### Séparation des responsabilités

| Fichier | Rôle |
|------|------|
| `core.options.lua` | État global par défaut |
| `core.autocmds.lua` | Quand appliquer un comportement |
| `core.spell.lua` | Comment fonctionne l’orthographe |
| `core.keymaps.lua` | Interactions utilisateur |

Cette séparation garantit un socle stable, lisible et extensible, sur lequel les phases suivantes de **NvCrafted** peuvent s’appuyer.

