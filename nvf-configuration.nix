{ pkgs, lib, ... }: {
  vim = {
    options = {
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
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
  };
}
