{
  den.aspects.desktop.provides.niri = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.xwayland-satellite];
      services = {
        # login manager
        # greetd.enable = true;
        displayManager.defaultSession = "niri";
      };

      programs.niri.enable = true;
    };

    flake-file.inputs = {
      noctalia.url = "github:noctalia-dev/noctalia-shell";
      noctalia.inputs.nixpkgs.follows = "nixpkgs";
    };

    homeManager = {
      pkgs,
      config,
      inputs,
      ...
    }: {
      xdg.configFile."niri/config.kdl".source = ./config.kdl;

      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia-shell = {
        enable = true;
        # package = pkgs.noctalia-shell;
      };

      home.file.".face" = {
        source = ../assets/profile-pic.png;
      };
    };
  };
}
