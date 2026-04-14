<p align="center">
  🇫🇷 <a href="README.fr.md">Lire le README en français</a>
</p>

---

# NvCrafted

A handcrafted [Neovim](https://neovim.io/) configuration, designed to be understood, extended, and mastered.

---

## Overview

This repository contains a **Neovim** configuration that is modern, readable, and highly modular, intended as an evolving foundation for building a development environment close to an IDE.

The main goals of this project are:

- 🧩 **Maximum modularity**: Each feature is isolated in a clearly identified file.
- 🧠 **Readability and pedagogy**: The configuration remains understandable, even after months of inactivity.
- 🚀 **Scalability**: Adding a plugin or an LSP layer is done via a simple file.
- 🔧 **Declarative approach**: [Lazy.nvim](https://lazy.folke.io/) is used as the central manager.

Once the structure is in place, maintenance essentially involves **adding or adjusting modules**, without modifying the core configuration.

This project is still under construction...

---

## Required Tooling

- **Neovim ≥ 0.11**
- [Lua](https://www.lua.org/) as the configuration language
- **lazy.nvim**: plugin manager
- [mason.nvim](https://github.com/mason-org/mason.nvim) / [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim): installation and management of LSPs
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) (via the `vim.lsp` API)
- [Tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter) for syntax analysis
- [Lazydev](https://github.com/folke/lazydev.nvim) to improve the **Lua** **LSP** experience with configuration files.
- [nerdfonts](https://www.nerdfonts.com/)

---

## Project Structure

```text
.
├── docs
│   ├── autocommands.md
│   ├── commands.md
│   └── lsp-nvcrafted.md
├── init.lua
├── lazy-lock.json
├── lua
│   ├── core
│   │   ├── autocmds.lua
│   │   ├── bootstrap.lua
│   │   ├── format
│   │   │   └── conform.lua
│   │   ├── highlights
│   │   │   └── diagnostics_theme_nord.lua
│   │   ├── keymaps.lua
│   │   ├── lsp
│   │   │   ├── capabilities.lua
│   │   │   ├── on_attach.lua
│   │   │   ├── servers.lua
│   │   │   └── tools.lua
│   │   ├── options.lua
│   │   └── spell.lua
│   └── plugins
│       ├── coding
│       │   ├── autopairs.lua
│       │   ├── blink.lua
│       │   ├── conform.lua
│       │   ├── lazydev.lua
│       │   ├── telescope.lua
│       │   └── treesitter.lua
│       ├── init.lua
│       ├── lsp
│       │   ├── config
│       │   │   ├── lua_ls.lua
│       │   │   ├── pyright.lua
│       │   │   └── ruff.lua
│       │   ├── init.lua
│       │   └── mason.lua
│       ├── tools
│       │   └── which_key.lua
│       └── ui
│           ├── aerial.lua
│           ├── alpha.lua
│           ├── colorscheme.lua
│           ├── lualine.lua
│           ├── neo_tree.lua
│           └── trouble.lua
├── README.fr.md
├── README.md
└── snippets
    └── python.json
```

---

## The `docs/` directory

**NvCrafted** includes technical documentation complementing the `README`,
organized by topic in the `docs/` folder.

| File               | Content                                                                                                                                |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| `autocommands.md`  | Description of the autocommand groups defined in `core/autocmds.lua`                                                                   |
| `commands.md`      | List of commands available in **NvCrafted**                                                                                            |
| `lsp-nvcrafted.md` | Complete **LSP** support architecture: installation flow, orchestration, role of `on_attach` and `capabilities`, extension conventions |

---

## `init.lua` (root)

The main entry point (purely declarative):

- Bootstraps **lazy.nvim** via `core.bootstrap` (isolation of **lazy.nvim** installation logic)
- Defines leaders
- Loads `core` modules
- Initializes **Lazy** with automatic plugin imports

### Startup flow

```text
init.lua (root)
  │
  ├── core.bootstrap
  │     └── installs lazy.nvim if missing
  │
  ├── system configuration
  │     ├── disable unused providers (Perl, Ruby)
  │     ├── dedicated Neovim Python (~/.venvs/neovim)
  │     └── append Mason to PATH
  │
  ├── leader keys (Space / Backslash)
  │
  ├── core/ modules (plugin-independent)
  │     ├── core.spell
  │     ├── core.options
  │     ├── core.keymaps
  │     └── core.autocmds
  │
  └── lazy.setup("plugins")
        └── plugins/init.lua
              └── automatic subdirectory scan
                    ├── plugins/coding/
                    ├── plugins/ui/
                    ├── plugins/tools/
                    └── plugins/lsp/
                          └── init.lua
                                ├── servers.lua → LSP activation
                                └── tools.lua   → Mason tools
```

The order is intentional: `core/` modules are loaded before **Lazy**, ensuring that options and leader keys are in place before any plugin is initialized.

---

## The `core/` Directory

Contains the **fundamental Neovim configuration**, independent of plugins.

| File              | Role                            |
| ----------------- | ------------------------------- |
| `options.lua`     | Neovim options (`vim.opt`)      |
| `keymaps.lua`     | Global keybindings              |
| `autocmds.lua`    | Autocommands                    |
| `spell.lua`       | Custom dictionary               |
| `bootstrap.lua`   | **lazy.nvim** startup           |
| `lsp/servers.lua` | Source of truth for LSP servers |

👉 These files do not depend on any plugin and can be read as "pure Neovim configuration."

---

## Extension Conventions

### Adding a _Plugin_

1. Create a **Lua** file in the corresponding folder, for example:
   - `lua/plugins/ui/` for an interface plugin
   - `lua/plugins/coding/` for a code editing plugin
   - `lua/plugins/tools/` for cross-cutting tools

2. The file must return a table compatible with **Lazy.nvim**. Minimal example:

```lua
return {
  "author/pluginname.nvim",
  config = function()
    -- plugin-specific configuration here
  end
}
```

### Convention: specification vs declaration

Some plugins involve configuration logic rich enough to justify a dedicated file in `core/`. **NvCrafted** then applies a two-level separation:

| Level         | File                            | Role                                                 |
| ------------- | ------------------------------- | ---------------------------------------------------- |
| Declaration   | `plugins/<domain>/<plugin>.lua` | Declares the plugin to Lazy, delegates configuration |
| Specification | `core/<domain>/<plugin>.lua`    | Holds the actual logic, independent from Lazy        |

#### Example: `conform.nvim`

`plugins/coding/conform.lua` only declares the plugin and calls the `core` module:

```lua
return {
  "stevearc/conform.nvim",
  opts = function()
    require("core.format.conform").setup()
  end,
}
```

All the actual logic — formatters per file type, dynamic Python selection, format-on-save — lives in `core/format/conform.lua`.

#### When to apply this convention?

- the plugin configuration contains **business logic** (conditions, functions, autocommands)
- it is likely to be **reused** by other modules
- it should remain **readable and testable** independently from Lazy's lifecycle

A plugin whose configuration fits in a few lines of static options does not need this split : `opts = { ... }` directly in the plugin file is enough.

### Adding an **LSP Server**

Adding an LSP server follows a declarative two-level approach.

1. Server Declaration
   Add the server name in `lua/core/lsp/servers.lua`
   Example:

   ```lua
   return {
     "lua_ls",
     "pyright",
     "rust_analyzer",
   }
   ```

   👉 This file is the source of truth:
   - Used by **Mason** for installation
   - Used by the **LSP** orchestrator for activation

2. Specific Configuration
   Create a file named after the server: `lua/plugins/lsp/config/<server_name>.lua`.
   File structure:
   ```lua
   return {
     settings = {
       -- specific LSP configuration
     }
   }
   ```

Key Principle:
An LSP server works without specific configuration.
A layer is only loaded if a dedicated file exists.

---

## Plugin Management with Lazy.nvim

### `lua/plugins/init.lua`

This file is the **aggregation point for plugins**. It contains no direct configuration, only logical imports:

- Scans the `lua/plugins/` directory to retrieve all subdirectories.
- Transforms each subdirectory into an entry `{ import = "plugins.<name>" }`.
- Returns a table directly usable by `require("lazy").setup()`.
  Each subfolder represents a **functional domain**.

👉 Key Principles:

- No _plugin_ is manually declared in init.lua.
- Each _plugin_ has its own file.
- The philosophy is to only configure what differs from default values, to keep files short and explicit. For example: `autopairs.lua` only redefines **Tree-sitter** integration.

---

## Organization by Domains

### `plugins/ui/`

Plugins related to the user interface:

- status bar ([lualine](https://github.com/nvim-lualine/lualine.nvim))
- file explorer ([neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim))
- welcome screen ([alpha](https://github.com/goolord/alpha-nvim))
- color theme ([Nord](https://www.nordtheme.com/)) - Yes, I'm a die-hard fan of this theme.
- Diagnostics visualization ([Trouble](https://github.com/folke/trouble.nvim/tree/main))
- Viewing the structure of the current file (and navigating) ([aerial](https://github.com/stevearc/aerial.nvim))

---

### `plugins/coding/`

Plugins enhancing the code editing experience:

- [auto-pairs](https://github.com/windwp/nvim-autopairs)
- **Tree-sitter**
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- formatting ([conform](https://github.com/stevearc/conform.nvim))
- [Lazydev](https://github.com/folke/lazydev.nvim)
- [Trouble](https://github.com/folke/trouble.nvim)

---

### `plugins/tools/`

Cross-cutting tools (e.g., [which-key](https://github.com/folke/which-key.nvim)) that do not directly fit into UI or coding.

---

## LSP and Tools Management

The **LSP** support and tool installation are structured across four distinct levels.

### 1. Declaration — `core/lsp/servers.lua`

- Explicit list of active LSP servers
- No logic, no plugin dependency

### 2. Declaration — `core/lsp/tools.lua`

- Explicit list of non-**LSP** **Mason** tools: formatters (`black`, `stylua`, `prettier`), _linters_ (`ruff`), and other binaries.
- Same philosophy as `servers.lua`: a pure list, no logic.

These two files are the _sources of truth_ for the environment. Everything that needs to be installed is declared here, and nowhere else.

### 3. Installation — `plugins/lsp/mason.lua`

Consumes both lists:

- `mason-lspconfig` installs the servers from `servers.lua`
- `mason-tool-installer` installs the tools from `tools.lua`
- `mason.nvim` executes the installations

No functional decisions are made here.

### 4. Orchestration — `plugins/lsp/init.lua`

For each server in `servers.lua`:

- applies shared `on_attach` and `capabilities`
- loads the optional overlay `lsp/config/<server>.lua` if it exists
- registers the server via `vim.lsp.config()`

A server works without an overlay.
An overlay is only loaded if the corresponding file exists.

---

## Snippet Management

### Structure

Snippets are stored in `~/.config/nvim/snippets/` in JSON format (compatible with VSCode).

### Configuration

Snippets are dynamically loaded using `lazy_load`:

````lua
-- plugins/coding/blink.lua
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { vim.fn.stdpath("config") .. "/snippets" },
})

**blink.cmp** is configured to include **luasnip** as a completion source:
```lua
sources = { -- Priority completion sources
    default = { "lsp", "buffer", "snippets", "path" },
},
````

---

## Custom Dictionary Management

**NvCrafted** integrates a spell-checking system adapted for code and comments.

- Dictionaries used: English (en), French (fr), and a custom code dictionary.
- Automatic creation: On first launch, the `code.utf-8.add` file is created with frequent technical words and compiled into `code.utf-8.spl`.
- Targeted spell-check: Active only in comments and strings.
- Automatic addition: Words validated with `zg` are added to `code.utf-8.add` and recompiled into `.spl`.
- Compatibility: Works from the first launch, with **Neo-tree** and all _buffers_, without downloading external dictionaries.

---

## Installation

### Prerequisites

- **Neovim ≥ 0.11**
- [Git](https://git-scm.com/)

### Steps

```bash
# Clone the repository
git clone https://github.com/Krystof2so/NvCrafted.git ~/.config/nvim

# Launch Neovim
nvim
```

**Lazy.nvim** will automatically install the plugins on the first launch.

---

## Project Philosophy

- 📦 **One plugin = one file**
- 🧠 **Readability**
- 🧪 **No black boxes**
- 🧩 **Incremental extension**

This configuration is designed as a **personal workbase**, but structured enough to serve as a reference or starting point.

My goal is to maintain an organization and configuration that is as simple and modular as possible. One specificity = one file... nothing more basic.

The comments inserted in each file are entirely in French (sorry to English speakers), because I find that **Neovim** is generally poorly documented in French (or even esoteric configurations).

---

## Planned Evolutions

- Gradual addition of plugins (UI, DAP, tests, refactoring...)
- Improvement of LSP integrations (layers)
- And anything else that comes to mind, while staying true to the project philosophy

---

## License

Free to use, modify, and share.

---

✨ _If you are looking for a modular and easily understandable Neovim configuration, this repository is for you._
