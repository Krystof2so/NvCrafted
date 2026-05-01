## Leçon 1 — Les modes de Neovim

> Neovim Tutor · Niveau : Grand débutant
> Navigation : <]l> leçon suivante · <[l> leçon précédente · <q> quitter

---

## Bienvenue dans NvCrafted Tutor !

Neovim n'est pas un éditeur comme les autres.
Avec la plupart des éditeurs, nous saisissons simplement du texte.
Avec Neovim, tout dépend du mode dans lequel nous nous trouvons.

C'est déroutant au début, mais c'est précisément ce qui rend Neovim
si puissant une fois maîtrisé.

---

## Les quatre modes principaux

### 🟦 Mode Normal

C'est le mode par défaut au démarrage. Nous n'écrivons pas de texte ici : nous naviguons, nous supprimons, nous copions, nous collons.

Il est à penser comme à un "mode de commande". Chaque touche est un ordre donné à Neovim.

Pour y revenir depuis n'importe quel autre mode :

<Esc> : retour au mode Normal (toujours)
<C-[> : équivalent à <Esc>

---

### 🟩 Mode Insert

C'est avec ce mode que nous écrivons du texte, au même titre qu'un éditeur classique.

```txt
┌────────────────────────────────────────────────────────┐
│   ENTRER EN MODE INSERT DEPUIS LE MODE NORMAL          │
│                                                        │
│    i   ──►    Avant le curseur                         │
│    a   ──►    Après le curseur (append)                │
│    I   ──►    En début de ligne                        │
│    A   ──►    En fin de ligne                          │
│    o   ──►    Création d'une nouvelle ligne en dessous │
│    O   ──►    Création d'une nouvelle ligne au dessus  │
└────────────────────────────────────────────────────────┘
```

Le bas de l'écran affiche "-- INSERT --" quand nous sommes dans ce mode.

---

### 🟨 Mode Visual

Permet de **sélectionner du texte** pour le copier, le supprimer, l'indenter, etc.

```txt
┌─────────────────────────────────────────────────────┐
│    v       ──►    Sélection caractère par caractère │
│    V       ──►    Sélection ligne par ligne         │
│    <C-v>   ──►    Sélection en bloc (rectangle)     │
└─────────────────────────────────────────────────────┘
```

Une fois la sélection faite, nous pouvons réaliser certaines opérations :

```txt
┌──────────────────────────────────────┐
│    d   ──►    Supprimer la sélection │
│    y   ──►    Copier la sélection    │
│    >   ──►    Indenter à droite      │
│    <   ──►    Indenter à gauche      │
└──────────────────────────────────────┘
```

---

### 🟥 Mode Command

Permet d'exécuter des commandes Neovim en tapant `:`.

```txt
┌────────────────────────────────────────────────────────────┐
│    :w      ──►    Sauvegarder le fichier                   │
│    :q      ──►    Quitter                                  │
│    :wq     ──►    Sauvegarder et quitter                   │
│    :q!     ──►    Quitter sans sauvegarder (force)         │
│    :help   ──►    Création d'une nouvelle ligne en dessous │
└────────────────────────────────────────────────────────────┘
```

Le curseur se déplace en bas de l'écran sur la ligne de commande (avec NvCrafted, c'est une boîte de dialogue qui s'ouvre avec une `invit` en forme de crayon).

Appuyer sur `<Esc>` pour annuler et revenir au mode Normal.

---

## Résumé visuel

```txt
┌─────────────────────────────────────────┐
│   (point de départ, toujours <Esc>)     │
│                                         │
│   i/a/o ──► INSERT   (écrire du texte)  │
│   v/V   ──► VISUAL   (sélectionner)     │
│   :     ──► COMMAND  (commandes)        │
└─────────────────────────────────────────┘
```

---

## Exercices

### Exercice 1 — Entrer et quitter le mode Insert

Le texte ci-dessous contient une faute. La corriger :

    Neovim est un édituer très puissant.

Instructions :

1. Placer le curseur sur la première lettre du mot `édituer`
2. Appuie sur `cw` (`cw` = `change word`, pour effacer le mot et entrer en mode Insert
3. Taper `éditeur`
4. Appuyer sur `<Esc>` pour revenir en mode Normal

💡 Une instruction comme `cw` sera abordée dans une leçon ultérieure.

---

### Exercice 2 — Sélectionner avec le mode Visual

    La programmation est un art. Chaque ligne de code raconte une histoire.
    Neovim te donne les outils pour écrire cette histoire avec précision.

Instructions :

1. Placer le curseur n'importe où sur la première ligne
2. Appuyer sur `V` pour entrer en mode Visual linéaire
3. La ligne entière est sélectionnée (observer le bas de l'écran)
4. Appuyer sur `<Esc>` pour désélectionner et revenir en Normal

---

### Exercice 3 — Le mode Command

Instructions :

1. Appuyer sur `:` — Le curseur saute en bas de l'écran (ouverture d'une boîte de dialogue avec NvCrafted)
2. Taper `echo "Bonjour depuis Neovim !"` puis `<Enter>`
3. Affichage du le message en bas (dans une boîte de notification avec NvCrafted)

---

## À retenir

- Au démarrage de Neovim, nous sommes toujours en mode Normal.
- `<Esc>` ramène toujours en mode Normal, depuis n'importe quel mode.
- Le mode courant est affiché en bas à gauche de l'écran.

---

## Prochaine leçon

Leçon 2 — Navigation de base : apprendre à se déplacer dans un fichier sans jamais toucher
aux flèches directionnelles.

Appuyer sur `]l` pour continuer.
