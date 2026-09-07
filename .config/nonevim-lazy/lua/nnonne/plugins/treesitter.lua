return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    local ensure_installed = {
      -- "astro",
      "bash",
      -- "c",
      -- "caddy",
      "comment",
      -- "cpp",
      "css",
      "dart",
      "diff",
      "dockerfile",
      "ecma",
      "git_config",
      "gitattributes",
      "gitignore",
      -- "go",
      -- "goctl",
      -- "gomod",
      -- "gosum",
      "groovy",
      "html",
      "html_tags",
      "http",
      -- "java",
      -- "javadoc",
      "javascript",
      "jsdoc",
      "json",
      "json5",
      "jsx",
      -- "kitty",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      -- "nginx",
      -- "php",
      -- "phpdoc",
      "printf",
      "prisma",
      "python",
      "query",
      -- "rasi",
      "regex",
      "requirements",
      -- "ron",
      -- "rust",
      "sql",
      -- "ssh_config",
      -- "tmux",
      -- "toml",
      "tsx",
      "typescript",
      "typespec",
      -- "udev",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
      -- "zig",
      -- "zsh",
    }

    require("nvim-treesitter").install(ensure_installed)

    -- Shout out https://github.com/Sin-cy/dotfiles/blob/main/nvim-nightly/.config/nvim-nightly/lua/sethy/plugins/treesitter.lua
    local ts_group = vim.api.nvim_create_augroup("TreesitterNativeStart", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = ts_group,
      pattern = "*",
      callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)

        if not lang then
          return
        end

        -- load parser safely
        local ok_add = pcall(vim.treesitter.language.add, lang)
        if not ok_add then
          return
        end

        -- start treesitter safely
        pcall(vim.treesitter.start, buf, lang)

        -- enable indentation only for real languages
        local ok_start = pcall(vim.treesitter.start, buf, lang)
        if ok_start and ft ~= "yaml" and ft ~= "markdown" then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          vim.bo[buf].smartindent = false
          vim.bo[buf].cindent = false
        end
      end,
    })
  end
}
