{ inputs, ... }: {
  imports = [ ./global ];
  colorscheme = inputs.nix-colors.colorSchemes.unikitty-dark;
}
