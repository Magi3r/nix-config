{
  inputs,
  den,
  ...
}: {
  imports = [
    (inputs.flake-file.flakeModules.dendritic or {})
    (inputs.den.flakeModules.dendritic or {})
  ];

  _module.args.__findFile = den.lib.__findFile;

  # other inputs may be defined at a module using them.
  flake-file.inputs = {
    den.url = "github:denful/den/v0.17.0";
    flake-file.url = "github:denful/flake-file";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
