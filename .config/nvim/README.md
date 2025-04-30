# LSP Configuration

## Overview

This Neovim configuration implements a unified Language Server Protocol (LSP) setup with consistent keybindings across all programming languages. The system provides intelligent code completion, diagnostics, navigation, and refactoring capabilities while maintaining a consistent user experience regardless of the language being edited.

## Architecture

The LSP configuration is modular and follows a "shared core, language-specific extensions" pattern:

```
lua/plugins/lsp/
├── common.lua     # Shared functionality and keybindings
├── init.lua       # Main initialization
├── go.lua         # Go-specific settings
├── javascript.lua # JavaScript/TypeScript settings
├── php.lua        # PHP-specific settings
├── python.lua     # Python-specific settings
├── svelte.lua     # Svelte-specific settings
└── yaml.lua       # YAML-specific settings
```

- `common.lua`: Central module that provides shared capabilities, consistent keybindings, and diagnostic settings
- `init.lua`: Loads all language modules and sets up global LSP commands
- Language modules: Configure language-specific LSP servers while inheriting common functionality

## Prerequisites

For the LSP configuration to work properly, you need to install the appropriate language servers:

- **Python**: `npm install -g pyright`
- **PHP**: `npm install -g intelephense`
- **JavaScript/TypeScript**: `npm install -g typescript typescript-language-server`
- **Go**: `go install golang.org/x/tools/gopls@latest`
- **Svelte**: `npm install -g svelte-language-server`
- **YAML**: `npm install -g yaml-language-server`

## Unified Keybindings

All language servers share these consistent keybindings:

### Documentation
| Keybinding | Mode          | Description            |
|------------|---------------|------------------------|
| `K`        | Normal        | Hover documentation    |
| `<C-k>`    | Insert        | Signature help         |

### Navigation
| Keybinding | Mode          | Description            |
|------------|---------------|------------------------|
| `gd`       | Normal        | Go to definition       |
| `gr`       | Normal        | Find references        |
| `gi`       | Normal        | Go to implementation   |
| `gt`       | Normal        | Go to type definition  |

### Editing & Refactoring
| Keybinding    | Mode          | Description            |
|---------------|---------------|------------------------|
| `<leader>rn`  | Normal        | Rename symbol          |
| `<leader>ca`  | Normal        | Code actions           |
| `<leader>f`   | Normal        | Format document        |

### Diagnostics
| Keybinding    | Mode          | Description               |
|---------------|---------------|---------------------------|
| `[d`          | Normal        | Previous diagnostic       |
| `]d`          | Normal        | Next diagnostic           |
| `<leader>e`   | Normal        | Show diagnostic details   |
| `<leader>q`   | Normal        | List diagnostics          |

### Workspace
| Keybinding    | Mode          | Description               |
|---------------|---------------|---------------------------|
| `<leader>wa`  | Normal        | Add workspace folder      |
| `<leader>wr`  | Normal        | Remove workspace folder   |
| `<leader>wl`  | Normal        | List workspace folders    |

## Language-Specific Features

Each language configuration provides specialized settings:

- **Python** (Pyright): 
  - Static type checking
  - Import organization
  - 4-space indentation
  - Virtual environment support

- **PHP** (Intelephense):
  - Stubs for common extensions
  - Class and function completion
  - 4-space indentation
  - PHP 8+ support

- **JavaScript/TypeScript** (TSServer):
  - Type inference
  - React/JSX support
  - 2-space indentation
  - Automatic imports

- **Go** (Gopls):
  - Tab indentation (Go standard)
  - Auto-import organization
  - Additional go-specific commands
  - Static analysis integration

- **Svelte** (Svelte Language Server):
  - Component intelligence
  - Template support
  - 2-space indentation
  - CSS/TypeScript integration within components

- **YAML** (YAML Language Server):
  - Schema validation
  - Kubernetes/Docker Compose support
  - 2-space indentation
  - Formatting

## Custom Commands

| Command         | Description                               |
|-----------------|-------------------------------------------|
| `:LspInfo`      | Show information about active LSP servers |
| `:LspStart [server]` | Start a specific language server     |
| `:LspStop [server]`  | Stop a specific language server      |
| `:LspRestart [server]` | Restart a specific language server |
| `:LspRestartAll`     | Restart all active language servers  |
| `:LspStatus`         | Show status of all LSP clients       |

## Automatic Features

- LSP servers automatically start when opening a supported file type
- Diagnostics update as you type
- Auto-formatting on save (when supported by the language server)
- Code completion integration with nvim-cmp

## Customization

To modify the behavior of the LSP configuration:

- Edit `common.lua` to change behavior for all language servers
- Edit language-specific files to change settings for individual languages
- Add new language support by creating additional language modules following the same pattern

