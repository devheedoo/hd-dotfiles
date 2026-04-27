vim.g.mapleader = " " -- <leader>를 Space 키로 설정
vim.g.maplocalleader = " " -- <localleader>도 Space 키로 설정

vim.opt.number = true -- 왼쪽에 줄 번호 표시
vim.opt.relativenumber = true -- 현재 줄 기준 상대 줄 번호 표시
vim.opt.termguicolors = true -- true color 지원
vim.opt.signcolumn = "yes" -- 진단/깃 표시 공간을 항상 보여줌
vim.opt.clipboard = "unnamedplus" -- 시스템 클립보드와 연동
vim.opt.expandtab = true -- Tab 입력 시 space로 변환
vim.opt.shiftwidth = 2 -- 들여쓰기 폭 2칸
vim.opt.tabstop = 2 -- Tab 표시 폭 2칸
vim.opt.smartindent = true -- 자동 들여쓰기
vim.opt.ignorecase = true -- 검색 시 대소문자 무시
vim.opt.smartcase = true -- 검색어에 대문자가 있으면 대소문자 구분

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        transparent_background = true,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",
          "jsonls",
          "html",
          "cssls",
          "eslint",
        },
      })
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          "prettier",
        },
        automatic_installation = true,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "javascript",
          "typescript",
          "tsx",
          "json",
          "html",
          "css",
          "lua",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>" }, -- Space + f + f: 파일 찾기
      { "<leader>fg", "<cmd>Telescope live_grep<cr>" }, -- Space + f + g: 프로젝트 전체 문자열 검색
      { "<leader>fb", "<cmd>Telescope buffers<cr>" }, -- Space + f + b: 현재 열린 버퍼 목록 보기
    },
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("ts_ls", {}) -- TypeScript/JavaScript LSP 설정
      vim.lsp.config("html", {}) -- HTML LSP 설정
      vim.lsp.config("cssls", {}) -- CSS LSP 설정
      vim.lsp.config("jsonls", {}) -- JSON LSP 설정
      vim.lsp.config("eslint", {
        settings = {
          format = true,
        },
      })
      vim.lsp.enable({
        "ts_ls",
        "html",
        "cssls",
        "jsonls",
        "eslint",
      })

      vim.keymap.set("n", "gd", vim.lsp.buf.definition) -- normal mode에서 g + d: 정의로 이동
      vim.keymap.set("n", "gr", vim.lsp.buf.references) -- normal mode에서 g + r: 참조 위치 목록 보기
      vim.keymap.set("n", "K", vim.lsp.buf.hover) -- normal mode에서 Shift + k: 타입/문서 hover 보기

      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename) -- Space + r + n: 변수/함수 이름 변경
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action) -- Space + c + a: quick fix/code action 열기
      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float) -- Space + d: 현재 줄 에러/경고 상세 보기

      vim.keymap.set("n", "<leader>bn", ":bnext<CR>") -- Space + b + n: 다음 버퍼
      vim.keymap.set("n", "<leader>bp", ":bprev<CR>") -- Space + b + p: 이전 버퍼

      vim.keymap.set("n", "<leader>tn", ":tabnext<CR>") -- Space + t + n: 다음 탭
      vim.keymap.set("n", "<leader>tp", ":tabprevious<CR>") -- Space + t + q: 이전 탭
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(), -- insert mode에서 Ctrl + Space: 자동완성 메뉴 열기
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- insert mode에서 Enter: 선택된 자동완성 항목 확정
          ["<Tab>"] = cmp.mapping.select_next_item(), -- insert mode에서 Tab: 다음 자동완성 항목 선택
          ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- insert mode에서 Shift + Tab: 이전 자동완성 항목 선택
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
          { name = "luasnip" },
        },
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
      })
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier,
        },
      })

      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end) -- Space + f: 현재 파일 포맷팅
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
