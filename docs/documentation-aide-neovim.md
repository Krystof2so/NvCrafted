# La documentation intégrée de Neovim et sa francisation dans NvCrafted

## Introduction

**Neovim** embarque son propre système de documentation, consultable sans jamais quitter l'éditeur ni ouvrir un navigateur. C'est un des piliers de la philosophie pédagogique de **NvCrafted** : comprendre un outil passe par la capacité à interroger sa documentation *depuis* l'outil lui-même.

Ce document explique :

- comment naviguer dans l'aide intégrée de **Neovim**,
- comment cette aide est structurée en interne,
- comment **NvCrafted** la francise partiellement,
- comment étendre cette francisation (nouvelle langue, nouveau fichier).

---

## Philosophie

**NvCrafted** applique à l'aide intégrée les mêmes principes qu'au reste de la configuration :

- **Aucune dépendance externe** : pas de plugin pour lire la documentation, uniquement le système natif `:help`.
- **Explicite plutôt qu'implicite** : la francisation n'écrase rien, elle *ajoute* une couche consultée en priorité, avec repli automatique vers l'anglais.
- **Réversible** : à tout moment, la documentation anglaise originelle reste accessible telle quelle.

---

## 1. Utiliser l'aide intégrée de Neovim

### Rechercher une entrée d'aide

```vim
:help mot
```

En tapant `:help` suivi du début d'un mot puis `<Tab>`, **Neovim** propose une complétion sur l'ensemble des balises (*tags*) disponibles dans tous les fichiers d'aide chargés (natifs + plugins) :

```vim
:help mot<Tab>
```

### Aide contextuelle sur le mot sous le curseur

```vim
:help!
```

Cette variante devine une balise d'aide à partir du mot (`WORD`) sous le curseur, en retirant la ponctuation environnante jusqu'à trouver une correspondance valide (approche *"Do What I Mean"*).

### Naviguer dans une page d'aide

| Commande        | Action                                                              |
| --------------- | -------------------------------------------------------------------- |
| `gO`             | Affiche le sommaire de la page d'aide courante (table des matières) |
| `CTRL-]`         | Saute vers la balise sous le curseur                                |
| `K`              | Aide contextuelle sur le mot sous le curseur (natif ou LSP selon le *buffer*) |
| `CTRL-O` / `CTRL-I` | Retour / avance dans l'historique de navigation (*jumplist*)     |
| `:helpc` ou `:helpclose` | Ferme la fenêtre d'aide                                     |

> Dans **NvCrafted**, les *buffers* d'aide s'ouvrent automatiquement en split vertical à droite (largeur fixe de 85 colonnes) — cf. le groupe d'auto-commandes `NvCraftedGeneral` dans `core/autocmds.lua`. La touche `q` y est également mappée pour fermer rapidement le *buffer* (groupe `NvCraftedUI`).

### Rechercher dans l'ensemble des fichiers d'aide

```vim
:helpgrep motif
```

Recherche `motif` (une expression régulière **Vim**) dans **tous** les fichiers d'aide disponibles et remplit la liste *quickfix* avec les correspondances. Navigation ensuite via `:cnext` / `:cprev`, ou `:cwindow` pour lister les résultats dans un panneau dédié.

```vim
:helpgrep uganda\c   " recherche insensible à la casse (\c)
```

### Ajouter ses propres fichiers d'aide

**Neovim** permet d'ajouter de la documentation locale (pour un plugin personnel, ou — comme ici — pour une traduction) sans modifier les fichiers distribués avec l'éditeur. Voir :

```vim
:h add-local-help
:h write-local-help
:h help-writing
```

Point important : la première ligne de tout fichier d'aide local est automatiquement recensée dans la section **LOCAL ADDITIONS** du fichier `help.txt` — c'est ce mécanisme qui permet à `:help` de "découvrir" les fichiers ajoutés sans configuration supplémentaire.

---

## 2. Comment Neovim structure sa documentation

Avant d'aborder la francisation, il faut comprendre trois éléments internes :

### Les fichiers `.txt`

Chaque fichier d'aide (`help.txt`, `motion.txt`, etc.) est un fichier texte structuré, où chaque balise est délimitée par des astérisques : `*nom-de-la-balise*`.

### Les fichiers `tags`

À l'intérieur de chaque dossier `doc/` du `runtimepath`, un fichier `tags` recense l'intégralité des balises disponibles, sous la forme :

```text
nom-balise    fichier.txt    /*nom-balise*
```

C'est ce fichier qui permet à `:help nom-balise` de savoir où sauter. Il est généré (ou régénéré) via :

```vim
:helptags chemin/vers/doc
:helptags ALL   " régénère pour tous les dossiers doc/ du runtimepath
```

### Le `runtimepath`

**Neovim** cherche l'aide dans **tous** les dossiers `doc/` présents dans son `runtimepath` — c'est-à-dire aussi bien la documentation native que celle fournie par les plugins installés (via **lazy.nvim**), ainsi que celle placée directement dans `~/.config/nvim/doc/`.

---

## 3. Les fichiers d'aide traduits (`help-translated`)

**Neovim** prévoit nativement un mécanisme de traduction de sa documentation, indépendant de tout plugin.

### Convention de nommage

Un ensemble de fichiers traduits pour une langue donnée suit ce schéma :

```text
help.abx
motion.abx
...
tags-ab
```

où `ab` est le code de langue **ISO 639-1** à deux lettres. Exemple pour le français :

```text
help.frx
motion.frx
...
tags-fr
```

Le fichier porte la même **balise d'en-tête** que la version anglaise originelle — c'est ce qui garantit que `:help` sait faire le lien entre les deux versions d'un même sujet.

### L'option `helplang`

L'option `'helplang'` définit l'ordre de préférence des langues consultées par `:help` :

```lua
vim.opt.helplang = "fr,en"
```

Avec ce réglage :

1. **Neovim** cherche d'abord une correspondance dans les fichiers `.frx` (français).
2. Si aucune traduction n'existe pour la balise demandée, il retombe **automatiquement** sur la version anglaise (`.txt`), sans erreur ni configuration supplémentaire.

### Forcer une langue précise

Il est possible de forcer la consultation d'une langue précise, indépendamment de `'helplang'`, en suffixant la balise avec `@` suivi du code langue :

```vim
:help sujet@en   " force la version anglaise
:help sujet@fr   " force la version française
```

C'est une commande à connaître en particulier lorsqu'une traduction existe mais semble imprécise ou obsolète : `@en` permet de vérifier la formulation originale sans changer `'helplang'`.

---

## 4. La francisation dans NvCrafted

### Fichiers actuellement traduits

| Fichier `doc/`   | Contenu                          | Balise d'en-tête   |
| ----------------- | --------------------------------- | ------------------- |
| `help.frx`        | Sommaire général de l'aide Neovim | `*help.txt*`         |
| `helphelp.frx`     | Utilisation du système d'aide lui-même | `*helphelp.txt*` |
| `motion.frx`       | Référence complète des mouvements du curseur | `*motion.txt*` |

Ces trois fichiers ont été traduits selon la convention `help-translated` décrite ci-dessus, chacun conservant scrupuleusement la même balise d'en-tête que son homologue anglais.

### Le fichier `tags-fr`

Le dossier `doc/` de **NvCrafted** contient un fichier `tags-fr`, généré via :

```vim
:helptags ~/.config/nvim/doc
```

Ce fichier recense toutes les balises présentes dans les `.frx` de **NvCrafted** et associe chacune à son fichier `.frx` correspondant — c'est le mécanisme qui permet à `:help mot` d'ouvrir directement `motion.frx` plutôt que `motion.txt` lorsque `'helplang'` place le français en priorité.

### Activation dans la configuration

La priorité linguistique est déclarée dans `lua/core/options.lua` :

```lua
opt.helplang = "fr,en" -- str : Langues de l'aide intégrée
```

Avec ce réglage, taper `:help motion.txt` ou naviguer via `CTRL-]` / `K` ouvre en priorité `motion.frx` si la balise y existe, et retombe silencieusement sur l'anglais sinon (par exemple pour un plugin dont l'aide n'a pas été traduite).

### Contrainte : les `.frx` ne sont pas directement éditables

Les fichiers `.frx` sont des fichiers texte comme les autres, mais **NvCrafted** les traite comme des artefacts générés/figés plutôt que comme des fichiers de travail courants. Pour les modifier :

1. Convertir temporairement le `.frx` en `.txt` (simple renommage/copie) afin de profiter de la coloration syntaxique et des vérifications adaptées aux fichiers d'aide anglais.
2. Effectuer les modifications.
3. Renommer le fichier modifié en `.frx`.
4. **Si une balise a été ajoutée, renommée ou supprimée**, régénérer `tags-fr` :

```vim
:helptags ~/.config/nvim/doc
```

> ⚠️ Oublier cette régénération après modification des balises est la cause la plus fréquente d'un lien `:help` cassé ou d'un `CTRL-]` qui ne trouve plus la bonne page.

### Pourquoi les traductions sont-elles prioritaires ?

Puisque `'helplang'` place `fr` avant `en`, une entrée traduite masque son équivalent anglais par défaut. C'est un choix assumé de **NvCrafted** : la lecture native en français doit être le comportement par défaut, l'anglais restant à un `@en` de distance pour vérifier une formulation technique ou une nuance de traduction.

---

## 5. Étendre la francisation à d'autres fichiers ou langues

### Traduire un nouveau fichier d'aide

1. Copier le fichier `.txt` source (natif ou d'un plugin) vers `doc/`.
2. Le renommer avec l'extension `.frx` (ex. `change.txt` → `change.frx`).
3. Traduire le contenu **sans modifier les balises** (`*nom-balise*`) ni la première ligne d'en-tête (balise + description courte), qui doit rester identique à l'original pour que le lien fonctionne.
4. Régénérer les balises :

```vim
:helptags ~/.config/nvim/doc
```

### Ajouter une langue supplémentaire

Le mécanisme `help-translated` n'est pas limité au français. Pour ajouter par exemple l'espagnol :

```text
doc/help.esx
doc/motion.esx
doc/tags-es
```

Puis mettre à jour l'ordre de préférence dans `core/options.lua` :

```lua
opt.helplang = "fr,es,en"
```

**Neovim** parcourt alors la liste dans l'ordre, langue par langue, jusqu'à trouver une correspondance — retombant en dernier recours sur l'anglais natif, toujours présent.

---

## 6. Récapitulatif des commandes essentielles

| Commande                       | Description                                                        |
| -------------------------------- | --------------------------------------------------------------------- |
| `:help mot`                      | Ouvre l'aide sur `mot`                                               |
| `:help mot<Tab>`                 | Propose une complétion des balises disponibles                       |
| `:help!`                         | Devine une balise à partir du mot sous le curseur                    |
| `:help sujet@en`                 | Force la consultation de la version anglaise d'un sujet               |
| `gO`                              | Affiche le sommaire de la page d'aide courante                       |
| `CTRL-]`                          | Saute vers la balise sous le curseur                                 |
| `K`                               | Aide contextuelle (mot sous le curseur)                              |
| `CTRL-O` / `CTRL-I`               | Navigue dans l'historique des sauts d'aide                           |
| `:helpc` / `:helpclose`          | Ferme la fenêtre d'aide                                              |
| `:helpgrep motif`                | Recherche `motif` dans tous les fichiers d'aide (résultats en *quickfix*) |
| `:helptags chemin/vers/doc`      | (Re)génère le fichier `tags` d'un dossier `doc/` donné               |
| `:helptags ALL`                  | (Re)génère les `tags` de tous les dossiers `doc/` du `runtimepath`   |

---

## Conclusion

La documentation intégrée de **Neovim** est un système à part entière, indépendant de tout plugin, capable d'accueillir nativement des traductions grâce à la convention `help-translated`. **NvCrafted** s'appuie entièrement sur ce mécanisme natif — sans aucune dépendance supplémentaire — pour offrir une lecture en français de certaines pages centrales (`help.txt`, `helphelp.txt`, `motion.txt`), tout en garantissant un repli transparent vers l'anglais partout ailleurs.

Ce choix illustre un principe plus large de **NvCrafted** : préférer systématiquement les mécanismes natifs de **Neovim** à l'ajout de dépendances, même pour des fonctionnalités qui semblent, à première vue, appeler un plugin dédié.
