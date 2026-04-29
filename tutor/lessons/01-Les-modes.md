## Leçon 1 — Les modes de Neovim

> NvCrafted Tutor · Niveau : Grand débutant
> Navigation : <]l> leçon suivante · <[l> leçon précédente · <gh> hint · <q> quitter

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
v           sélection caractère par caractère
V           sélection ligne par ligne
<C-v>       sélection en bloc (rectangle)
```

Une fois la sélection faite, nous pouvons réaliser certaines opérations :

```txt
d           supprimer la sélection
y           copier la sélection  (yank)
>           indenter à droite
<           indenter à gauche
```

---

### 🟥 Mode Command

Permet d'exécuter des commandes **Neovim** en tapant `:`.

```txt
:w          sauvegarder le fichier
:q          quitter
:wq         sauvegarder et quitter
:q!         quitter sans sauvegarder (force)
:help       ouvrir l'aide intégrée
```

Le curseur se déplace en bas de l'écran sur la ligne de commande (avec **NvCrafted**, c'est une boîte de dialogue qui s'ouvre avec une `invit` en forme de crayon).

Appuyer sur `<Esc>` pour annuler et revenir au mode _Normal_.

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

<!-- EXERCISE: id=ex01 desc="Entrer et quitter le mode Insert" -->

### Exercice 1 — Entrer et quitter le mode Insert

Le texte ci-dessous contient une faute. La corriger :

    Neovim est un édituer très puissant.

Instructions :

1. Placer le curseur sur le mot `édituer`
2. Appuie sur `dwi` (`dw` pour effacer le mot et `i` pour entrer en mode _Insert_
3. Taper `éditeur`
4. Appuyer sur `<Esc>` pour revenir en mode Normal

💡 Une instruction comme `dw` sera abordée dans une leçon ultérieure.

<!-- END_EXERCISE -->

---

<!-- EXERCISE: id=ex02 desc="Utiliser le mode Visual pour sélectionner une ligne" -->

### Exercice 2 — Sélectionner avec le mode Visual

    La programmation est un art. Chaque ligne de code raconte une histoire.
    Neovim te donne les outils pour écrire cette histoire avec précision.

Instructions :

1. Placer le curseur n'importe où sur la première ligne
2. Appuyer sur `V` pour entrer en mode _Visual linéaire_
3. La ligne entière est sélectionnée — observez le bas de l'écran
4. Appuyer sur `<Esc>` pour désélectionner et revenir en _Normal_

<!-- END_EXERCISE -->

---

<!-- EXERCISE: id=ex03 desc="Exécuter une commande avec le mode Command" -->

### Exercice 3 — Le mode Command

Instructions :

1. Appuyer sur `:` — Le curseur saute en bas de l'écran (ouverture d'une boîte de dialogue avec **NvCrafted**)
2. Taper `echo "Bonjour depuis NvCrafted !"` puis `<Enter>`
3. Affichage du le message en bas (avec **Neovim**, dans une boîte de notification avec **NvCrafted**)

<!-- END_EXERCISE -->

---

## À retenir

- Au démarrage de **Neovim**, nous sommes toujours en mode _Normal_.
- `<Esc>` ramène toujours en mode _Normal_, depuis n'importe quel mode.
- Le mode courant est affiché en bas à gauche de l'écran.

---

## Prochaine leçon

**Leçon 2 — Navigation de base** : apprendre à te déplacer dans un fichier
avec `h` `j` `k` `l`, `w` `b`, `0` `$`, `gg` `G` — sans jamais toucher
aux flèches directionnelles.

Appuyer sur `]l` pour continuer.
