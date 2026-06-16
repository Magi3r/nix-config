{
  inputs,
  den,
  __findFile,
  ...
}: {
  flake-file.inputs = {
    qylock.url = "github:Magi3r/qylock";
    qylock.inputs.nixpkgs.follows = "nixpkgs";
  };
  den.aspects.desktop.niri = {
    includes = [
      <noctalia-shell>
    ];
    nixos = {pkgs, ...}: {
      imports = [
        inputs.qylock.nixosModules.default
      ];
      environment.systemPackages = with pkgs; [
        xwayland-satellite # xwayland support
      ];
      services.displayManager = {
        # login manager
        sddm = {
          enable = true;
          enableHidpi = true;
          settings = {};
          wayland.enable = true;
          genshin = {
            enable = true;

            # backgroundMode = "random";
            # backgroundIndex = 3;
          };
        };
        defaultSession = "niri";
      };

      programs.niri.enable = true;
    };

    provides.to-users = {
      homeManager = {
        pkgs,
        # config,
        #inputs,
        ...
      }: {
        xdg.configFile."niri/config.kdl".source = ../assets/config/niri/config.kdl;
      };
    };
  };
}
