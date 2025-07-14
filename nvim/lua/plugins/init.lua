return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vimdoc", "c", "lua", "vim", "vimdoc", "cpp",
        "java", "typescript", "javascript", "python",
        "html", "css", "json", "yaml", "astro", "bash"
  		},
  	},
  },

  {
    'zbirenbaum/copilot.lua',
    event = "InsertEnter",
    config = function ()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<C-l>",
            next = "<C-j>",
            prev = "<C-k>",
            dismiss = "<C-]>",
          },
        },
      })
    end
  },
}
