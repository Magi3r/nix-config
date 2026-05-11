{
  inputs,
  den,
  ...
}: {
  flake-file.inputs = {
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";
  };
  den.aspects.desktop.niri = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.xwayland-satellite];
      services = {
        # login manager
        # greetd.enable = true;
        displayManager.defaultSession = "niri";
      };

      programs.niri.enable = true;

      nix.settings = {
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
      };
    };

    provides.to-users = {
      homeManager = {
        pkgs,
        # config,
        #inputs,
        ...
      }: {
        imports = [
          inputs.noctalia.homeModules.default
        ];

        xdg.configFile."niri/config.kdl".source = ../assets/config/niri/config.kdl;
        programs.noctalia-shell = {
          enable = true;
          package = pkgs.noctalia-shell;
        };
        xdg.configFile."noctalia/config.json".source = ../assets/config/noctalia/settings.json;
        home.file."Pictures/Wallpapers/tokyo_night-05.png".source = ../assets/wallpapers/tokyo_night-05.png;
        home.file.".face".source = ../assets/profile-pic.png;
      };
    };
  };
}
