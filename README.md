# nvim-minimal

Minimal Neovim setup for React / TypeScript development in a terminal-first workflow.

> No bloated distro (LazyVim, AstroNvim).  
> Just the essentials: LSP, completion, formatting, search.

---

## ✨ Features

- ⚡ Fast startup (lazy.nvim)
- 🧠 LSP (TypeScript, JSON, HTML, CSS, ESLint)
- 🔍 Fuzzy finder (Telescope)
- 🌲 Syntax highlighting (Treesitter)
- 🤖 Autocomplete (nvim-cmp)
- 🎨 Tailwind class sorting (Prettier plugin)
- 💅 Format on save
- 🧩 Minimal plugins only

---

## 📦 Requirements

- Neovim >= 0.11
- Node.js (for LSP & tooling)
- Git
- ripgrep
- fd

### macOS (brew)

```bash
brew install neovim git ripgrep fd node
```

---

## 🚀 Installation

```bash
git clone https://github.com/<your-username>/hd-dotfiles
```

첫 실행 시:

```vim
:Lazy sync
```

---

## 🔗 Use as dotfiles (symlink)

You can use this config as your global Neovim setup via a symbolic link.

```bash
rm ~/.config/nvim/init.lua
ln -s ~/Development/hd-dotfiles/init.lua ~/.config/nvim/init.lua 
```

---

### Why use symlink?

- ✅ Single source of truth (Git-managed)
- ✅ Changes are applied instantly
- ✅ Easy to sync across machines

---

### ⚠️ Notes

- Use absolute paths to avoid broken links
- If you move the repo, recreate the symlink
- Backup existing config before replacing

---


## 🔧 LSP & Formatter

### Mason 기반 자동 설치

```vim
:Mason
```

설치 확인:

- ts_ls
- jsonls
- html
- cssls
- eslint
- prettier

---

## 🎨 Tailwind CSS 정렬

```bash
pnpm add -D prettier prettier-plugin-tailwindcss
```

.prettierrc

```json
{ "plugins": ["prettier-plugin-tailwindcss"] }
```

---

## 📁 Structure

bash ~/.config/nvim/init.lua

---

## 📄 License

MIT
