# machine-local home-manager extension, symlinked into the repo like the shell rc files
{ pkgs, ... }:

{
  # packages to install (however prefer mise when possible)
  home.packages = with pkgs; [
    #
  ];

  # home-manager environment variables (however prefer mise to configure environment variables)
  home.sessionVariables = {
    # EDITOR = "vim";
  };
}
