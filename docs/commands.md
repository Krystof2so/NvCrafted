# Liste de commandes pour **NvCrafted**

## Edition

- `gcc` : Commenter/Décommenter la ligne

## Recherche/remplacement

- `/occurrence` puis navigation entre les occurrences : `n` en avant et `N` en arrière.
- `<leader>h` : efface la surbrillance activée après une recherche.
- `:s/occurrence/nouvelle occurrence` : remplacer une occurrence (sera remplacée sur toute la ligne)

## _Spelling_

- `zg` : Ajoute un mot au dictionnaire personnalisé
- `z=` : Suggestions de _spelling_

## _Folding_

- `za` : Ouverture/fermeture du folding sous le curseur
- `zR` : Ouvre tous les foldings

## Au niveau des _buffers_

### Navigation entre buffers

- `<leader>b1` à `<leader>b9` : Accéder directement au _buffer_ N°1 à 9
- `<leader>b0` : Se rendre au dernier _buffer_
- `<leader>bn` : _Buffer_ suivant
- `<leader>bp` : _Buffer_ précédent

### Fermeture de buffers

- `<leader>bcc` : Ferme le _buffer_ courant
- `<leader>bca` : Ferme tous les _buffers_ sauf le courant
- `<leader>bcp` : Ferme tous les _buffers_ sauf le courant ou les épinglés
- `<leader>bcP` : Ferme tous les _buffers_ sauf les épinglés
- `<leader>bcl` : Ferme les _buffers_ à gauche du buffer actuel
- `<leader>bcr` : Ferme les _buffers_ à droite du buffer actuel

### Épinglage et tri

- `<leader>bP` : Épingler/désépingler un _buffer_
- `<leader>bo` : Trier les _buffers_ par nom

### Liste des buffers

- `<leader>bl` : Liste des _buffers_ ouverts (via Telescope)

## Recherche au niveau des fichiers

- `<leader>ff` : recherche de fichier
- `<leader>fg` : recherche de texte au niveau du projet
- `<leader>ao` : ouvre une fenêtre `aerial` (navigation dans la structure du fichier courant)

## Mapping de LSP:

- `gd` (ou _Go to Definition_) : sur une variable, nom de fonction, etc., permet de se rendre à l'endroit ou cet élément est défini.
- `gD` (ou _Go to Definition_) : se rendre sur la définition d'un symbole.
- `gr` (ou _Go to Reference_) : affiche tous les endroits où il est fait référence à l'élément (ouverture d'un menu de navigation avec la liste des lignes où se situe la référence.
- `K` : affiche une documentation propre à l'élément (_docstring_, signature, type, commentaire associé).
- ̀̀`<leader>ca` (ou _Code Action_) : affiche un menu contextuel offrant diverses actions réalisables (_quick fixes_, _refactoring_, _imports automatiques_, corrections **LSP**).
- `<leader>cr` (ou _Code Rename_) : Renomme (de façon intelligente) un élément sur l'ensemble du projet.
- `<leader>cw` (ou _Code Warning_) : Affiche le _warning_ de la ligne courante

## Diagnostics

- `<leader>ds` : Ouverture de Trouble avec split.
- `<leader>dd` : Ouverture de Trouble sans split.

## NeoTree

- `?` : Aide pour les commandes
- `<leader>ee` : Ouvre **Neotree**
- `<leader>eb` : Liste des buffers ouverts (dans une fenêtre flottante)
- `<leader>eg` : Liste des buffers modifiés (git status - dans une fenêtre flottante)
- `<` et `>` : Navigation entre sources (`filesystem`, `buffers`, `git_status`)
- `.` : Passe le répertoire sélectionné comme répertoire racine
- `C` : Ferme le noeud
- `z` : ferme tous les noeuds
- `S` : Ouvre le fichier sélectionné dans un buffer avec split horizontal
- `s` : Idem, mais dans un split vertical
- `[g` et `]g` : Navigation entre les fichiers modifiés (git status)
- `R` : Rafraîchit la vue
- `o` : Pour modifier l'ordre d'affichage (menu flottant)
- `/` : Rechercher un fichier
- `D` : Recherche un répertoire

## Actions sur les fichiers

- `a` : Ajout d'un fichier
- `A` : Ajout d'une répertoire
- `d` : Suppression du répertoire ou du fichier
- `i` : Affiche des informations sur un fichier ou répertoire
- `r` : Renomme le fichier ou le répertoire
- `b` : Renomme le fichier sans l'extension
- `P` : Prévisualisation d'un fichier
