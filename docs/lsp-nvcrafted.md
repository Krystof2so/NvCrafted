# Gestion des serveurs LSP dans NvCrafted

## Introduction

**NvCrafted** intègre le _Language Server Protocol_ (**LSP**) comme un socle fondamental de son architecture. L’objectif n’est pas seulement de « faire fonctionner des serveurs **LSP** », mais de proposer :

- une orchestration claire et lisible
- une séparation stricte des responsabilités
- une extensibilité sans dette technique
- une compréhension pédagogique du fonctionnement du **LSP**

Cette documentation explique comment les serveurs **LSP** sont gérés, où les configurer et comment étendre le système sans casser la modularité.

---

## Philosophie générale

Le support **LSP** dans **NvCrafted** repose sur trois principes clés :

### 1. Un serveur **LSP** doit fonctionner sans configuration spécifique

Un serveur **LSP** correctement installé doit être utilisable immédiatement. Toute configuration avancée est considérée comme une surcouche optionnelle.

### 2. Une responsabilité = un fichier

- orchestration globale → un point d’entrée unique
- logique partagée → modules `core/lsp`
- configuration spécifique → un fichier par serveur

### 3. Aucune magie implicite

Chaque étape du pipeline **LSP** est explicite, traçable et lisible.

---

## Vue d’ensemble de l’architecture

```text
lua/
├── core/
│   └── lsp/
│       ├── on_attach.lua      # Mappings et comportements buffer-local
│       ├── capabilities.lua   # Capacités du client LSP NvCrafted
│       └── servers.lua        # Liste des serveurs LSP activés
└── plugins/
    └── lsp/
        ├── init.lua           # Orchestration globale LSP
        ├── config/
        │   ├── pyright.lua    # Configuration spécifique serveur
        │   └── lua_ls.lua
        └── tools.lua          # Liste des outils non-LSP installés par Mason
```

---

## Le point d’entrée : `plugins/lsp/init.lua`

Ce fichier est le chef d’orchestre **LSP**.

### Responsabilités

- parcourir la liste des serveurs déclarés
- injecter :
  - `on_attach`
  - `capabilities`
- charger dynamiquement une configuration spécifique si elle existe
- initialiser chaque serveur via `nvim-lspconfig`

### Ce fichier ne fait PAS

- aucune configuration spécifique serveur
- aucune logique métier **LSP**
- aucune définition de _mappings_

Il se contente d’assembler les briques.

---

## La liste des serveurs : `core/lsp/servers.lua`

Ce fichier contient la source de vérité des serveurs **LSP** activés.

```lua
return {
  "pyright",
  "lua_ls",
}
```

### Pourquoi ce fichier est central

- un serveur ajouté ici est automatiquement :
  - installé (via Mason)
  - initialisé
  - configuré si une surcouche existe
- supprimer un serveur = supprimer une ligne

---

## Flux d'installation et d'activation

### Les deux sources de vérité

| Fichier                | Contenu                               | Consommé par                  |
| ---------------------- | ------------------------------------- | ----------------------------- |
| `core/lsp/servers.lua` | Serveurs LSP                          | `mason-lspconfig`, `init.lua` |
| `core/lsp/tools.lua`   | Outils non-LSP (formateurs, linters…) | `mason-tool-installer`        |

Ces deux fichiers sont les seuls endroits où déclarer ce qui doit être installé. Aucune autre partie de la configuration n'effectue d'installation implicite.

### Schéma du flux complet

```text
core/lsp/servers.lua ──→ mason-lspconfig.nvim ──┐
                                                 ├──→ mason.nvim (installe)
core/lsp/tools.lua ────→ mason-tool-installer ──┘

core/lsp/servers.lua ──→ plugins/lsp/init.lua
                              │
                              ├── on_attach        (core/lsp/on_attach.lua)
                              ├── capabilities     (core/lsp/capabilities.lua)
                              └── surcouche opt.   (plugins/lsp/config/<serveur>.lua)
                                        │
                                  vim.lsp.config()
```

### Ce que cette séparation garantit

- `servers.lua` et `tools.lua` ne contiennent aucune logique
- `mason.lua` ne prend aucune décision fonctionnelle
- `init.lua` n'installe rien, il orchestre uniquement

Chaque fichier a une responsabilité unique et non partagée.

### Ajouter un outil (formateur, linter)

1. Ajouter son nom **Mason** dans `core/lsp/tools.lua`
2. Relancer **Neovim** — **Mason** l'installe automatiquement
3. Le référencer dans `core/format/conform.lua` s'il s'agit d'un formateur

### Ajouter un serveur LSP

1. Ajouter son nom dans `core/lsp/servers.lua`
2. Créer `plugins/lsp/config/<serveur>.lua` si une configuration spécifique est nécessaire
3. Relancer **Neovim**

---

## Le rôle de `on_attach`

### Définition

`on_attach` est une fonction appelée lorsqu’un serveur **LSP** s’attache à un _buffer_. Elle permet de :

- définir des _mappings buffer-local_
- activer uniquement les fonctionnalités réellement disponibles
- garantir qu’aucun raccourci **LSP** ne pollue les _buffers_ sans **LSP**

### Emplacement

```text
lua/core/lsp/on_attach.lua
```

### Contenu typique

- navigation (`gd`, `gr`, `gi`, …)
- actions (`rename`, `code_action`)
- diagnostics
- documentation (`hover`, `signature_help`)

`on_attach` est le point de jonction entre **Neovim** et le **LSP**.

---

## Les capabilities : `core/lsp/capabilities.lua`

### Qu’est-ce qu’une capability ?

Les _capabilities_ décrivent ce que le client **LSP** (**Neovim**) sait faire. Elles sont envoyées au serveur lors de l’initialisation pour établir un contrat de fonctionnalités.

### Exemples de capacités

- support des snippets
- format de la documentation
- gestion avancée de la complétion

### Pourquoi un fichier dédié

- définir une identité claire du **client LSP NvCrafted**
- éviter la duplication entre serveurs
- permettre des extensions progressives

---

## Configurations spécifiques serveur

### Emplacement

```text
lua/plugins/lsp/config/<server>.lua
```

### Principe

- si le fichier existe → il est chargé
- sinon → le serveur fonctionne avec les options par défaut

### Exemple

```lua
return {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "strict",
      },
    },
  },
}
```

### Avantages

- aucune logique conditionnelle
- ajout d’un serveur = 1 fichier (optionnel)
- lisibilité maximale

---

## _Pipeline_ **LSP** résumé

Pour l'installation (étapes 1 et 2), voir _Flux d'installation et d'activation_ ci-dessus.

3. construction des options :
   - `on_attach`
   - `capabilities`
4. fusion avec une surcouche éventuelle
5. initialisation via `vim.lsp.config()`

---

## Extensibilité future

Cette architecture permet :

- l’extension des capabilities
- la gestion fine des diagnostics
- l’activation conditionnelle de fonctionnalités avancées

---

## Conclusion

Le support **LSP** de **NvCrafted** n’est pas une simple intégration technique. C’est un socle structurant, pensé pour être :

- compréhensible
- modulaire
- évolutif
- et documenté

Chaque serveur _LSP_ devient une brique interchangeable, jamais une dépendance rigide.
