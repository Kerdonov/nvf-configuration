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
    languages = {
      rust.enable = true;
      nix.enable = true;
      python.enable = true;
      html.enable = true;
    };
  };
}
