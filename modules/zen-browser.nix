{
  inputs,
  den,
  lib,
  ...
}: {
  flake-file.inputs = {
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  den.aspects.zen-browser = {user, ...}: {
    homeManager = {
      imports = lib.optional (inputs ? zen-browser) inputs.zen-browser.homeModules.default;

      programs.zen-browser = {
        enable = true;
      };
    };
  };
}
