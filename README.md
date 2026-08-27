# nvim-dotfile

a readme by my agent.
A highly modular, robust, and intelligent Lua-based configuration. Designed for high performance, stability, and a seamless developer experience.

## ◈ Architecture Overview

This configuration follows a **decoupled, plugin-centric architecture**. Instead of a monolithic configuration file, the system is broken down into specialized layers to ensure that a failure in one component does not compromise the entire editor.

### └ Directory Structure

```text
.
├── init.lua               # The Orchestrator (Bootstrapping & Plugin Management)
├── lua/
│   ├── common.lua         # Foundational Editor Settings (Indentation, Undo, etc.)
│   ├── keymaps.lua        # The Workflow Engine (Smart Mappings & Logic)
│   ├── theme.lua          # Visual Identity (Theme Sync & Live Reloading)
│   └── plugins/           # The Plugin Ecosystem (Modularized per plugin)
├── colors/                # Custom color schemes
└── plugged/               # Installed plugins (managed by vim-plug)
```

---

## ⚙ Core Layers

### 1. The Orchestrator (`init.lua`)
Acts as the system bootstrapper. It manages dependencies via `vim-plug` and implements a **Safe-Loading Pattern**.
* ** Defensive Loading**: Uses a custom `load()` wrapper that utilizes `pcall` to catch errors during module initialization.
* ** Error Reporting**: Integrates with `Snacks.nvim` for rich, non-blocking error notifications if a module fails to load.
* ** Lifecycle Management**: Handles critical startup tasks like `Treesitter` initialization and LSP event attachment.

### 2. Foundational Logic (`lua/`)
* **`common.lua`**: Defines the "soul" of the editor—tab settings, undo history, clipboard integration, and global UI behavior.
* **`theme.lua`**: A sophisticated theme management system. It supports multiple themes (Work vs. Casual) and features **Live Theme Synchronization** via OS signals (`SIGUSR1`), allowing your editor to adapt to system changes instantly.
* **`keymaps.lua`**: The intelligence layer. It moves beyond simple shortcuts to implement **Smart Logic**, such as context-aware window navigation and diagnostic-aware hovering.

### 3. The Plugin Ecosystem (`lua/plugins/`)
Every plugin has its own dedicated module. This "one-file-per-plugin" approach ensures:
* ** Granular Control**: Easily configure or remove specific plugins without affecting others.
* ** Zero Side-Effects**: Changing the configuration for `telescope` won't accidentally break your `lspconfig`.

---

## ✦ Key "Smart" Features

* ** Smart Navigation**: Direction-aware window movement that understands the geometric layout of your splits.
* ** Smart Hover**: A unified `K` mapping that intelligently decides whether to show LSP documentation or floating error diagnostics based on the cursor position.
* ** Live UI Reloading**: Instant visual updates when switching themes, including automatic colorizer and syntax highlighting refreshes.
* ** Safety Guardrails**: Built-in protection against massive files (automatic syntax disabling) to preserve editor performance.
* **󱐋 Workflow Automation**: Integrated Git management (Fugitive/Gitsigns) and specialized support for Obsidian/Markdown workflows.

## 󱌣 Requirements

* **Neovim** (Nightly or latest stable recommended)
* **vim-plug** (Plugin Manager)
* **A Nerd Font** (Required for icons and UI elements)

---

### ❯ Installation

1. Clone this repository to your `~/.config/nvim` directory.
2. Run `:PlugInstall` inside Neovim.
3. Sit back and relax I guess.
