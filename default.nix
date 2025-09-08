{
  config,
  lib,
  ...
}: let
  cfg = config.programs.nii-vaga-fun;
in {
  options.programs.nii-vaga-fun = {
    enable = lib.mkEnableOption "nii-vaga-fun";
    languages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["rust" "web" "nix" "pyhon" "java"];
      description = "Currently supports values: 'rust', 'web' (html+css), 'nix', 'python', 'java'";
    };
    tidalPlugin = lib.mkOption {
      type = lib.types.package;
      description = "Add your vim-tidal plugin package here";
    };
  };

  config = lib.mkIf cfg.enable {
    vim = {
      options = {
        tabstop = 2;
        shiftwidth = 2;
        #expandtab = true;
      };
      theme = {
        enable = true;
        name = "dracula";
        style = "dark";
      };
      telescope.enable = true;
      mini.statusline.enable = true;
      autocomplete.nvim-cmp.enable = true;
      autopairs.nvim-autopairs.enable = true;
      keymaps = [
        {
          key = "<leader>ff";
          mode = "n";
          silent = true;
          action = "require('telescope.builtin').find_files";
          lua = true;
        }
        {
          key = "<leader>fg";
          mode = "n";
          silent = true;
          action = "require('telescope.builtin').live_grep";
          lua = true;
        }
        {
          key = "<leader>bb";
          mode = "n";
          silent = true;
          action = "require('telescope.builtin').buffers";
          lua = true;
        }
      ];
      lsp = {
        enable = true;
        inlayHints.enable = true;
        formatOnSave = true;
      };
      languages = {
        rust = lib.mkIf (builtins.elem "rust" cfg.languages) {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
          format.enable = true;
        };
        html = lib.mkIf (builtins.elem "web" cfg.languages) {
          enable = true;
          treesitter.enable = true;
        };
        css = lib.mkIf (builtins.elem "web" cfg.languages) {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        nix = lib.mkIf (builtins.elem "nix" cfg.languages) {
          enable = true;
          treesitter.enable = true;
          lsp.enable = true;
          format.enable = true;
        };
        python = lib.mkIf (builtins.elem "python" cfg.languages) {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
          format.enable = true;
        };
        java = lib.mkIf (builtins.elem "java" cfg.languages) {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
        clang = lib.mkIf (builtins.elem "c" cfg.languages) {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
        };
      };
      extraPlugins = {
        tidal = lib.mkIf (builtins.elem "tidal" cfg.languages) {
          package = cfg.tidalPlugin;
          setup = ''
            vim.g.maplocalleader = ","
            vim.g.tidal_target = "terminal"
          '';
        };
      };
    };
  };
}
