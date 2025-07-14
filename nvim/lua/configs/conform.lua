local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    sql = { "sql_formatter" },
    json = { "jq" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },
  formatters = {
    sql_formatter = {
      command = "sql-formatter",
      args = { "--language", "sql" },
    },
    jq = {
      command = "jq",
      args = { "." },
      stdin = true,
    },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
