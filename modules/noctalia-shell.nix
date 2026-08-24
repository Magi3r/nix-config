{
  den,
  inputs,
  ...
}: {
  flake-file.inputs = {
    noctalia.url = "github:noctalia-dev/noctalia";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.noctalia-shell = {
    nixos = {
      nix.settings = {
        extra-substituters = ["https://noctalia.cachix.org"];
        extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
      };
    };
    provides.to-users = {
      homeManager = {pkgs, ...}: {
        imports = [
          inputs.noctalia.homeModules.default
        ];
        programs.noctalia = {
          enable = true;
        };
        xdg.configFile."noctalia/config.toml".source = ../assets/config/noctalia/config.toml;
        home.file."Pictures/Wallpapers/tokyo_night-05.png".source = ../assets/wallpapers/tokyo_night-05.png;
        home.file.".face".source = ../assets/profile-pic.png;
      };
    };
  };
}
