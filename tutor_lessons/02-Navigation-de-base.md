## Leçon 2 — Les bases de la navigation dans Neovim

> Neovim Tutor · Niveau : Grand débutant
> Navigation : <]l> leçon suivante · <[l> leçon précédente · <q> quitter

---

Avec cette leçon nous allons explorer comment naviguer efficacement dans un fichier sans utiliser les touches directionnelles (flèches). Neovim offre des commandes puissantes pour se déplacer rapidement et avec précision. Maîtriser ces commandes est essentiel pour gagner en productivité.

### Objectifs de la leçon

- Se déplacer par mots, lignes et écrans.
- Atteindre le début ou la fin d’un fichier.
- Sauter à un numéro de ligne spécifique.
- Utiliser des commandes pour naviguer verticalement et horizontalement.

---

## 1. Déplacements de base

### 1.1. Déplacement par caractères

Pour se déplacer caractère par caractère (sans utiliser les flèches) :

```txt
┌───────────────────────────────────────────────────────────┐
│    h   ──►    Déplace le curseur d'un caractère à gauche  │
│    j   ──►    Déplace le curseur d'une ligne vers le bas  │
│    k   ──►    Déplace le curseur d'une ligne vers le haut │
│    l   ──►    Déplace le curseur d'un caractère à droite  │
└───────────────────────────────────────────────────────────┘
```

### 1.2. Déplacement par mots

```txt
┌───────────────────────────────────────────────────────────┐
│    w    ──►    Saute au début du mot suivant (`word`)     │
│    b    ──►    Saute au début du mot précédent (`before`) │
│    e    ──►    Saute à la fin du mot actuel (`end`)       │
│    ge   ──►    Saute à la fin du mot précédent            │
└───────────────────────────────────────────────────────────┘
```

Exemple :

```txt
┌───────────────────────────────────────────────────────────┐
│   Dans la phrase "Bonjour tout le monde !", si le curseur │
│   est sur "Bonjour" :                                     │
│                                                           │
│    w   ──►    Place le curseur sur "tout"                 │
│    r   ──►    Place le curseur sur le "r" de "bonjour"    │
│    b   ──►    Revient au début de "bonjour"               │
└───────────────────────────────────────────────────────────┘
```

### 1.3. Déplacement par lignes

```txt
┌─────────────────────────────────────────────────────────────────┐
│    0     ──►    Saute au début de la ligne                      │
│    ^     ──►    Saute au premier caractère non vide de la ligne │
│    $     ──►    Saute à la fin de la ligne                      │
│    gg    ──►    Saute au début du fichier                       │
│    G     ──►    Saute à la fin du fichier                       │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Déplacements avancés

### 2.1. Déplacement par écrans

Pour naviguer écran par écran :

```txt
┌─────────────────────────────────────────────────────────────────────────────────┐
│    <Ctrl-f>    ──►    Fait défiler l'écran d'une page vers le bas (`forward`)   │
│    <Ctrl-b>    ──►    Fait défiler l'écran d'une page vers le haut (`backword`) │
│    <Ctrl-d>    ──►    Fait défiler l'écran d'une demi-page vers le bas          │
│    <Ctrl-u>    ──►    Fait défiler l'écran d'une demi-page vers le haut         │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### 2.2. Sauter à un numéro de ligne

Pour aller directement à une ligne spécifique :

```txt
┌─────────────────────────────────────────────────────────────────────────────────────┐
│    :10    ──►    Saute à la ligne 10 (remplacer 10 par le numéro de ligne souhaité) │
│    :$     ──►    Saute à la dernière ligne du fichier (équivalent à `G`)            │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

### 2.3. Déplacement vertical rapide

```txt
┌─────────────────────────────────────────────────────┐
│    H   ──►    Saute en haut de l'écran (`High`)     │
│    M   ──►    Saute au milieu de l'écran (`Middle`) │
│    L   ──►    Saute en bas de l'écran (`Low`)       │
└─────────────────────────────────────────────────────┘
```

---

## 3. Exercices pratiques

### Exercice 1 : Déplacement par mots

Objectif : Atteindre le mot "Neovim" dans la phrase suivante en utilisant uniquement `w`, `b`, `e` ou `ge` :

"Apprendre à utiliser Neovim est très puissant pour coder."

### Exercice 2 : Déplacement par lignes

Objectif : Atteindre la ligne 15, puis aller au début et à la fin de cette ligne, avant de revenir ici (ligne 120).

### Exercice 3 : Combinaison de commandes

Objectif : Atteindre le 3ème mot de la 5ème ligne en partant du début du fichier.
