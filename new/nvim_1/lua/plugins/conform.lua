return {
  'stevearc/conform.nvim',
  opts = {
  formatters_by_ft = {
    python = { "ruff_organize_imports", "ruff_format", "ruff_fix" },
    javascript = { { "prettierd", "prettier" } },
    css = { { "prettierd", "prettier" } },
    html = { { "prettierd", "prettier" } },
    astro = { { "prettierd", "prettier" } },
    nix = {"alejandra "},
    cpp = {"clang-format"} ,
    zig = {"zigfmt"},
    rust = {"rustfmt"},
    ["*"] = { "codespell" },
  },

  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 500,
  },
	}
	
}
