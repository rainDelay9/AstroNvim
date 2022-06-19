local impatient_ok, impatient = pcall(require, "impatient")
if impatient_ok then
  impatient.enable_profile()
end

vim.opt.rtp:append(vim.fn.stdpath "config" .. "/../astronvim")

for _, source in ipairs {
  "core.utils",
  "core.options",
  "core.plugins",
  "core.autocmds",
  "core.mappings",
  "core.ui",
  "configs.which-key-register",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then
    vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault)
  end
end

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'f-person/git-blame.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'itchyny/lightline.vim'
Plug 'simrat39/rust-tools.nvim'
Plug 'j-hui/fidget.nvim'
Plug 'neoclide/coc-git'
Plug 'junegunn/fzf.vim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'terryma/vim-expand-region'
Plug 'vim-autoformat/vim-autoformat'
vim.call('plug#end')

local opts = {
  -- rust-tools options
  tools = {
    autoSetHints = true,
    hover_with_actions = true,
    inlay_hints = {
      show_parameter_hints = true,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
      },
    },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
  -- https://rust-analyzer.github.io/manual.html#features
  server = {
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importEnforceGranularity = true,
          importPrefix = "crate"
          },
        cargo = {
          allFeatures = true
          },
        checkOnSave = {
          -- default: `cargo check`
          command = "clippy"
          },
        },
        inlayHints = {
          lifetimeElisionHints = {
            enable = true,
            useParameterNames = true
          },
        },
      }
    },
}

vim.cmd("au BufWrite * :Autoformat")

require('rust-tools').setup(opts)

astronvim.conditional_func(astronvim.user_plugin_opts("polish", nil, false))

--map("n", "v", ":<Plug>(expand_region_expand)", { silent = true })
--map("n", "<C-v>", ":<Plug>(expand_region_shrink)" { silent = true })

