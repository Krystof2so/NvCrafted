# Liste de commandes pour **NvCrafted**

## Edition 
- `gcc` : Commenter/Décommenter la ligne

## Recherche/remplacement
- `/occurrence` puis navigation entre les occurrences : `n` en avant et `N` en arrière.
- `<leader>h` : efface la surbrillance activée après une recherche.
- `:s/occurrence/nouvelle occurrence` : remplacer une occurrence (sera remplacée sur toute la ligne) 

## *Spelling*
- `zg` : Ajoute un mot au dictionnaire personnalisé
- `z=` : Suggestions de *spelling*

## *Folding*
- `za` : Ouverture/fermeture du folding sous le curseur
- `zR` : Ouvre tous les foldings

## Au niveau des *buffers*
- ̀`<leader>bd` : Ferme le *buffer* courant
- `<leader>bl` : Liste les *buffer* ouverts
- `<leader>bn` : *buffer* suivant
- `<leader>bp` : *buffer* précédent

## Recherche au niveau des fichiers
- `<leader>ff` : recherche de fichier 
- `<leader>fg` : recherche de texte au niveau du projet

## Mapping de LSP:
- `gd` (ou *Go to Definition*) : sur une variable, nom de fonction, etc., permet de se rendre à l'endroit ou cet élément est défini.
- `gD` (ou *Go to Definition*) : se rendre sur la définition d'un symbole.
- `gr` (ou *Go to Reference*) : affiche tous les endroits où il est fait référence à l'élément (ouverture d'un menu de navigation avec la liste des lignes où se situe la référence.
- `K` : affiche une documentation propre à l'élément (*docstring*, signature, type, commentaire associé).
- ̀̀`<leader>ca` (ou *Code Action*) : affiche un menu contextuel offrant diverses actions réalisables (*quick fixes*, *refactoring*, *imports automatiques*, corrections **LSP**).
- `<leader>cr` (ou *Code Rename*) : Renomme (de façon intelligente) un élément sur l'ensemble du projet.
- `<leader>cw` (ou *Code Warning*) : Affiche le *warning* de la ligne courante

