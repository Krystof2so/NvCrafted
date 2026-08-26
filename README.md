<p align="center">
  🇫🇷 <a href="README.fr.md">Lire le README en français</a>
</p>

---

# NvCrafted

A handcrafted [Neovim](https://neovim.io/) configuration, designed to be understood, extended, and mastered.

## 🪪 Overview

This repository contains a **Neovim** configuration that aims to be modern, readable, and highly modular, built as an evolvable foundation for a development environment close to an IDE.

The main goals of the project are:

- 🧩 **Maximum modularity**: each feature is isolated in a clearly identified file.
- 🧠 **Readability and pedagogy**: the configuration must remain understandable, even after months away.
- 🚀 **Scalability**: adding a plugin or an LSP overlay is done via a single file.
- 🔧 **Declarative approach**: [Lazy.nvim](https://lazy.folke.io/) is used as the central manager.

Once the structure is in place, maintenance essentially boils down to **adding or adjusting modules**, without modifying the core of the configuration.

(This project is still under construction…)

---

## ⚙️ Prerequisites

- **Neovim ≥ 0.12**
- [Lua](https://www.lua.org/) as the configuration language
- **lazy.nvim**: plugin manager
- [mason.nvim](https://github.com/mason-org/mason.nvim) / [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim): LSP installation and management
- [Tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter) for syntax parsing
- [Lazydev.nvim](https://github.com/folke/lazydev.nvim) to enhance the **LSP** experience for **Lua** configuration files.
- [nerdfonts](https://www.nerdfonts.com/): fonts required for icons

---

## 📁 Project Structure

```text
 .
├──  doc       # Neovim built‑in help – partially translated into French
├──  docs      # Technical documentation (🇫🇷)
├──  init.lua  # Main entry point
├──  lazy-lock.json    # Plugin version lock
├──  lua
│   ├──  core  # Pure Neovim/NvCrafted configuration (plugin‑independent – various files and directories)
│   │   ├──  format
│   │   ├──  highlights
│   │   ├──  git
│   │   ├──  lsp
│   │   ├──  map_actions   # NvCrafted‑specific features
│   │   ├──  snacks_config # Dashboard
│   ├──  nvcrafted
│   │   └──  tutor         # Built‑in tutorial (🇫🇷)
│   └──  plugins           # Integrated/classified plugins by functional area
│       ├──  appearance
│       ├──  editing
│       ├──  git
│       ├──  lsp
│       ├──  meta
│       ├──  navigation
│       └──  ux
├──  README.fr.md
├── 󰂺 README.md
├──  snippets
└──  tutor_lessons     # Built‑in tutorial lessons
```

For more details on the architecture, see [Documentation sur l'architecture](./docs/architecture.md)

---

## 🚀 Installation

### 1. Clone the repository

```bash
git clone https://github.com/Krystof2so/NvCrafted.git ~/.config/nvim
```

### 2. Launch Neovim

```bash
nvim
```

Lazy.nvim will automatically install the plugins on the first run.

⚠️ **Note**:

- Ensure Neovim ≥ 0.12 is installed.
- Nerd Fonts are required for an optimal experience.

---

🔧 Key Features

- One plugin = one file: each plugin has its own file in lua/plugins/<domain>/.
- Auto‑import: plugins/init.lua scans subfolders and imports them dynamically.
- Minimalist configuration: only non‑default options are configured.

Example:

```lua
-- plugins/editing/autopairs.lua
return {
  "windwp/nvim-autopairs",
  opts = {
    check_ts = true,
    ts_config = { lua = { "string" } }
  }
}
```

For extension conventions (declaration vs specification, opts vs config), see [Documentation sur l'architecture](./docs/architecture.md).

---

## LSP and Tool Support

NvCrafted structures LSP support in 4 levels:

1. Declaration:
   - `core/lsp/servers.lua` → List of active LSP servers.
   - `core/lsp/tools.lua` → List of Mason tools (formatters, linters).
2. Installation:
   - `plugins/lsp/mason.lua` → Installs servers and tools via Mason.
3. Orchestration:
   - `plugins/lsp/init.lua` → Applies common on_attach and capabilities, loads server‑specific overrides.
4. Server‑specific configuration:
   - `plugins/lsp/config/<server>.lua` → Custom per‑server configuration.

Example: Adding an LSP server

1. Add the server name to core/lsp/servers.lua:

```lua
return { "lua_ls", "pyright", "rust_analyzer" }
```

2. (Optional) Create a configuration file in `plugins/lsp/config/<server>.lua`.

For a complete description of the LSP architecture, see [Documentation LSP](./docs/lSP-NvCrafted.md)

---

## Key Mapping Management

Key mappings are organised into 3 scopes based on their reach:

- `core/keymaps.lua`: Global mappings (e.g. `<leader>hm` to access documentation files).
- Plugin file: Contextual mappings (e.g. mappings inside a floating menu).
- `core/lsp/on_attach.lua`: LSP‑specific mappings (e.g. `gd` to go to definition).

For the full list of commands, see [Vim and Neovim commands](./docs/commandes-et-raccourcis-NvCrafted.md) et [NvCrafted‑specific commands and shortcuts](./docs/commandes-et-raccourcis-NvCrafted.md).

---

## Snippets and Autocompletion

- Snippets: Stored in `~/.config/nvim/snippets/` (VSCode format).
- Dynamic loading: Via `luasnip.loaders.from_vscode` in `plugins/editing/blink.lua`.
- Integration with [blink.cmp](https://cmp.saghen.dev/): Snippets are included as a completion source.

Example configuration:

```lua
-- plugins/editing/blink.lua
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { vim.fn.stdpath("config") .. "/snippets" }
})
```

---

## Custom Dictionary

- Dictionaries: English (en), French (fr), and a custom technical dictionary (`code.utf-8.add`).
- How it works:
  - `code.utf-8.add` is automatically created on first launch.
  - Compiled into `code.utf-8.spl` for immediate use.
  - Targeted spell checking (comments and strings only).
  - Automatically adds validated words with `zg`.

No external dictionary download is required.

---

## Built‑in Tutorial and French Documentation

- Lessons: Available in `tutor_lessons/` (e.g. `01-Les-modes.md`).
- Dedicated module: `lua/nvcrafted/tutor/` for an interactive experience.
- Goal: To help beginners get started with Neovim.

For more information, see the <a href="/nvcrafted/tutor/">nvcrafted/tutor</a> module.

In `/doc` you will find `.frx` files. These are the official Vim/Neovim documentation files, translated (fully or partially) into French. See: [Built‑in Vim/Neovim](./docs/documentation-aide-neovim.md).

---

## Color Customisation

- Available themes: `everviolet`, `nordic`, `rose-pine` (default).
- Dedicated files: In `plugins/appearance/` (e.g. `rose-pine.lua`).
- Overlays: Customisation of colours for specific plugins (e.g. [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim), [which-key](https://github.com/folke/which-key.nvim/tree/main)).

- For theme management, see [Themes with NvCrafted](./docs/themes.md).
- For colour customisations, see [Highlights](./docs/highlights.md).

---

## 📌 Extension Conventions

### 1. Adding a plugin

1. Create a Lua file in the corresponding folder (e.g. `lua/plugins/editing/my_plugin.lua`).
2. Return a table compatible with Lazy.nvim:

```lua
return {
  "author/my_plugin.nvim",
  opts = { ... },  -- Static options
  config = function()  -- Logic to execute
    -- Configuration here
  end
}
```

### 2. When to use opts vs config?

- Logic to execute (API, autocommands, `pcall`) → `config`
- Static options only → `opts`
- Static options + extra code → `opts` + `config`

💡 Prefer opts for simple configurations: it is shorter and more readable.

For concrete examples, see [The architecture documentation](./docs/architecture.md).

---

## 🎨 Project Philosophy

- 📦 One plugin = one file: no black box, everything is explicit.
- 🧠 Readability: comments and documentation are in French (sorry to English speakers!).
- 🧪 No magic: everything is configurable and understandable.
- 🧩 Incremental extension: add features without breaking existing ones.

This configuration is designed as a personal working base, but is structured enough to serve as a reference or starting point.

---

## 🔮 Planned Evolutions

- Gradual addition of plugins (UI, DAP, testing, refactoring, etc.).
- Improvements to LSP integrations (overlays) and snippet additions.
- Any other idea that respects the project’s philosophy.
- Enhancement and enrichment of the built‑in French documentation and onboarding tutorials.

💬 Have a suggestion or idea? Feel free to contribute!

---

## 📜 License

Free to use, modify, and share.

✨ If you are looking for a modular and easily understandable Neovim configuration, NvCrafted is for you.
