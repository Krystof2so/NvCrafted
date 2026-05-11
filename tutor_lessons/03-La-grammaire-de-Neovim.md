## Leçon 3 — La grammaire de Neovim : verbe + mouvement

> Neovim Tutor · Niveau : Grand débutant
> Navigation : `]l` leçon suivante · `[l` leçon précédente · `q` quitter

---

## Neovim parle un langage

Neovim n'est pas une collection de raccourcis à mémoriser un par un. C'est un langage composable : chaque action se construit comme une phrase, avec un verbe et un complément.

Une fois cette grammaire comprise, des centaines de combinaisons deviennent naturelles, et ce sans les avoir jamais apprises explicitement.

---

## 1. Les verbes

Les verbes sont les opérations fondamentales. Seuls, ils ne font rien. Ils attendent un complément pour savoir sur quoi agir.

```txt
┌────────────────────────────────────────────────────────────────┐
│   LES VERBES PRINCIPAUX                                        │
│                                                                │
│    d   ──►    delete   Supprimer (le texte est coupé)          │
│    y   ──►    yank     Copier   (le texte est conservé)        │
│    c   ──►    change   Changer  (supprime et passe en Insert)  │
│    >   ──►    indent   Indenter à droite                       │
│    <   ──►    indent   Indenter à gauche                       │
└────────────────────────────────────────────────────────────────┘
```

💡 `d` et `c` font la même suppression, mais `c` bascule ensuite en mode `Insert` pour écrire immédiatement le texte de remplacement. C'est la différence fondamentale entre les deux.

---

## 2. Les mouvements comme compléments

Les mouvements vus en leçon 2 (`w`, `b`, `e`, `$`, `0`, `G`…) servent aussi de compléments aux verbes. La phrase se lit ainsi :

```txt
  verbe + mouvement  =  action sur le texte entre le curseur et la destination
```

### Exemples concrets

```txt
┌──────────────────────────────────────────────────────────────────────┐
│   VERBE + MOUVEMENT                                                  │
│                                                                      │
│    dw    ──►    Supprimer du curseur jusqu'au début du mot suivant   │
│    db    ──►    Supprimer du curseur jusqu'au début du mot précédent │
│    d$    ──►    Supprimer du curseur jusqu'à la fin de la ligne      │
│    d0    ──►    Supprimer du curseur jusqu'au début de la ligne      │
│    dG    ──►    Supprimer du curseur jusqu'à la fin du fichier       │
│    dgg   ──►    Supprimer du curseur jusqu'au début du fichier       │
│                                                                      │
│    yw    ──►    Copier du curseur jusqu'au début du mot suivant      │
│    y$    ──►    Copier du curseur jusqu'à la fin de la ligne         │
│    yG    ──►    Copier du curseur jusqu'à la fin du fichier          │
│                                                                      │
│    cw    ──►    Changer jusqu'au mot suivant (puis mode Insert)      │
│    c$    ──►    Changer jusqu'à la fin de la ligne (puis Insert)     │
│    cG    ──►    Changer jusqu'à la fin du fichier (puis Insert)      │
│                                                                      │
│    >G    ──►    Indenter de la ligne courante jusqu'à la fin         │
│    <gg   ──►    Désindenter de la ligne courante jusqu'au début      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Le doublement : agir sur la ligne entière

Doubler un verbe applique l'opération sur la ligne entière, curseur inclus. C'est un raccourci très fréquent.

```txt
┌─────────────────────────────────────────────────────┐
│   VERBE DOUBLÉ = ACTION SUR LA LIGNE ENTIÈRE        │
│                                                     │
│    dd   ──►    Supprimer la ligne entière           │
│    yy   ──►    Copier la ligne entière              │
│    cc   ──►    Changer la ligne entière (→ Insert)  │
│    >>   ──►    Indenter la ligne d'un niveau        │
│    <<   ──►    Désindenter la ligne d'un niveau     │
└─────────────────────────────────────────────────────┘
```

---

## 4. Le compteur : multiplier une action

Un nombre placé avant le verbe (ou le mouvement) répète l'action autant de fois. La syntaxe complète est :

```txt
  [compteur]  verbe  [compteur]  mouvement
```

Les deux compteurs se multiplient si les deux sont présents.

```txt
┌────────────────────────────────────────────────────────────────────┐
│   EXEMPLES AVEC COMPTEUR                                           │
│                                                                    │
│    3dw    ──►    Supprimer les 3 prochains mots                    │
│    5dd    ──►    Supprimer les 5 prochaines lignes                 │
│    2yy    ──►    Copier les 2 prochaines lignes                    │
│    4j     ──►    Descendre de 4 lignes                             │
│    2cw    ──►    Changer les 2 prochains mots (puis Insert)        │
│    3>>    ──►    Indenter les 3 prochaines lignes d'un niveau      │
│    2d3w   ──►    Supprimer 6 mots (2 × 3)                          │
└────────────────────────────────────────────────────────────────────┘
```

---

## 5. Résumé de la grammaire

```txt
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│     [compteur]   verbe   [compteur]   mouvement                  │
│                                                                  │
│         2          d          3           w                      │
│         └──────────┴──────────┴───────────┘                      │
│                  supprimer 6 mots                                │
│                                                                  │
│    ──────────────────────────────────────────────────────────    │
│                                                                  │
│    Verbes     :   d  y  c  >  <                                  │
│    Mouvements :   w  b  e  $  0  G  gg  j  k  …                  │
│    Doublement :   dd  yy  cc  >>  <<  (ligne entière)            │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## Exercices

🪧 Rappel : rester en mode `Normal` pour tous ces exercices, sauf indication contraire. Appuyer sur `<Esc>` pour y revenir à tout moment.

---

### Exercice 1 — Supprimer des mots

Le texte ci-dessous contient des mots en trop. Les supprimer avec `dw`.

    Le chat   noir et blanc    saute par-dessus    l  a   clôture.

Instructions :

1. Placer le curseur sur le premier espace superflu (entre `chat` et `noir`)
2. Utiliser `dw` pour supprimer le mot en trop
3. Répéter jusqu'à obtenir : `Le chat noir et blanc saute par-dessus la clôture.`

💡 Essayer `3dw` pour supprimer plusieurs mots d'un coup.

---

### Exercice 2 — Supprimer des lignes et les coller ailleurs

Le bloc ci-dessous a ses lignes dans le mauvais ordre. Les réorganiser en utilisant `dd` pour couper et `p` pour coller.

    Troisième étape : vérifier le résultat.
    Première étape : ouvrir le fichier.
    Deuxième étape : effectuer les modifications.

Instructions :

1. Placer le curseur sur la ligne `Troisième étape…`
2. Appuyer sur `dd` pour la couper
3. Placer le curseur sur la ligne `Deuxième étape…`
4. Appuyer sur `p` pour coller après la ligne courante
5. Vérifier que l'ordre est correct : Première → Deuxième → Troisième

#️⃣ `p` colle après la ligne courante. `P` (majuscule) colle avant.

---

### Exercice 3 — Dupliquer des lignes avec `yy` + `p`

    function saluer()
        print("Bonjour !")
    end

Instructions :

1. Placer le curseur sur la ligne `print("Bonjour !")`
2. Appuyer sur `yy` pour copier la ligne
3. Appuyer sur `p` pour la coller en dessous
4. Passer en mode Insert (`cw` ou `i`) sur la copie et remplacer `Bonjour` par `Bonsoir`
5. Résultat attendu :

```
    function saluer()
        print("Bonjour !")
        print("Bonsoir !")
    end
```

---

### Exercice 4 — Changer du texte avec `c`

Le texte ci-dessous contient des valeurs à remplacer. Utiliser `cw` pour changer chaque mot directement.

    La couleur préférée est COULEUR et la saison est SAISON.

Instructions :

1. Placer le curseur sur `COULEUR`
2. Appuyer sur `cw` — le mot est supprimé et Neovim passe en Insert
3. Taper `bleu`, puis `<Esc>`
4. Naviguer jusqu'à `SAISON`
5. Appuyer sur `cw`, taper `l'automne`, puis `<Esc>`

👀 Observer la différence avec `dw` : `cw` permet d'écrire immédiatement le texte de remplacement sans changer de mode manuellement.

---

### Exercice 5 — Compteur et indentation

Le bloc de code ci-dessous est mal indenté. Corriger avec `>>` et le compteur.

    def calculer():
    résultat = 10 + 20
    print(résultat)
    return résultat

Instructions :

1. Placer le curseur sur la ligne `résultat = 10 + 20`
2. Appuyer sur `3>>` pour indenter les 3 lignes d'un niveau
3. Résultat attendu :

```
    def calculer():
        résultat = 10 + 20
        print(résultat)
        return résultat
```

---

## À retenir

- Neovim fonctionne comme un langage : verbe + mouvement = action.
- Le doublement (`dd`, `yy`, `cc`) agit sur la ligne entière.
- Le compteur multiplie n'importe quelle action : `3dw`, `5j`, `2yy`.
- `d` supprime ; `c` supprime et bascule en mode `Insert`.
- Les mouvements appris en leçon 2 sont les compléments de ce langage.

---

## Prochaine leçon

Leçon 4 — Les objets textuels : `iw`, `a"`, `i(` et les autres —
la façon la plus précise de désigner ce sur quoi on veut agir.

Appuyer sur `]l` pour continuer.
