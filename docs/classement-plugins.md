# Classement des plugins dans NvCrafted — Conventions de domaine

Ce document documente le critère de classement des _plugins_ dans les cinq domaines fonctionnels de `lua/plugins/` : `appearance/`, `navigation/`, `editing/`, `ux/` et `meta/`. Il explique le pourquoi de chaque domaine, pose un critère de décision pour les cas ambigus, et liste les _plugins_ existants avec leur justification.

---

## Principe directeur

Le classement d'un _plugin_ ne dépend pas de son apparence visuelle ou de sa complexité, mais de la question suivante :

> À quel moment du flux de travail ce plugin intervient-il, et quel geste utilisateur déclenche-t-il ?

Cinq réponses possibles, cinq domaines :

| Geste / moment                                     | Domaine       |
| -------------------------------------------------- | ------------- |
| Je regarde l'éditeur — il affiche passivement      | `appearance/` |
| Je cherche quelque chose et je me déplace vers lui | `navigation/` |
| J'écris, je transforme, je génère du code          | `editing/`    |
| L'éditeur interagit avec moi, m'assiste, m'oriente | `ux/`         |
| NvCrafted se documente et s'enseigne lui-même      | `meta/`       |

Le domaine `lsp/` est un cas à part : il ne suit pas cette logique. Il est documenté séparément dans `docs/lsp-nvcrafted.md`.

---

## `plugins/appearance/` — Ce qui est rendu passivement

### Définition

Un _plugin_ appartient à `appearance/` s'il modifie l'aspect visuel statique de l'éditeur, indépendamment de toute action de l'utilisateur. Il répond à la question : _à quoi ressemble mon éditeur quand je ne fais rien ?_

### Critères

- définit ou applique un thème de couleurs
- affiche des informations permanentes en dehors du _buffer_ (barre de statut, onglets, écran d'accueil)
- ne réagit pas à une action d'édition — il est toujours présent, en arrière-plan

### Plugins actuels

| Fichier          | Plugin       | Justification                                          |
| ---------------- | ------------ | ------------------------------------------------------ |
| `alpha.lua`      | alpha-nvim   | Écran d'accueil — affiché passivement au démarrage     |
| `barbar.lua`     | barbar.nvim  | _Tabline_ — affichage permanent des buffers ouverts    |
| `lualine.lua`    | lualine.nvim | Barre de statut — affichage permanent sous le _buffer_ |
| `nordic.lua`     | nordic.nvim  | Thème de couleurs                                      |
| `everviolet.lua` | evergarden   | Thème de couleurs                                      |
| `rose-pine.lua`  | rose-pine    | Thème de couleurs — thème par défaut de NvCrafted      |

> **Pourquoi les thèmes sont dans `appearance/` et non dans un dossier `themes/` dédié** : les fichiers de thèmes sont des _plugins_ **Lazy** comme les autres. Les isoler dans un sous-dossier séparé créerait une exception dans le système de scan automatique de `plugins/init.lua` sans bénéfice architectural. Un domaine par intention, sans exception.

---

## `plugins/navigation/` — Se déplacer vers quelque chose

### Définition

Un _plugin_ appartient à `navigation/` s'il permet à l'utilisateur de chercher quelque chose et de se déplacer vers lui — dans l'arborescence, dans le code, dans les résultats de diagnostic. Il répond à la question : _comment est-ce que je trouve et j'atteins ce que je cherche ?_

### Critères

- ouvre un panneau ou une fenêtre dédiée à la recherche ou à la liste
- le geste principal est un déplacement du curseur ou du focus
- n'intervient pas dans l'écriture du code elle-même

### Plugins actuels

| Fichier         | Plugin         | Justification                                                      |
| --------------- | -------------- | ------------------------------------------------------------------ |
| `aerial.lua`    | aerial.nvim    | Navigation dans la structure du fichier courant via un panneau     |
| `neo_tree.lua`  | neo-tree.nvim  | Exploration de l'arborescence — navigation vers un fichier         |
| `telescope.lua` | telescope.nvim | Recherche de fichiers, de texte, de symboles — navigation générale |
| `trouble.lua`   | trouble.nvim   | Liste navigable de diagnostics LSP — navigation vers les erreurs   |

> **Note sur `trouble.nvim`** : bien qu'il consomme des données LSP, sa fonction est de présenter ces données sous forme de liste navigable. Ce rôle de navigation vers les erreurs le rattache à `navigation/`, pas à `lsp/`.

> **Note sur `telescope.nvim`** : **telescope** sert à de nombreuses choses (_buffers_, thèmes, aide), mais son geste fondamental est toujours le même : chercher et se déplacer. Il appartient à `navigation/` quelle que soit la source qu'il interroge.

---

## `plugins/editing/` — Intervenir pendant l'écriture

### Définition

Un _plugin_ appartient à `editing/` s'il intervient directement dans l'acte d'écrire, de lire ou de transformer du code. Il répond à la question : _que se passe-t-il pendant que j'édite un fichier ?_

### Critères

- s'active pendant la frappe ou à la sauvegarde
- analyse, transforme ou génère du contenu dans le _buffer_
- gère la syntaxe, les paires de caractères, les _snippets_, les annotations
- son absence modifie directement l'expérience d'édition

### Plugins actuels

| Fichier             | Plugin             | Justification                                                        |
| ------------------- | ------------------ | -------------------------------------------------------------------- |
| `autopairs.lua`     | nvim-autopairs     | Insère des paires à la frappe — mode insertion                       |
| `blink.lua`         | blink.cmp          | Complétion — intervient directement pendant l'édition                |
| `comment_nvim.lua`  | Comment.nvim       | Transforme des lignes en commentaires — action sur le code           |
| `conform.lua`       | conform.nvim       | Formate le code à la sauvegarde                                      |
| `lazydev.lua`       | lazydev.nvim       | Améliore la complétion LSP pour les fichiers **Lua**                 |
| `multicursor.lua`   | multicursor.nvim   | Curseurs multiples                                                   |
| `neogen.lua`        | neogen             | Génère des annotations — insère du code structuré                    |
| `todo_comments.lua` | todo-comments.nvim | Surligne les marqueurs dans le code — lecture du code                |
| `treesitter.lua`    | nvim-treesitter    | Analyse syntaxique — socle de l'édition intelligente                 |
| `multicursor.lua`   | multicursor.nvim   | Répète l'édition à plusieurs endroits — intervient pendant la frappe |

---

## `plugins/ux/` — L'éditeur interagit avec moi

### Définition

Un _plugin_ appartient à `ux/` s'il modifie la façon dont l'éditeur se comporte avec l'utilisateur : comment il communique, comment il guide, comment il adapte l'environnement de travail. Il répond à la question : _comment l'éditeur me parle et s'adapte à moi ?_

### Critères

- modifie le comportement interactif de l'éditeur (notifications, _cmdline_, _popups_)
- adapte l'environnement au contexte de travail (focus, concentration)
- aide l'utilisateur à découvrir et mémoriser ses propres raccourcis
- ne modifie ni le contenu du code ni la disposition permanente de l'éditeur

### Plugins actuels

| Fichier         | Plugin         | Justification                                                             |
| --------------- | -------------- | ------------------------------------------------------------------------- |
| `noice.lua`     | noice.nvim     | Remplace la _cmdline_ et les notifications — comment l'éditeur communique |
| `which_key.lua` | which-key.nvim | Affiche les raccourcis disponibles — aide à la découvrabilité             |
| `zen-mode.lua`  | zen-mode.nvim  | Réduit les distractions — adapte l'environnement au contexte              |

> **Pourquoi `noice` n'est pas dans `appearance/`** : **noice** modifie le comportement de l'éditeur (comment il répond aux commandes, comment il notifie), pas son apparence statique. Un éditeur sans **noice** fonctionne différemment, pas seulement différemment à regarder.

---

## `plugins/meta/` — NvCrafted se documente lui-même

### Définition

Un _plugin_ appartient à `meta/` s'il concerne **NvCrafted** en tant que projet : son apprentissage, sa documentation intégrée, son auto-description. Il répond à la question : _comment NvCrafted se présente et s'explique à son utilisateur ?_

### Critères

- fournit un tutoriel ou une documentation intégrée à l'éditeur
- concerne NvCrafted lui-même, pas l'édition de code en général
- n'a pas de sens en dehors du contexte de ce _framework_

### Plugins actuels

| Fichier     | Plugin          | Justification                                                        |
| ----------- | --------------- | -------------------------------------------------------------------- |
| `tutor.lua` | nvcrafted-tutor | Tutoriel et documentation intégrée — NvCrafted se documente lui-même |

---

## Règle de décision pour les cas ambigus

Quand un plugin hésite entre deux domaines, appliquer ces questions dans l'ordre :

1. _Est-ce que ce plugin affiche quelque chose de façon permanente et passive, sans action de l'utilisateur ?_
   → Oui : `appearance/`

2. _Est-ce que le geste principal est de chercher quelque chose et de s'y déplacer ?_
   → Oui : `navigation/`

3. _Est-ce que ce plugin intervient pendant la frappe ou la transformation du contenu d'un buffer ?_
   → Oui : `editing/`

4. _Est-ce que ce plugin modifie la façon dont l'éditeur communique avec moi ou adapte mon environnement de travail ?_
   → Oui : `ux/`

5. _Est-ce que ce plugin concerne NvCrafted lui-même en tant que projet ?_
   → Oui : `meta/`

Si un _plugin_ satisfait plusieurs critères, le critère correspondant à sa vocation principale l'emporte. Un _plugin_ qui formate du code et affiche un indicateur dans la _statusline_ appartient à `editing/` — l'indicateur dans la _statusline_ est un effet de bord, pas sa raison d'être.

---

## Synthèse visuelle

```text
lua/plugins/
│
├── appearance/    Ce que je vois passivement
│                  (thèmes, barres, écran d'accueil)
│
├── navigation/    Comment je me déplace
│                  (telescope, neo-tree, aerial, trouble)
│
├── editing/       Ce qui se passe pendant que j'écris
│                  (complétion, formatage, syntaxe, génération)
│
├── ux/            Comment l'éditeur interagit avec moi
│                  (notifications, raccourcis, focus)
│
├── meta/          NvCrafted se documente lui-même
│                  (tutoriel, documentation intégrée)
│
└── lsp/           Infrastructure LSP — domaine à part
                   (voir docs/lsp-nvcrafted.md)
```
