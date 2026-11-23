# Extra home-manager configuration, merged with home.nix
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
