# NvCrafted

A handcrafted [Neovim](https://neovim.io/) configuration, designed to be understood, extended, and truly mastered.

## Overview

This repository contains a **modern, readable, and highly modular Neovim configuration**, designed as an evolving foundation for building an IDE-like development environment.

The main goals of this project are:

- 🧩 **Maximum modularity**: each feature is isolated in a clearly identified file.
- 🧠 **Readability & pedagogy**: the configuration should remain understandable, even when revisited months later.
- 🚀 **Scalability**: adding a plugin or an LSP override is done through a single file.
- 🔧 **Declarative approach**: [Lazy.nvim](https://lazy.folke.io/) is used as the central plugin manager.

Once the structure is in place, maintenance mostly consists of **adding or adjusting modules**, without touching the core of the configuration.

This project is still a work in progress…

---

## Required tooling

- **Neovim ≥ 0.11**
- [Lua](https://www.lua.org/) as the configuration language
- **lazy.nvim**: plugin manager
- [mason.nvim](https://github.com/mason-org/mason.nvim) / [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim): LSP installation and management
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) (via the `vim.lsp` API)
- [Tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter) for syntax analysis

---

## Project structure

```text
.
├── init.lua
├── lazy-lock.json
└── lua
    ├── core
    │   ├── autocmds.lua
    │   ├── keymaps.lua
    │   └── options.lua
    └── plugins
        ├── init.lua
        ├── coding
        ├── lsp
        │   ├── init.lua
        │   ├── mason.lua
        │   └── config
        ├── tools
        └── ui
```

### 1. `init.lua` (root)

Main entry point:

- bootstraps **lazy.nvim**
- defines leader keys
- loads `core` modules
- initializes **Lazy** with automatic plugin imports

---

## The `core/` directory

Contains the **fundamental Neovim configuration**, independent of any plugin.

| File | Role |
|------|------|
| `options.lua` | Neovim options (`vim.opt`) |
| `keymaps.lua` | Global key mappings |
| `autocmds.lua` | Autocommands |

👉 These files do not depend on any plugin and can be read as a “pure Neovim configuration”.

---

## Plugin management with Lazy.nvim

### `lua/plugins/init.lua`

This file acts as the **plugin aggregation point**. It contains no direct configuration and only handles logical imports:

- Scans the `lua/plugins/` directory and collects all subdirectories.
- Turns each subdirectory into an entry `{ import = "plugins.<name>" }`.
- Returns a table directly usable by `require("lazy").setup()`.

Each subdirectory represents a **functional domain**.

---

## Domain-based organization

### `plugins/ui/`

User interface–related plugins:

- status line ([lualine](https://github.com/nvim-lualine/lualine.nvim))
- file explorer ([neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim))
- dashboard ([alpha](https://github.com/goolord/alpha-nvim))
- colorscheme ([Nord](https://www.nordtheme.com/)) — yes, I’m unapologetically a fan of this theme.

Each plugin has its own dedicated file.

---

### `plugins/coding/`

Plugins improving the coding experience:

- [auto-pairs](https://github.com/windwp/nvim-autopairs)
- **Tree-sitter**
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- formatting ([conform](https://github.com/stevearc/conform.nvim))

👉 The guiding principle is to **configure only what differs from the default values**, keeping files short and explicit.

Example: `autopairs.lua` only customizes **Tree-sitter** integration.

---

### `plugins/tools/`

Cross-cutting tools (e.g. [which-key](https://github.com/folke/which-key.nvim)) that do not strictly belong to UI or coding categories.

---

## LSP management

LSP support is deliberately **split into two levels**:

### 1️⃣ Global level — `plugins/lsp/init.lua`

Responsibilities:

- install servers via **Mason**
- list active servers
- dynamically load a server-specific configuration if it exists

Key principle:

> **An LSP server works out of the box without any specific configuration.**
> An override is only loaded if a dedicated file exists.

---

### 2️⃣ Server-specific level — `plugins/lsp/config/`

Each file corresponds to **one specific LSP server**.

Example: `pyright.lua`

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

Benefits:

- no duplicated logic
- local and explicit configuration
- adding an LSP = one file

---

## Installation

### Requirements

- **Neovim ≥ 0.11**
- [Git](https://git-scm.com/)

### Steps

```bash
# Clone the repository
git clone https://github.com/Krystof2so/NvCrafted.git ~/.config/nvim

# Launch Neovim
nvim
```

**Lazy.nvim** will automatically install the plugins on first launch.

---

## Project philosophy

- 📦 **One plugin = one file**
- 🧠 **Readability first**
- 🧪 **No black boxes**
- 🧩 **Incremental extension**

This configuration is intended as a **personal working base**, but is structured enough to serve as a reference or a starting point for others.

My goal is to keep an organization and configuration that are as simple to use and as modular as possible. One feature = one file — nothing more basic than that.

Comments inside the configuration files are written entirely in French (sorry, English speakers). This choice is deliberate: **Neovim is still poorly documented in French**, and many existing configurations tend to feel opaque or esoteric.

---

## Planned evolutions

- Progressive addition of plugins (UI, DAP, testing, refactoring…)
- Improved LSP integrations (overrides)
- And whatever ideas come next, as long as they remain faithful to the project philosophy

---

## License

Free to use, modify, and share.

---

✨ *If you are looking for a modular and easy-to-understand Neovim configuration, this repository is for you.*

