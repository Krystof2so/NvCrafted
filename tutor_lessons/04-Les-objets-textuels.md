## Leçon 4 — Les objets textuels

> Neovim Tutor · Niveau : Grand débutant
> Navigation : `]l` leçon suivante · `[l` leçon précédente · `q` quitter

---

## Les "noms" du langage Neovim

En leçon 3, nous avons appris les verbes (`d`, `y`, `c`, `>`) et les mouvements comme compléments (`w`, `$`, `G`, etc.).

Les objets textuels sont une troisième catégorie de compléments, bien plus précis que les mouvements. Là où `dw` supprime _du curseur jusqu'au prochain mot_, `diw` supprime _le mot entier, quel que soit l'endroit du curseur dans ce mot_.

```txt
  verbe + objet textuel  =  action sur une unité de texte délimitée
```

C'est l'une des idées les plus puissantes de Neovim.

---

## 1. Le principe : `i` (inner) et `a` (around)

Chaque objet textuel existe en deux variantes :

```txt
┌───────────────────────────────────────────────────────────────────┐
│   i   ──►    inner   — le contenu seul, sans les délimiteurs      │
│   a   ──►    around  — le contenu ET les délimiteurs              │
└───────────────────────────────────────────────────────────────────┘
```

### Illustration avec un mot

Avec le curseur n'importe où sur le mot `programmation` :

```txt
   La programmation est un art.
      ^^^^^^^^^^^^^
      curseur ici, n'importe où dans le mot

    diw  ──►  "La  est un art."      (le mot est supprimé)
    daw  ──►  "La est un art."       (le mot ET l'espace autour sont supprimés)
```

💡 `daw` est plus propre : il supprime aussi l'espace, évitant un double
espace résiduel. En pratique, `daw` est préféré à `diw` pour les mots.

---

## 2. Les objets disponibles

```txt
┌───────────────────────────────────────────────────────────────────────┐
│   OBJETS TEXTUELS — RÉFÉRENCE COMPLÈTE                                │
│                                                                       │
│   Mots et blocs de texte :                                            │
│    w   ──►    Mot (délimité par les espaces et la ponctuation)        │
│    W   ──►    Mot large (délimité par les espaces uniquement)         │
│    s   ──►    Phrase (jusqu'au prochain . ! ?)                        │
│    p   ──►    Paragraphe (bloc délimité par des lignes vides)         │
│                                                                       │
│   Délimiteurs appariés :                                              │
│    (  ou  )  ──►    Parenthèses        (  )                           │
│    [  ou  ]  ──►    Crochets           [  ]                           │
│    {  ou  }  ──►    Accolades          {  }                           │
│    <  ou  >  ──►    Chevrons           <  >                           │
│                                                                       │
│   Guillemets :                                                        │
│    "   ──►    Guillemets doubles       "  "                           │
│    '   ──►    Guillemets simples       '  '                           │
│    `   ──►    Backticks               `  `                            │
│                                                                       │
│   HTML/XML :                                                          │
│    t   ──►    Tag HTML/XML             <div> ... </div>               │
└───────────────────────────────────────────────────────────────────────┘
```

---

## 3. La différence `i` _vs_ `a` sur les délimiteurs

```txt
  Texte : print("Bonjour le monde")
                ^^^^^^^^^^^^^^^^^
                curseur ici

    di"  ──►  print("")                  (vide le contenu des guillemets)
    da"  ──►  print()                    (supprime aussi les guillemets)

    di(  ──►  print()                    (vide le contenu des parenthèses)
    da(  ──►  print                      (supprime aussi les parenthèses)
```

La règle est simple et constante :

- `i` → contenu **à l'intérieur** des délimiteurs
- `a` → contenu + **les délimiteurs eux-mêmes**

---

## 4. Combinaisons pratiques

```txt
┌──────────────────────────────────────────────────────────────────────┐
│   COMBINAISONS VERBE + OBJET TEXTUEL                                 │
│                                                                      │
│    ciw   ──►    Changer le mot sous le curseur (→ Insert)            │
│    caw   ──►    Changer le mot + l'espace (→ Insert)                 │
│    ci"   ──►    Changer le contenu des guillemets doubles (→ Insert) │
│    ci'   ──►    Changer le contenu des guillemets simples (→ Insert) │
│    ci(   ──►    Changer le contenu des parenthèses (→ Insert)        │
│    ci{   ──►    Changer le contenu des accolades (→ Insert)          │
│                                                                      │
│    da(   ──►    Supprimer les parenthèses et leur contenu            │
│    da"   ──►    Supprimer les guillemets et leur contenu             │
│    da{   ──►    Supprimer les accolades et leur contenu              │
│                                                                      │
│    yiw   ──►    Copier le mot sous le curseur                        │
│    yip   ──►    Copier le paragraphe entier                          │
│    ya(   ──►    Copier les parenthèses et leur contenu               │
│                                                                      │
│    vis   ──►    Sélectionner la phrase (mode Visual)                 │
│    vip   ──►    Sélectionner le paragraphe (mode Visual)             │
│    vi{   ──►    Sélectionner le contenu des accolades (mode Visual)  │
│                                                                      │
│    cit   ──►    Changer le contenu d'un tag HTML (→ Insert)          │
│    dat   ──►    Supprimer le tag HTML et son contenu                 │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 5. Une propriété remarquable

Les objets textuels fonctionnent _quel que soit l'endroit du curseur_ dans l'objet. Il n'est pas nécessaire de positionner le curseur sur le début du mot, le guillemet ouvrant ou la parenthèse.

```txt
  Texte :  résultat = calculer(x, y, z)
                               ^
                               curseur ici, au milieu des arguments

    ci(   ──►    résultat = calculer()   puis mode Insert
                            ──────────►  écrire les nouveaux arguments
```

C'est ce qui rend les objets textuels si efficaces en pratique : on pointe vers quelque chose, on n'a pas besoin de viser précisément.

---

## 6. Résumé

```txt
┌───────────────────────────────────────────────────────────────────┐
│                                                                   │
│     verbe  +  i/a  +  objet                                       │
│                                                                   │
│       c       i       "       ──►   changer l'intérieur des "     │
│       d       a       (       ──►   supprimer ( et son contenu    │
│       y       i       p       ──►   copier le paragraphe          │
│       v       i       {       ──►   sélectionner l'intérieur de {}│
│                                                                   │
│    ───────────────────────────────────────────────────────────    │
│                                                                   │
│    i = inner (sans les délimiteurs)                               │
│    a = around (avec les délimiteurs)                              │
│                                                                   │
│    Objets : w  W  s  p  "  '  `  (  [  {  <  t                    │
│                                                                   │
└───────────────────────────────────────────────────────────────────┘
```

---

## Exercices

> Rappel : rester en **mode Normal** au départ de chaque exercice.
> Appuyer sur `<Esc>` pour y revenir à tout moment.

---

### Exercice 1 — `ciw` : changer un mot entier

Le texte ci-dessous contient des mots à remplacer. Utiliser `ciw` pour les changer, quel que soit l'endroit du curseur dans le mot.

    Le LANGAGE Python est APPRECIE pour sa CLARTE et sa LISIBILITE.

Instructions :

1. Placer le curseur n'importe où sur `LANGAGE`
2. Appuyer sur `ciw` — le mot est effacé, Neovim passe en Insert
3. Taper `langage`, puis `<Esc>`
4. Répéter avec `APPRECIE` → `apprécié`, `CLARTE` → `clarté`, `LISIBILITE` → `lisibilité`

💡 Comparer avec `cw` : `cw` supprime du curseur jusqu'au mot suivant.
`ciw` supprime le mot entier, sans se soucier de la position du curseur.

---

### Exercice 2 — `ci"` : modifier le contenu d'une chaîne

    message = "Insérer le bon texte ici"
    titre   = "Encore du texte à corriger"
    erreur  = "Et celui-ci aussi"

Instructions :

1. Placer le curseur n'importe où sur la première ligne, à l'intérieur
   ou à proximité des guillemets
2. Appuyer sur `ci"` — le contenu est effacé, Neovim passe en Insert
3. Taper `Bonjour, monde !`, puis `<Esc>`
4. Répéter pour les deux autres lignes avec un texte au choix

💡 Le curseur peut être n'importe où sur la ligne — Neovim trouve les guillemets le plus proche automatiquement.

---

### Exercice 3 — `di(` vs `da(` : comprendre _inner_ et _around_

    résultat = calculer(valeur_inutile, autre_valeur)
    afficher(contenu_à_vider)
    traiter(tout, ceci, doit, disparaître, avec, les, parenthèses)

Instructions :

1. Sur la première ligne, placer le curseur dans les parenthèses de `calculer(...)` et appuyer sur `di(` — les arguments sont supprimés,les parenthèses restent
2. Sur la deuxième ligne, placer le curseur dans les parenthèses de `afficher(...)` et appuyer sur `da(` — les parenthèses et leur contenu sont supprimés
3. Observer la différence dans le résultat des deux lignes

Résultat attendu pour chaque ligne :

```
    résultat = calculer()
    afficher
    traiter(tout, ceci, doit, disparaître, avec, les, parenthèses)
```

4. Appliquer `di(` ou `da(` sur la troisième ligne selon le résultat souhaité

---

### Exercice 4 — `yip` + `p` : dupliquer un paragraphe

Le texte ci-dessous contient deux paragraphes. Dupliquer le premier sous le second.

    Neovim est un éditeur puissant et hautement configurable.
    Il est conçu pour une utilisation efficace et une productivité maximale.

    Ce second paragraphe est différent.
    Il aborde un autre sujet entièrement.

Instructions :

1. Placer le curseur n'importe où dans le premier paragraphe
2. Appuyer sur `yip` pour copier le paragraphe entier
3. Placer le curseur sur la dernière ligne du fichier
4. Appuyer sur `p` pour coller le paragraphe

---

### Exercice 5 — `ci{` : modifier le corps d'une fonction

    function traiter(données) {
        ancienne_logique();
        autre_ancienne_logique();
        dernière_ligne_inutile();
    }

Instructions :

1. Placer le curseur n'importe où entre les accolades `{` et `}`
2. Appuyer sur `ci{` — tout le contenu est effacé, Neovim passe en Insert
3. Taper la nouvelle implémentation :

```
        nouvelle_logique();
```

4. Appuyer sur `<Esc>` pour revenir en mode Normal

💡 `ci{` est l'une des combinaisons les plus utilisées lors d'un _refactoring_ : vider le corps d'une fonction pour le réécrire.

---

### Exercice 6 — `cit` : modifier un tag HTML

    <p>Ceci est un texte à remplacer entièrement.</p>
    <h1>Titre à corriger</h1>
    <span>Et ce contenu aussi doit changer.</span>

Instructions :

1. Placer le curseur n'importe où dans le contenu de la balise `<p>`
2. Appuyer sur `cit` — le contenu entre les balises est effacé, Neovim passe en Insert
3. Taper `Un nouveau paragraphe bien rédigé.`, puis `<Esc>`
4. Répéter pour `<h1>` et `<span>`

💡 `cit` reconnaît automatiquement la balise ouvrante et fermante, quel que soit le type de _tag_.

---

## À retenir

- Les objets textuels sont les "noms" du langage Neovim : ils désignent une unité de texte délimitée.
- `i` (inner) = le contenu seul, sans les délimiteurs.
- `a` (around) = le contenu avec les délimiteurs.
- Le curseur n'a pas besoin d'être au début de l'objet — Neovim le trouve seul.
- Les combinaisons les plus utiles au quotidien : `ciw`, `ci"`, `ci(`, `ci{`, `cit`, `yip`, `vip`, `daw`.

---

## Prochaine leçon

Leçon 5 — Édition essentielle : annuler, répéter, les registres, changer la casse

Appuyer sur `]l` pour continuer.
