# Commandes Vim/Neovim classées par catégories

## Bascule entre les modes

| Commande | Description                        |
| -------- | ---------------------------------- |
| `i`      | Passe en mode `insert`             |
| `v`      | Passe en mode `visual`             |
| `V`      | Passe en mode `visual` (par ligne) |

## Naviguer dans le _buffer_

### Déplacements de base

| Commande | Description                                         |
| -------- | --------------------------------------------------- |
| `h`      | Déplacement directionnel vers la gauche             |
| `j`      | Déplacement directionnel vers le bas                |
| `k`      | Déplacement directionnel vers le haut               |
| `l`      | Déplacement directionnel vers la droite             |
| `$`      | Déplacement directionnel jusqu'à la fin de la ligne |

### Navigation par mots

| Commande | Description                                                             |
| -------- | ----------------------------------------------------------------------- |
| `w`      | Déplace le curseur au mot suivant                                       |
| `W`      | Déplace le curseur au mot suivant sans prendre en compte les symboles   |
| `b`      | Déplace le curseur au mot précédent                                     |
| `B`      | Déplace le curseur au mot précédent sans prendre en compte les symboles |
| `e`      | Déplace le curseur à la fin du mot                                      |
| `E`      | Déplace le curseur à la fin du mot sans prendre en compte les symboles  |

### Navigation par caractères

| Commande  | Description                              |
| --------- | ---------------------------------------- |
| `f{char}` | Aller au prochain `{char}` sur la ligne  |
| `F{char}` | Aller au précédent `{char}` sur la ligne |
| `t{char}` | Aller juste avant le prochain `{char}`   |
| `T{char}` | Aller juste avant le précédent `{char}`  |

### Navigation par lignes/paragraphes/blocs de texte

| Commande | Description                                       |
| -------- | ------------------------------------------------- |
| `gg`     | Déplace le curseur à la première ligne du fichier |
| `G`      | Déplace le curseur à la dernière ligne du fichier |
| `{`      | Aller au début du paragraphe précédent            |
| `}`      | Aller au début du paragraphe suivant              |

### Sauts/marques/correspondances

| Commande   | Description                                                   |
| ---------- | ------------------------------------------------------------- |
| `%`        | Sauter à la parenthèse/accolade/crochet correspondant         |
| `;`        | Se rend à la prochaine occurrence d'une recherche             |
| `,`        | Se rend à la précédente occurrence d'une recherche            |
| `<Ctrl> o` | Revenir au mouvement précédent (en référence à un historique) |
| `<Ctrl> i` | Se rendre au movement suivant                                 |

### Navigation dans la fenêtre visible

| Commande  | Description                                        |
| --------- | -------------------------------------------------- |
| `H`       | Aller en haut de l'écran visible (_Hight_)         |
| `M`       | Aller au milieu de l'écran visible (_Middle_)      |
| `L`       | Aller en bas de l'écran visible (_Low_)            |
| `<Ctrl>u` | Faire défiler vers le haut (demi-écran) (_up_)     |
| `<Ctrl>d` | Faire défiler vers le bas (demi-écran) (_down_)    |
| `<Ctrl>b` | Faire défiler une page vers le haut                |
| `<Ctrl>f` | Faire défiler une page vers le bas                 |
| `zz`      | Centrer la ligne courante dans l'écran             |
| `zt`      | Déplacer la ligne courante vers le haut (_top_)    |
| `zb`      | Déplacer la ligne courante vers le bas (_bottown_) |

## Edition

### Passer en mode `insert`

| Commande | Description                              |
| -------- | ---------------------------------------- |
| `I`      | Insérer du texte en début de ligne       |
| `A`      | Insérer du texte en fin de ligne         |
| `a`      | Insérer du texte après le curseur        |
| `o`      | En insérant une ligne au-dessous         |
| `O`      | En insérant une ligne au-dessus          |
| `ea`     | Combo pour insérer du texte après un mot |

### Suppression

| Commande    | Description                                               |
| ----------- | --------------------------------------------------------- |
| `d$` ou `D` | Supprimer du curseur à la fin de la ligne                 |
| `dd`        | Supprime la ligne entière                                 |
| `dwi`       | Supprime le mot entier (en préservant les délimiteurs`*`) |
| `dwa`       | Supprime le mot entier (en supprimant les délimiteurs`*`) |
| `x`         | Supprime le caractère sous le curseur                     |
| `X`         | Supprime le caractère avant le curseur                    |

(`*`) `i` (_inner_) et `a` (_around_) sont des délimiteurs. La commande est alors : `action-objet-délimiteur`.

### Copier/Couper/Coller

| Commande    | Description                                     |
| ----------- | ----------------------------------------------- |
| `yy` ou `Y` | Copie la ligne entière dans le presse-papier    |
| `p`         | Colle le contenu du presse-papier               |
| `y`         | En **mode visuel** : copie la zone sélectionnée |
| `d`         | En **mode visual** : coupe la zone sélectionnée |

### Remplacement/modification

| Commande    | Description                                                                       |
| ----------- | --------------------------------------------------------------------------------- |
| `cc`        | Changer tout la ligne en cours (efface et entre en mode `Insert`)                 |
| `c$` ou `C` | Changer du curseur jusqu'à la fin de la ligne (efface et entre en mode insertion) |
| `xp`        | Échanger deux caractères (ex: `ab` → `ba`)                                        |
| `~`         | Inverser la casse sous le caractère                                               |
| `r {char}`  | Remplace le caractère sous le curseur par `{char}`                                |

### Indentation

| Commande | Description                                     |
| -------- | ----------------------------------------------- |
| `>>`     | Ajoute un retrait à droite (tabulation)         |
| `<<`     | Réduit le retrait à gauche (ôte une tabulation) |

### Annulation/Rétablissement

| Commande  | Description                       |
| --------- | --------------------------------- |
| `u`       | Annuler la modification           |
| `<Ctrl>r` | Rétablir la dernière modification |

### Commentaires

Commentaires adaptés selon le LSP appliqué au _buffer_.

| Commande              | Description                                       |
| --------------------- | ------------------------------------------------- |
| `gcc` (mode `Normal`) | _Toggle_ commentaire (au niveau du curseur)       |
| `gc` (mode `visual`)  | _Toggle_ commentaire (toute la ligne)             |
| `gc` (mode `V-Line`)  | _Toggle_ commentaire (après sélection des lignes) |

## Recherche et remplacement

## Gestion des _buffers_, fenêtres et onglets

## Fichiers et sauvegarde

## Registres et macros

## Commandes `Ex` (Mode commande)

## Configuration et personnalisation

## Outils avancés

## Outils externes et intégration

## Divers
