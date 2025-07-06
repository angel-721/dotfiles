return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      python = { "ruff_organize_imports", "ruff_format", "ruff_fix" },
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" }, -- Add TSX support
      javascriptreact = { "prettierd" }, -- Add JSX support
      css = { "prettierd" },
      html = { "prettierd" },
      astro = { "prettierd" },
      nix = { "alejandra" }, -- Fixed the space issue
      cpp = { "clang-format" },
      zig = { "zigfmt" },
      rust = { "rustfmt" },
			go = {"gofmt"},
      ["*"] = { "codespell" },
    },

    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 500,
    },

    formatters = {
      prettierd = {
        options = {
          tabWidth = 2,
          useTabs = false,
          semi = true,
          singleQuote = true,
          trailingComma = "es5",
          bracketSpacing = true,
          jsxSingleQuote = true,
          jsxBracketSameLine = false,
        }
      },
  	}
	}
}
